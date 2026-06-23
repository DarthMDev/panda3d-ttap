/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalShaderContext.h
 * @author Michael
 * @date 2026-06-24
 */

#ifndef METALSHADERCONTEXT_H
#define METALSHADERCONTEXT_H

#include "pandabase.h"
#include "shaderContext.h"

class EXPCL_METALDISPLAY MetalShaderContext : public ShaderContext {
public:
  MetalShaderContext(Shader *shader);
  virtual ~MetalShaderContext();

public:
  static TypeHandle get_class_type() {
    return _type_handle;
  }
  static void init_type() {
    ShaderContext::init_type();
    register_type(_type_handle, "MetalShaderContext",
                  ShaderContext::get_class_type());
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

#endif // METALSHADERCONTEXT_H
