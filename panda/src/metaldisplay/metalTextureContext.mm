/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalTextureContext.mm
 * @author Michael
 * @date 2026-06-24
 */

#include "metalTextureContext.h"

TypeHandle MetalTextureContext::_type_handle;

/**
 *
 */
MetalTextureContext::
MetalTextureContext(PreparedGraphicsObjects *pgo, Texture *texture) :
  TextureContext(pgo, texture) {
}

/**
 *
 */
MetalTextureContext::
~MetalTextureContext() {
}
