$input v_wpos, v_view, v_normal, v_tangent, v_bitangent, v_texcoord0// in...

/*
 * Copyright 2011-2021 Branimir Karadzic. All rights reserved.
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 */

#include "../common/common.sh"

SAMPLER2D(s_texColor,  0);

void main()
{
	gl_FragColor = toLinear(texture2D(s_texColor, v_texcoord0) )
}
