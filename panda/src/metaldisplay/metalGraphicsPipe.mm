/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalGraphicsPipe.mm
 * @author Michael
 * @date 2026-06-24
 */

#include "metalGraphicsPipe.h"
#include "metalGraphicsWindow.h"
#include "metalGraphicsStateGuardian.h"

TypeHandle MetalGraphicsPipe::_type_handle;

/**
 * Takes a CoreGraphics display ID, which defaults to the main display.
 */
MetalGraphicsPipe::
MetalGraphicsPipe(CGDirectDisplayID display) : CocoaGraphicsPipe(display) {
  _supported_types = OT_window;
  _is_valid = true;
}

/**
 *
 */
MetalGraphicsPipe::
~MetalGraphicsPipe() {
}

/**
 * Returns the name of the rendering interface associated with this
 * GraphicsPipe.
 */
std::string MetalGraphicsPipe::
get_interface_name() const {
  return "Metal";
}

/**
 * This function is passed to the GraphicsPipeSelection object to allow the
 * user to make a default MetalGraphicsPipe.
 */
PT(GraphicsPipe) MetalGraphicsPipe::
pipe_constructor() {
  return new MetalGraphicsPipe;
}

/**
 * Creates a new window on the pipe, if possible.
 */
PT(GraphicsOutput) MetalGraphicsPipe::
make_output(std::string_view name,
            const FrameBufferProperties &fb_prop,
            const WindowProperties &win_prop,
            int flags,
            GraphicsEngine *engine,
            GraphicsStateGuardian *gsg,
            GraphicsOutput *host,
            int retry,
            bool &precertify) {

  if (!_is_valid) {
    return nullptr;
  }

  // First thing to try: a MetalGraphicsWindow
  if (retry == 0) {
    if ((flags & BF_require_parasite) != 0 ||
        (flags & BF_refuse_window) != 0 ||
        (flags & BF_resizeable) != 0 ||
        (flags & BF_size_track_host) != 0 ||
        (flags & BF_rtt_cumulative) != 0 ||
        (flags & BF_can_bind_color) != 0 ||
        (flags & BF_can_bind_every) != 0 ||
        (flags & BF_can_bind_layered) != 0) {
      return nullptr;
    }
    return new MetalGraphicsWindow(engine, this, std::string(name), fb_prop, win_prop,
                                   flags, gsg, host);
  }

  return nullptr;
}

/**
 * This is called when make_output() is used to create a
 * CallbackGraphicsWindow.
 */
PT(GraphicsStateGuardian) MetalGraphicsPipe::
make_callback_gsg(GraphicsEngine *engine) {
  return new MetalGraphicsStateGuardian(engine, this, nullptr);
}
