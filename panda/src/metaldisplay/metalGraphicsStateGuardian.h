/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalGraphicsStateGuardian.h
 * @author Michael
 * @date 2026-06-24
 */

#ifndef METALGRAPHICSSTATEGUARDIAN_H
#define METALGRAPHICSSTATEGUARDIAN_H

#include "config_metaldisplay.h"
#include "graphicsStateGuardian.h"

#ifdef __OBJC__
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#endif

class MetalGraphicsPipe;
class MetalGeomMunger;

class EXPCL_METALDISPLAY MetalGraphicsStateGuardian : public GraphicsStateGuardian {
public:
  MetalGraphicsStateGuardian(GraphicsEngine *engine, GraphicsPipe *pipe,
                             MetalGraphicsStateGuardian *share_with);
  virtual ~MetalGraphicsStateGuardian();

  virtual void reset() override;
  virtual void close_gsg() override;
  virtual bool prepare_lens() override;

  virtual std::string get_driver_vendor() override;
  virtual std::string get_driver_renderer() override;
  virtual std::string get_driver_version() override;

  virtual TextureContext *prepare_texture(Texture *tex) override;
  virtual bool update_texture(TextureContext *tc, bool force,
                              CompletionToken token = CompletionToken()) override;
  virtual void release_texture(TextureContext *tc) override;

  virtual SamplerContext *prepare_sampler(const SamplerState &sampler) override;
  virtual void release_sampler(SamplerContext *sc) override;

  virtual GeomContext *prepare_geom(Geom *geom) override;
  virtual void release_geom(GeomContext *gc) override;

  virtual ShaderContext *prepare_shader(Shader *shader) override;
  virtual void release_shader(ShaderContext *sc) override;

  virtual VertexBufferContext *prepare_vertex_buffer(GeomVertexArrayData *data) override;
  virtual void release_vertex_buffer(VertexBufferContext *vbc) override;

  virtual IndexBufferContext *prepare_index_buffer(GeomPrimitive *data) override;
  virtual void release_index_buffer(IndexBufferContext *ibc) override;

  virtual void clear(DrawableRegion *clearable) override;

  virtual bool begin_draw_primitives(const GeomPipelineReader *geom_reader,
                                     const GeomVertexDataPipelineReader *data_reader,
                                     const InstanceList *instances,
                                     bool force) override;
  virtual void end_draw_primitives() override;

  virtual bool draw_triangles(const GeomPrimitivePipelineReader *reader, bool force) override;
  virtual bool draw_lines(const GeomPrimitivePipelineReader *reader, bool force) override;
  virtual bool draw_points(const GeomPrimitivePipelineReader *reader, bool force) override;

#ifdef __OBJC__
  id<MTLDevice> get_metal_device() const { return _device; }
  void set_current_drawable(id<CAMetalDrawable> drawable);
#endif
  void present_and_commit();

private:
#ifdef __OBJC__
  id<MTLDevice> _device;
  id<MTLCommandQueue> _command_queue;
  id<CAMetalDrawable> _current_drawable;
  id<MTLCommandBuffer> _current_command_buffer;
  id<MTLRenderCommandEncoder> _current_render_encoder;
  id<MTLRenderPipelineState> _pipeline_state;
#endif
  void init_triangle_pipeline();

public:
  static TypeHandle get_class_type() {
    return _type_handle;
  }
  static void init_type() {
    GraphicsStateGuardian::init_type();
    register_type(_type_handle, "MetalGraphicsStateGuardian",
                  GraphicsStateGuardian::get_class_type());
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

#endif // METALGRAPHICSSTATEGUARDIAN_H
