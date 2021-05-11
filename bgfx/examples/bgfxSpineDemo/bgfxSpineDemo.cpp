#include "common.h"
#include "bgfx_utils.h"
#include "../../../spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/spine.h"

#include <spine/Extension.h>
#include <memory>
#include <set>
#include <string>
#include <vector>

constexpr float camDistance = 10.f;
constexpr float spineScale = 0.01f;

const char* spineDemoAtlasFilename = "res/alien.atlas";
const char* spineDemoJsonFilename = "res/alien-ess.json";
const char* animationName = "run";

const char* vsShaderFilename = "vs_bgfxSpineDemo";
const char* fsShaderFilename = "fs_bgfxSpineDemo";

spine::SpineExtension* spine::getDefaultExtension()
{
	return new spine::DefaultSpineExtension();
}

struct QuadCoord
{
	float m_x = 0.f;
	float m_y = 0.f;
	float m_z = 0.f;
	int16_t m_u = 0;
	int16_t m_v = 0;
};

bgfx::VertexLayout vertexLayout;

struct Texture
{
	Texture(const bgfx::TextureInfo& texInfo, const bgfx::TextureHandle& texHandle) : info(texInfo), handle(texHandle) {}

	bgfx::TextureInfo info;
	bgfx::TextureHandle handle;

	~Texture()
	{
		bgfx::destroy(handle);
	}
};

class TextureManager
{
public:
	Texture* AddTexture(const bgfx::TextureInfo& texInfo, const bgfx::TextureHandle& texHandle)
	{
		const auto texCopyPtr = std::make_shared<Texture>(texInfo, texHandle);
		const auto where = _textures.insert(texCopyPtr);
		auto* texPtrRaw = where.first->get();
		return texPtrRaw;
	}

	void Clear()
	{
		_textures.clear();
	}

protected:
	std::set<std::shared_ptr<Texture> > _textures;
};

class BGFXSpineTextureLoader : public spine::TextureLoader
{
public:

	BGFXSpineTextureLoader(TextureManager* mgr) : _texMgr(mgr) {}

	void load(spine::AtlasPage& page, const spine::String& path) override
	{
		bgfx::TextureInfo texInfo;
		const bgfx::TextureHandle texHandle = loadTexture(path.buffer(), BGFX_TEXTURE_NONE | BGFX_SAMPLER_NONE, 0, &texInfo);
		auto* texPtr = _texMgr->AddTexture(texInfo, texHandle);

		page.setRendererObject(texPtr);

		page.width = texInfo.width;
		page.height = texInfo.height;
	}

	void unload(void* texture) override
	{
		texture = nullptr;
	}

protected:
	TextureManager* _texMgr = nullptr;
};

std::shared_ptr<spine::SkeletonData> readSkeletonJsonData(const spine::String& filename, spine::Atlas* atlas, float scale)
{
	spine::SkeletonJson json(atlas);
	json.setScale(scale);
	const auto skeletonData = json.readSkeletonDataFile(filename);
	if (!skeletonData)
	{
		printf("%s\n", json.getError().buffer());
		exit(0);
	}

	return std::shared_ptr<spine::SkeletonData>(skeletonData);
}

struct Vertex2D
{
	float positionX = 0.f;
	float positionY = 0.f;
	float positionZ = 0.f;

	int16_t texCoordsXI = 0;
	int16_t texCoordsYI = 0;

	uint8_t colorR = 0;
	uint8_t colorG = 0;
	uint8_t colorB = 0;
	uint8_t colorA = 0;
};

class SkeletonDrawable
{
public:
	const bgfx::VertexBufferHandle& GetVertexBufferHandle() const {return vertexBufferHandle;}
	const Texture* GetTexture() const {return texture;}

	void SetAnimation(const std::string& animName)
	{
		currAnimation = animName;
		state->setAnimation(0, animName.c_str(), true);
	}

	const std::string& GetAnimation() const {
		return currAnimation;
	}

private:
	float timeScale;
	std::vector<QuadCoord> vertexArray;
	std::vector<int> indexArray;

	spine::VertexEffect* vertexEffect = nullptr;
	spine::Skeleton* skeleton = nullptr;
	spine::AnimationState* state = nullptr;
	Texture* texture = nullptr;
	
	mutable bool ownsAnimationStateData {false};
	mutable spine::Vector<float> worldVertices;
	mutable spine::Vector<float> tempUvs;
	mutable spine::Vector<spine::Color> tempColors;
	mutable spine::Vector<unsigned short> quadIndices;
	mutable spine::SkeletonClipping clipper;

