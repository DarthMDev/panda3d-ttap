/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalGraphicsWindow.mm
 * @author Michael
 * @date 2026-06-24
 */

#include "metalGraphicsWindow.h"
#include "metalGraphicsStateGuardian.h"

#import <QuartzCore/CAMetalLayer.h>
#import <AppKit/NSView.h>
#import <AppKit/NSWindow.h>

TypeHandle MetalGraphicsWindow::_type_handle;

/**
 *
 */
MetalGraphicsWindow::
MetalGraphicsWindow(GraphicsEngine *engine, GraphicsPipe *pipe,
                    std::string name,
                    const FrameBufferProperties &fb_prop,
                    const WindowProperties &win_prop,
                    int flags,
                    GraphicsStateGuardian *gsg,
                    GraphicsOutput *host) :
  CocoaGraphicsWindow(engine, pipe, std::move(name), fb_prop, win_prop, flags, gsg, host)
{
}

/**
 *
 */
MetalGraphicsWindow::
~MetalGraphicsWindow() {
}

/**
 * This function will be called within the draw thread before beginning
 * rendering for a given frame.
 */
bool MetalGraphicsWindow::
begin_frame(FrameMode mode, Thread *current_thread) {
  begin_frame_spam(mode);
  if (_gsg == nullptr) {
    return false;
  }

  MetalGraphicsStateGuardian *metalgsg;
  DCAST_INTO_R(metalgsg, _gsg, false);

  if (mode == FM_render) {
    if (_metal_layer == nil) {
      return false;
    }
    id<CAMetalDrawable> drawable = [_metal_layer nextDrawable];
    if (drawable == nil) {
      return false;
    }
    metalgsg->set_current_drawable(drawable);
  }

  _gsg->set_current_properties(&get_fb_properties());
  return _gsg->begin_frame(current_thread);
}

/**
 * This function will be called within the draw thread after rendering is
 * completed for a given frame.
 */
void MetalGraphicsWindow::
end_frame(FrameMode mode, Thread *current_thread) {
  end_frame_spam(mode);
  nassertv(_gsg != nullptr);

  _gsg->end_frame(current_thread);

  if (mode == FM_render) {
    trigger_flip();
  }
}

/**
 * This function will be called within the draw thread after begin_flip() has
 * been called on all windows, to finish the exchange of the front and back
 * buffers.
 */
void MetalGraphicsWindow::
end_flip() {
  if (_gsg != nullptr && _flip_ready) {
    MetalGraphicsStateGuardian *metalgsg;
    DCAST_INTO_V(metalgsg, _gsg);
    metalgsg->present_and_commit();
  }
  GraphicsWindow::end_flip();
}

/**
 * Updates the layer backing size on resize.
 */
void MetalGraphicsWindow::
update_context() {
  if (_metal_layer != nil && _view != nil) {
    CGFloat contents_scale = get_backing_scale_factor();
    [_metal_layer setContentsScale:contents_scale];
    
    CGSize bounds_size = [_view bounds].size;
    CGSize drawable_size = CGSizeMake(bounds_size.width * contents_scale, bounds_size.height * contents_scale);
    [_metal_layer setDrawableSize:drawable_size];
  }
}

/**
 * Unbinds the layer context.
 */
void MetalGraphicsWindow::
unbind_context() {
}

/**
 * Opens the window right now.  Called from the window thread.
 */
bool MetalGraphicsWindow::
open_window() {
  // GSG Creation/Initialization
  MetalGraphicsStateGuardian *metalgsg;
  if (_gsg == nullptr) {
    metalgsg = new MetalGraphicsStateGuardian(_engine, _pipe, nullptr);
    _gsg = metalgsg;
  } else {
    DCAST_INTO_R(metalgsg, _gsg, false);
  }

  // Open the base Cocoa window
  if (!CocoaGraphicsWindow::open_window()) {
    return false;
  }

  // Configure CAMetalLayer on the NSView
  CGFloat contents_scale = get_backing_scale_factor();

  CAMetalLayer *layer = [CAMetalLayer layer];
  [layer setDevice:metalgsg->get_metal_device()];
  [layer setPixelFormat:MTLPixelFormatBGRA8Unorm];
  [layer setContentsScale:contents_scale];
#if MAC_OS_X_VERSION_MAX_ALLOWED >= 101300
  if ([layer respondsToSelector:@selector(setDisplaySyncEnabled:)]) {
    [layer setDisplaySyncEnabled:sync_video];
  }
#endif
  [_view setWantsLayer:YES];
  [_view setLayer:layer];
  _metal_layer = layer;

  // Initialize drawable size
  CGSize bounds_size = [_view bounds].size;
  CGSize drawable_size = CGSizeMake(bounds_size.width * contents_scale, bounds_size.height * contents_scale);
  [layer setDrawableSize:drawable_size];

  metalgsg->reset_if_new();

  return true;
}

/**
 * Closes the window.
 */
void MetalGraphicsWindow::
close_window() {
  _metal_layer = nil;
  CocoaGraphicsWindow::close_window();
}
