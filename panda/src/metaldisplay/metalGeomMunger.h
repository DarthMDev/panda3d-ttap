/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalGeomMunger.h
 * @author Michael
 * @date 2026-06-24
 */

#ifndef METALGEOMMUNGER_H
#define METALGEOMMUNGER_H

#include "pandabase.h"
#include "standardMunger.h"

class MetalGraphicsStateGuardian;

/**
 * This specialization on GeomMunger finesses vertices for Metal rendering.
 */
class EXPCL_METALDISPLAY MetalGeomMunger final : public StandardMunger {
public:
  MetalGeomMunger(MetalGraphicsStateGuardian *gsg, const RenderState *state);
  ALLOC_DELETED_CHAIN_DECL(MetalGeomMunger);

protected:
  virtual CPT(GeomVertexFormat) munge_format_impl(const GeomVertexFormat *orig,
                                                  const GeomVertexAnimationSpec &animation) override;

public:
  static TypeHandle get_class_type() {
    return _type_handle;
  }
  static void init_type() {
    StandardMunger::init_type();
    register_type(_type_handle, "MetalGeomMunger",
                  StandardMunger::get_class_type());
  }
  virtual TypeHandle get_type() const override {
    return get_class_type();
  }
  virtual TypeHandle force_init_type() override {
    init_type();
    return get_class_type();
  }

private:
  static TypeHandle _type_handle;
};

#endif // METALGEOMMUNGER_H