	bgfx::VertexBufferHandle vertexBufferHandle;

	std::string currAnimation;

public:
	explicit SkeletonDrawable(spine::SkeletonData* skeletonData, spine::AnimationStateData* stateData = nullptr) :
		timeScale(1)
	{
		spine::Bone::setYDown(true);
		skeleton = new spine::Skeleton(skeletonData);
		tempUvs.ensureCapacity(16);
		tempColors.ensureCapacity(16);

		ownsAnimationStateData = stateData == nullptr;
		if (ownsAnimationStateData) stateData = new(__FILE__, __LINE__) spine::AnimationStateData(skeletonData);

		state = new spine::AnimationState(stateData);

		quadIndices.add(0);
		quadIndices.add(1);
		quadIndices.add(2);
		quadIndices.add(2);
		quadIndices.add(3);
		quadIndices.add(0);

		vertexBufferHandle.idx = bgfx::kInvalidHandle;
	}

	~SkeletonDrawable() {}

	void update(const float deltaTime) const
	{
		skeleton->update(deltaTime);
		state->update(deltaTime * timeScale);
		state->apply(*skeleton);
		skeleton->updateWorldTransform();
	}

	Texture* getTexure() const
	{
		return texture;
	}

	const std::vector<QuadCoord>& getVertexArray() const
	{
		return vertexArray;
	}

