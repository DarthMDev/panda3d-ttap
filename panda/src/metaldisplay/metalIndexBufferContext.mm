/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalIndexBufferContext.mm
 * @author Michael
 * @date 2026-06-24
 */

#include "metalIndexBufferContext.h"

TypeHandle MetalIndexBufferContext::_type_handle;

/**
 *
 */
MetalIndexBufferContext::
MetalIndexBufferContext(PreparedGraphicsObjects *pgo, GeomPrimitive *data) :
  IndexBufferContext(pgo, data) {
}

/**
 *
 */
MetalIndexBufferContext::
~MetalIndexBufferContext() {
}
