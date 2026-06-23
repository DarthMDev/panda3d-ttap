/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalVertexBufferContext.h
 * @author Michael
 * @date 2026-06-24
 */

#ifndef METALVERTEXBUFFERCONTEXT_H
#define METALVERTEXBUFFERCONTEXT_H

#include "pandabase.h"
#include "vertexBufferContext.h"

class EXPCL_METALDISPLAY MetalVertexBufferContext : public VertexBufferContext {
public:
  MetalVertexBufferContext(PreparedGraphicsObjects *pgo, GeomVertexArrayData *data);
  virtual ~MetalVertexBufferContext();

public:
  static TypeHandle get_class_type() {
    return _type_handle;
  }
  static void init_type() {
    VertexBufferContext::init_type();
    register_type(_type_handle, "MetalVertexBufferContext",
                  VertexBufferContext::get_class_type());
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

#endif // METALVERTEXBUFFERCONTEXT_H
