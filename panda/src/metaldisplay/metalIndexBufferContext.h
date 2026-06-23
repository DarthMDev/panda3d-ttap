/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalIndexBufferContext.h
 * @author Michael
 * @date 2026-06-24
 */

#ifndef METALINDEXBUFFERCONTEXT_H
#define METALINDEXBUFFERCONTEXT_H

#include "pandabase.h"
#include "indexBufferContext.h"

class EXPCL_METALDISPLAY MetalIndexBufferContext : public IndexBufferContext {
public:
  MetalIndexBufferContext(PreparedGraphicsObjects *pgo, GeomPrimitive *data);
  virtual ~MetalIndexBufferContext();

public:
  static TypeHandle get_class_type() {
    return _type_handle;
  }
  static void init_type() {
    IndexBufferContext::init_type();
    register_type(_type_handle, "MetalIndexBufferContext",
                  IndexBufferContext::get_class_type());
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

#endif // METALINDEXBUFFERCONTEXT_H
