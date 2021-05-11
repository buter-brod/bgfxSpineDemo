# Install script for directory: G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "C:/Program Files (x86)/Project")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/dist/lib" TYPE STATIC_LIBRARY FILES "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/bin/Debug/spine-cpp.lib")
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/dist/lib" TYPE STATIC_LIBRARY FILES "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/bin/Release/spine-cpp.lib")
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Mm][Ii][Nn][Ss][Ii][Zz][Ee][Rr][Ee][Ll])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/dist/lib" TYPE STATIC_LIBRARY FILES "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/bin/MinSizeRel/spine-cpp.lib")
  elseif("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ww][Ii][Tt][Hh][Dd][Ee][Bb][Ii][Nn][Ff][Oo])$")
    file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/dist/lib" TYPE STATIC_LIBRARY FILES "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/bin/RelWithDebInfo/spine-cpp.lib")
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/dist/include" TYPE FILE FILES
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Animation.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/AnimationState.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/AnimationStateData.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Atlas.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/AtlasAttachmentLoader.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Attachment.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/AttachmentLoader.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/AttachmentTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/AttachmentType.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/BlendMode.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Bone.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/BoneData.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/BoundingBoxAttachment.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/ClippingAttachment.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Color.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/ColorTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/ConstraintData.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/ContainerUtil.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/CurveTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Debug.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/DeformTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/DrawOrderTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Event.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/EventData.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/EventTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Extension.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/HasRendererObject.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/HashMap.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/IkConstraint.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/IkConstraintData.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/IkConstraintTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Json.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/LinkedMesh.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/MathUtil.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/MeshAttachment.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/MixBlend.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/MixDirection.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/PathAttachment.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/PathConstraint.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/PathConstraintData.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/PathConstraintMixTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/PathConstraintPositionTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/PathConstraintSpacingTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/PointAttachment.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Pool.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/PositionMode.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/RTTI.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/RegionAttachment.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/RotateMode.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/RotateTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/ScaleTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/ShearTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Skeleton.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/SkeletonBinary.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/SkeletonBounds.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/SkeletonClipping.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/SkeletonData.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/SkeletonJson.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Skin.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Slot.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/SlotData.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/SpacingMode.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/SpineObject.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/SpineString.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/TextureLoader.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Timeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/TimelineType.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/TransformConstraint.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/TransformConstraintData.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/TransformConstraintTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/TransformMode.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/TranslateTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Triangulator.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/TwoColorTimeline.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Updatable.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Vector.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/VertexAttachment.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/VertexEffect.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/Vertices.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/dll.h"
    "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/spine-cpp/include/spine/spine.h"
    )
endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "G:/Documents/Programming/bgfxSpine/repos/spine-runtimes-3.8/spine-cpp/bin/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