	virtual void prepareVertices()
	{
		vertexArray.clear();

		// Early out if skeleton is invisible
		if (skeleton->getColor().a == 0) return;

		if (vertexEffect != nullptr) vertexEffect->begin(*skeleton);

		QuadCoord vertex;

		for (unsigned i = 0; i < skeleton->getSlots().size(); ++i)
		{
			spine::Slot& slot = *skeleton->getDrawOrder()[i];
			spine::Attachment* attachment = slot.getAttachment();
			if (!attachment) continue;

			// Early out if the slot color is 0 or the bone is not active
			if (slot.getColor().a == 0 || !slot.getBone().isActive())
			{
				clipper.clipEnd(slot);
				continue;
			}

			spine::Vector<float>* vertices = &worldVertices;
			size_t verticesCount = 0;
			spine::Vector<float>* uvs = nullptr;
			spine::Vector<unsigned short>* indices = nullptr;
			size_t indicesCount = 0;
			spine::Color* attachmentColor;

			if (attachment->getRTTI().isExactly(spine::RegionAttachment::rtti))
			{
				auto* regionAttachment = static_cast<spine::RegionAttachment*>(attachment);
				attachmentColor = &regionAttachment->getColor();

				// Early out if the slot color is 0
				if (attachmentColor->a == 0)
				{
					clipper.clipEnd(slot);
					continue;
				}

				worldVertices.setSize(8, 0);
				regionAttachment->computeWorldVertices(slot.getBone(), worldVertices, 0, 2);
				verticesCount = 4;
				uvs = &regionAttachment->getUVs();
				indices = &quadIndices;
				indicesCount = 6;

				auto* atlasRegion = static_cast<spine::AtlasRegion*>(regionAttachment->getRendererObject());
				texture = static_cast<Texture*>(atlasRegion->page->getRendererObject());

			}
			else if (attachment->getRTTI().isExactly(spine::MeshAttachment::rtti))
			{
				auto* mesh = static_cast<spine::MeshAttachment*>(attachment);
				attachmentColor = &mesh->getColor();

				// Early out if the slot color is 0
				if (attachmentColor->a == 0)
				{
					clipper.clipEnd(slot);
					continue;
				}

				worldVertices.setSize(mesh->getWorldVerticesLength(), 0);
				texture = static_cast<Texture*>(static_cast<spine::AtlasRegion*>(mesh->getRendererObject())->page->getRendererObject());

				mesh->computeWorldVertices(slot, 0, mesh->getWorldVerticesLength(), worldVertices, 0, 2);
				verticesCount = mesh->getWorldVerticesLength() >> 1;
				uvs = &mesh->getUVs();
				indices = &mesh->getTriangles();
				indicesCount = mesh->getTriangles().size();

			}
			else if (attachment->getRTTI().isExactly(spine::ClippingAttachment::rtti))
			{
				auto* clip = static_cast<spine::ClippingAttachment*>(slot.getAttachment());
				clipper.clipStart(slot, clip);
				continue;

			}
			else continue;

			const auto r = static_cast<uint8_t>(skeleton->getColor().r * slot.getColor().r * attachmentColor->r * 255);
			const auto g = static_cast<uint8_t>(skeleton->getColor().g * slot.getColor().g * attachmentColor->g * 255);
			const auto b = static_cast<uint8_t>(skeleton->getColor().b * slot.getColor().b * attachmentColor->b * 255);
			const auto a = static_cast<uint8_t>(skeleton->getColor().a * slot.getColor().a * attachmentColor->a * 255);

			spine::Color light;
			light.r = r / 255.0f;
			light.g = g / 255.0f;
			light.b = b / 255.0f;
			light.a = a / 255.0f;

			if (clipper.isClipping())
			{
				clipper.clipTriangles(worldVertices, *indices, *uvs, 2);
				vertices = &clipper.getClippedVertices();
				verticesCount = clipper.getClippedVertices().size() >> 1;
				uvs = &clipper.getClippedUVs();
				indices = &clipper.getClippedTriangles();
				indicesCount = clipper.getClippedTriangles().size();
			}

			if (vertexEffect != nullptr)
			{
				tempUvs.clear();
				tempColors.clear();
				for (size_t ii = 0; ii < verticesCount; ii++)
				{
					spine::Color vertexColor = light;
					spine::Color dark;
					dark.r = dark.g = dark.b = dark.a = 0;
					const size_t index = ii << 1;
					float x = (*vertices)[index];
					float y = (*vertices)[index + 1];
					float u = (*uvs)[index];
					float v = (*uvs)[index + 1];
					vertexEffect->transform(x, y, u, v, vertexColor, dark);
					(*vertices)[index] = x;
					(*vertices)[index + 1] = y;
					tempUvs.add(u);
					tempUvs.add(v);
					tempColors.add(vertexColor);
				}

				for (size_t ii = 0; ii < indicesCount; ++ii)
				{
					int index = (*indices)[ii] << 1;

					vertex.m_x = (*vertices)[index];
					vertex.m_y = (*vertices)[index + 1];

					vertex.m_u = static_cast<int16_t>(static_cast<float>(0x7fff) * (*uvs)[index]);
					vertex.m_v = static_cast<int16_t>(static_cast<float>(0x7fff) * (*uvs)[index + 1]);

					spine::Color vertexColor = tempColors[index >> 1];
					vertexArray.push_back(vertex);
				}
			}
			else
			{
				for (size_t ii = 0; ii < indicesCount; ++ii)
				{
					int index = (*indices)[ii] << 1;

					vertex.m_x = (*vertices)[index];
					vertex.m_y = (*vertices)[index + 1];

					vertex.m_u = static_cast<int16_t>(static_cast<float>(0x7fff) * (*uvs)[index]);
					vertex.m_v = static_cast<int16_t>(static_cast<float>(0x7fff) * (*uvs)[index + 1]);

					vertexArray.push_back(vertex);
				}
			}
			clipper.clipEnd(slot);
		}

		indexArray.clear();
		for (size_t i = 0; i < vertexArray.size(); i++)
			indexArray.push_back((int)i);

		clipper.clipEnd();

		if (vertexEffect != 0) vertexEffect->end();

		if (bgfx::isValid(vertexBufferHandle))
			bgfx::destroy(vertexBufferHandle);

		vertexBufferHandle = bgfx::createVertexBuffer(
			bgfx::makeRef(vertexArray.data(), static_cast<uint32_t>(vertexArray.size()) * sizeof(QuadCoord))
			, vertexLayout
		);
	}
};

class BGFXSpineDemo : public entry::AppI
{
public:
	BGFXSpineDemo(const char* _name, const char* _description, const char* _url)
		: entry::AppI(_name, _description, _url)
	{
	}

