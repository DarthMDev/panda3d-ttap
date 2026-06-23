/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalGraphicsStateGuardian.mm
 * @author Michael
 * @date 2026-06-24
 */

#include "metalGraphicsStateGuardian.h"
#include "metalGraphicsPipe.h"
#include "metalGeomMunger.h"

TypeHandle MetalGraphicsStateGuardian::_type_handle;

/**
 *
 */
MetalGraphicsStateGuardian::
MetalGraphicsStateGuardian(GraphicsEngine *engine, GraphicsPipe *pipe,
                           MetalGraphicsStateGuardian *share_with) :
  GraphicsStateGuardian(CS_yup_right, engine, pipe)
{
  _device = MTLCreateSystemDefaultDevice();
  if (_device != nil) {
    _command_queue = [_device newCommandQueue];
  }
  _current_drawable = nil;
  _current_command_buffer = nil;
  _current_render_encoder = nil;
  _pipeline_state = nil;
}

/**
 *
 */
MetalGraphicsStateGuardian::
~MetalGraphicsStateGuardian() {
  [_pipeline_state release];
  _pipeline_state = nil;
  if (_current_render_encoder != nil) {
    [_current_render_encoder endEncoding];
    [_current_render_encoder release];
    _current_render_encoder = nil;
  }
  [_current_command_buffer release];
  _current_command_buffer = nil;
  [_current_drawable release];
  _current_drawable = nil;
  [_command_queue release];
  _command_queue = nil;
  [_device release];
  _device = nil;
}

/**
 *
 */
void MetalGraphicsStateGuardian::
reset() {
  GraphicsStateGuardian::reset();
}

/**
 *
 */
void MetalGraphicsStateGuardian::
close_gsg() {
  if (_current_render_encoder != nil) {
    [_current_render_encoder endEncoding];
    [_current_render_encoder release];
    _current_render_encoder = nil;
  }
  [_current_command_buffer release];
  _current_command_buffer = nil;
  [_current_drawable release];
  _current_drawable = nil;
  [_pipeline_state release];
  _pipeline_state = nil;

  GraphicsStateGuardian::close_gsg();
}

/**
 *
 */
bool MetalGraphicsStateGuardian::
prepare_lens() {
  return true;
}

/**
 *
 */
std::string MetalGraphicsStateGuardian::
get_driver_vendor() {
  return "Apple";
}

/**
 *
 */
std::string MetalGraphicsStateGuardian::
get_driver_renderer() {
  if (_device != nil) {
    return [[_device name] UTF8String];
  }
  return "Unknown Metal Device";
}

/**
 *
 */
std::string MetalGraphicsStateGuardian::
get_driver_version() {
  return "Metal";
}

/**
 *
 */
TextureContext *MetalGraphicsStateGuardian::
prepare_texture(Texture *tex) {
  return nullptr;
}

/**
 *
 */
bool MetalGraphicsStateGuardian::
update_texture(TextureContext *tc, bool force, CompletionToken token) {
  return true;
}

/**
 *
 */
void MetalGraphicsStateGuardian::
release_texture(TextureContext *tc) {
}

/**
 *
 */
SamplerContext *MetalGraphicsStateGuardian::
prepare_sampler(const SamplerState &sampler) {
  return nullptr;
}

/**
 *
 */
void MetalGraphicsStateGuardian::
release_sampler(SamplerContext *sc) {
}

/**
 *
 */
GeomContext *MetalGraphicsStateGuardian::
prepare_geom(Geom *geom) {
  return nullptr;
}

/**
 *
 */
void MetalGraphicsStateGuardian::
release_geom(GeomContext *gc) {
}

/**
 *
 */
ShaderContext *MetalGraphicsStateGuardian::
prepare_shader(Shader *shader) {
  return nullptr;
}

/**
 *
 */
void MetalGraphicsStateGuardian::
release_shader(ShaderContext *sc) {
}

/**
 *
 */
VertexBufferContext *MetalGraphicsStateGuardian::
prepare_vertex_buffer(GeomVertexArrayData *data) {
  return nullptr;
}

/**
 *
 */
void MetalGraphicsStateGuardian::
release_vertex_buffer(VertexBufferContext *vbc) {
}

/**
 *
 */
IndexBufferContext *MetalGraphicsStateGuardian::
prepare_index_buffer(GeomPrimitive *data) {
  return nullptr;
}

/**
 *
 */
void MetalGraphicsStateGuardian::
release_index_buffer(IndexBufferContext *ibc) {
}

/**
 *
 */
void MetalGraphicsStateGuardian::
clear(DrawableRegion *clearable) {
  if (_current_drawable == nil || _current_command_buffer == nil) {
    return;
  }

  LColor clear_color = LColor::zero();
  if (clearable->get_clear_color_active()) {
    clear_color = clearable->get_clear_color();
  }

  MTLRenderPassDescriptor *passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
  passDescriptor.colorAttachments[0].texture = _current_drawable.texture;
  passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
  passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(clear_color[0], clear_color[1], clear_color[2], clear_color[3]);
  passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;

  if (_current_render_encoder != nil) {
    [_current_render_encoder endEncoding];
    [_current_render_encoder release];
  }
  _current_render_encoder = [[_current_command_buffer renderCommandEncoderWithDescriptor:passDescriptor] retain];
}

