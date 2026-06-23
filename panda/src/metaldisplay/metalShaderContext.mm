/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalShaderContext.mm
 * @author Michael
 * @date 2026-06-24
 */

#include "metalShaderContext.h"

TypeHandle MetalShaderContext::_type_handle;

/**
 *
 */
MetalShaderContext::
MetalShaderContext(Shader *shader) :
  ShaderContext(shader) {
}

/**
 *
 */
MetalShaderContext::
~MetalShaderContext() {
}