	void init(int32_t _argc, const char* const* _argv, uint32_t _width, uint32_t _height) override
	{
		const Args args(_argc, _argv);

		m_width = _width;
		m_height = _height;
		m_debug = BGFX_DEBUG_NONE;
		m_reset = BGFX_RESET_VSYNC;

		bgfx::Init init;
		init.type = args.m_type;
		init.vendorId = args.m_pciId;
		init.resolution.width = m_width;
		init.resolution.height = m_height;
		init.resolution.reset = m_reset;
		bgfx::init(init);

		// Enable debug text.
		bgfx::setDebug(m_debug);

		// Set view 0 clear state.
		bgfx::setViewClear(0
			, BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH
			, 0x303030ff
			, 1.0f
			, 0
		);

		vertexLayout
			.begin()
			.add(bgfx::Attrib::Position, 3, bgfx::AttribType::Float)
			.add(bgfx::Attrib::TexCoord0, 2, bgfx::AttribType::Int16, true, true)
			.end();

		// Create texture sampler uniforms.
		s_texColor = bgfx::createUniform("s_texColor", bgfx::UniformType::Sampler);
		
		// Create program from shaders.
		m_program = loadProgram(vsShaderFilename, fsShaderFilename);

		m_timeOffset = bx::getHPCounter();

		textureLoader = std::make_shared<BGFXSpineTextureLoader>(&textureManager);
		atlas = std::make_unique<spine::Atlas>(spineDemoAtlasFilename, textureLoader.get());

		skeletonData = readSkeletonJsonData(spineDemoJsonFilename, atlas.get(), 1.f);
		skeletonDrawable = std::make_shared<SkeletonDrawable>(skeletonData.get());
	}

	int shutdown() override
	{
		textureManager.Clear();
		atlas.reset();

		bgfx::destroy(m_program);
		bgfx::destroy(s_texColor);

		bgfx::shutdown();

		return 0;
	}

	bool update() override
	{
		if (!entry::processEvents(m_width, m_height, m_debug, m_reset, &m_mouseState))
		{
			// Set view 0 default viewport.
			bgfx::setViewRect(0, 0, 0, static_cast<uint16_t>(m_width), static_cast<uint16_t>(m_height));

			// This dummy draw call is here to make sure that view 0 is cleared
			// if no other draw calls are submitted to view 0.
			bgfx::touch(0);

			const auto currTick = bx::getHPCounter();
			const auto dt = static_cast<float>((currTick - m_timeLast) / static_cast<double>(bx::getHPFrequency()));
			m_timeLast = currTick;

			skeletonDrawable->update(dt);
			skeletonDrawable->prepareVertices();

			// set view
			{
				const bx::Vec3 at = { 0.0f, 0.0f,  0.0f };
				const bx::Vec3 eye = { 0.0f, 0.0f, -camDistance };

				float viewMat[16];
				bx::mtxLookAt(viewMat, eye, at);

				float projMat[16];
				bx::mtxProj(projMat, 60.0f, static_cast<float>(m_width) / static_cast<float>(m_height), 0.1f, 100.0f, bgfx::getCaps()->homogeneousDepth);
				bgfx::setViewTransform(0, viewMat, projMat);
				bgfx::setViewRect(0, 0, 0, static_cast<uint16_t>(m_width), static_cast<uint16_t>(m_height));
			}

			// set model transform
			{
				float scaleMat[16];
				// inverting spine Y 
				bx::mtxScale(scaleMat, spineScale, -spineScale, spineScale);
				bgfx::setTransform(scaleMat);
			}

			// rendering spine model
			{
				bgfx::setState(BGFX_STATE_WRITE_RGB	| BGFX_STATE_BLEND_ALPHA);

				bgfx::setVertexBuffer(0, skeletonDrawable->GetVertexBufferHandle());
				bgfx::setTexture(0, s_texColor, skeletonDrawable->GetTexture()->handle);
				bgfx::submit(0, m_program);

				bgfx::frame();
			}

			// starting animation if needed
			if (skeletonDrawable->GetAnimation().empty()) {
				skeletonDrawable->SetAnimation(animationName);			
			}
			
			return true;
		}

		return false;
	}

	entry::MouseState m_mouseState;
	
	bgfx::UniformHandle s_texColor;
	bgfx::ProgramHandle m_program;

	std::shared_ptr<spine::SkeletonData> skeletonData;
	std::shared_ptr<BGFXSpineTextureLoader> textureLoader;

	uint32_t m_width = 0;
	uint32_t m_height = 0;
	uint32_t m_debug = 0;
	uint32_t m_reset = 0;
	int64_t m_timeOffset = 0;
	int64_t m_timeLast = 0;

	TextureManager textureManager;

	std::shared_ptr<SkeletonDrawable> skeletonDrawable;
	std::unique_ptr<spine::Atlas> atlas;
};

ENTRY_IMPLEMENT_MAIN(
	BGFXSpineDemo
	, "bgfxSpine"
	, ""
	, ""
);