/**
 *
 */
bool MetalGraphicsStateGuardian::
begin_draw_primitives(const GeomPipelineReader *geom_reader,
                      const GeomVertexDataPipelineReader *data_reader,
                      const InstanceList *instances,
                      bool force) {
  if (!GraphicsStateGuardian::begin_draw_primitives(geom_reader, data_reader, instances, force)) {
    return false;
  }
  return true;
}

/**
 *
 */
void MetalGraphicsStateGuardian::
end_draw_primitives() {
}

/**
 *
 */
bool MetalGraphicsStateGuardian::
draw_triangles(const GeomPrimitivePipelineReader *reader, bool force) {
  return true;
}

/**
 *
 */
bool MetalGraphicsStateGuardian::
draw_lines(const GeomPrimitivePipelineReader *reader, bool force) {
  return true;
}

/**
 *
 */
bool MetalGraphicsStateGuardian::
draw_points(const GeomPrimitivePipelineReader *reader, bool force) {
  return true;
}

/**
 * Sets the current frame drawable. Called by the window.
 */
void MetalGraphicsStateGuardian::
set_current_drawable(id<CAMetalDrawable> drawable) {
  if (_current_drawable != drawable) {
    [_current_drawable release];
    _current_drawable = [drawable retain];
  }
  if (_command_queue != nil) {
    if (_current_command_buffer != nil) {
      [_current_command_buffer release];
    }
    _current_command_buffer = [[_command_queue commandBuffer] retain];
  }
}

/**
 * Flips and commits the command buffer.
 */
void MetalGraphicsStateGuardian::
init_triangle_pipeline() {
  if (_pipeline_state != nil || _device == nil) {
    return;
  }

  NSError *error = nil;
  NSString *shaderSource =
    @"#include <metal_stdlib>\n"
    "using namespace metal;\n"
    "struct VertexOut {\n"
    "    float4 position [[position]];\n"
    "    float4 color;\n"
    "};\n"
    "vertex VertexOut vertexShader(uint vertexID [[vertex_id]]) {\n"
    "    float3 positions[3] = {\n"
    "        float3(0.0, 0.5, 0.0),\n"
    "        float3(-0.5, -0.5, 0.0),\n"
    "        float3(0.5, -0.5, 0.0)\n"
    "    };\n"
    "    float3 colors[3] = {\n"
    "        float3(1.0, 0.0, 0.0),\n"
    "        float3(0.0, 1.0, 0.0),\n"
    "        float3(0.0, 0.0, 1.0)\n"
    "    };\n"
    "    VertexOut out;\n"
    "    out.position = float4(positions[vertexID], 1.0);\n"
    "    out.color = float4(colors[vertexID], 1.0);\n"
    "    return out;\n"
    "}\n"
    "fragment float4 fragmentShader(VertexOut in [[stage_in]]) {\n"
    "    return in.color;\n"
    "}\n";

  id<MTLLibrary> library = [_device newLibraryWithSource:shaderSource options:nil error:&error];
  if (library == nil) {
    NSLog(@"Failed to compile triangle shaders: %@", error);
    return;
  }

  id<MTLFunction> vertexFunc = [library newFunctionWithName:@"vertexShader"];
  id<MTLFunction> fragmentFunc = [library newFunctionWithName:@"fragmentShader"];

  MTLRenderPipelineDescriptor *pipelineDesc = [[MTLRenderPipelineDescriptor alloc] init];
  pipelineDesc.vertexFunction = vertexFunc;
  pipelineDesc.fragmentFunction = fragmentFunc;
  pipelineDesc.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;

  _pipeline_state = [[_device newRenderPipelineStateWithDescriptor:pipelineDesc error:&error] retain];
  if (_pipeline_state == nil) {
    NSLog(@"Failed to create pipeline state: %@", error);
  }

  [pipelineDesc release];
  [vertexFunc release];
  [fragmentFunc release];
  [library release];
}

void MetalGraphicsStateGuardian::
present_and_commit() {
  if (_current_command_buffer != nil) {
    init_triangle_pipeline();

    if (_current_render_encoder == nil && _current_drawable != nil) {
      MTLRenderPassDescriptor *passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
      passDescriptor.colorAttachments[0].texture = _current_drawable.texture;
      passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
      passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.1, 0.1, 0.1, 1.0);
      passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
      _current_render_encoder = [[_current_command_buffer renderCommandEncoderWithDescriptor:passDescriptor] retain];
    }

    if (_current_render_encoder != nil) {
      if (_pipeline_state != nil) {
        [_current_render_encoder setRenderPipelineState:_pipeline_state];
        [_current_render_encoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
      }
      [_current_render_encoder endEncoding];
      [_current_render_encoder release];
      _current_render_encoder = nil;
    }

    if (_current_drawable != nil) {
      [_current_command_buffer presentDrawable:_current_drawable];
    }
    [_current_command_buffer commit];
  }
  _current_render_encoder = nil;
  [_current_command_buffer release];
  _current_command_buffer = nil;
  [_current_drawable release];
  _current_drawable = nil;
}
