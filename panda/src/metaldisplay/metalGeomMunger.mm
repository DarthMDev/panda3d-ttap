/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalGeomMunger.mm
 * @author Michael
 * @date 2026-06-24
 */

#include "metalGeomMunger.h"
#include "metalGraphicsStateGuardian.h"

TypeHandle MetalGeomMunger::_type_handle;

ALLOC_DELETED_CHAIN_DEF(MetalGeomMunger);

/**
 *
 */
MetalGeomMunger::
MetalGeomMunger(MetalGraphicsStateGuardian *gsg, const RenderState *state) :
  StandardMunger(gsg, state, 1, NT_packed_dabc, C_color) {
}

/**
 * Given a source GeomVertexFormat, converts it if necessary to the
 * appropriate format for rendering.
 */
CPT(GeomVertexFormat) MetalGeomMunger::
munge_format_impl(const GeomVertexFormat *orig,
                  const GeomVertexAnimationSpec &animation) {

  if (animation.get_animation_type() == AT_hardware) {
    PT(GeomVertexFormat) new_format = new GeomVertexFormat(*orig);
    new_format->set_animation(animation);

    new_format->remove_column(InternalName::get_transform_weight());
    new_format->remove_column(InternalName::get_transform_index());
    new_format->remove_column(InternalName::get_transform_blend());

    PT(GeomVertexArrayFormat) new_array_format = new GeomVertexArrayFormat;

    new_array_format->add_column
      (InternalName::get_transform_weight(), 4,
       NT_float32, C_other);

    new_array_format->add_column
      (InternalName::get_transform_index(), 4,
       NT_uint16, C_index);

    new_format->add_array(new_array_format);

    return GeomVertexFormat::register_format(new_format);
  } else {
    return orig;
  }
}
