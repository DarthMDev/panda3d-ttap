/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file metalGraphicsWindow.h
 * @author Michael
 * @date 2026-06-24
 */

#ifndef METALGRAPHICSWINDOW_H
#define METALGRAPHICSWINDOW_H

#include "config_metaldisplay.h"
#include "cocoaGraphicsWindow.h"

#ifdef __OBJC__
@class CAMetalLayer;
#else
typedef struct objc_object CAMetalLayer;
#endif

/**
 * A graphics window that renders using Apple's Metal API.
 * On macOS, it associates a CAMetalLayer with the NSView provided by CocoaGraphicsWindow.
 */
class EXPCL_METALDISPLAY MetalGraphicsWindow : public CocoaGraphicsWindow {
public:
  MetalGraphicsWindow(GraphicsEngine *engine, GraphicsPipe *pipe,
                       std::string name,
                       const FrameBufferProperties &fb_prop,
                       const WindowProperties &win_prop,
                       int flags,
                       GraphicsStateGuardian *gsg,
                       GraphicsOutput *host);
  virtual ~MetalGraphicsWindow();

  virtual bool begin_frame(FrameMode mode, Thread *current_thread) override;
  virtual void end_frame(FrameMode mode, Thread *current_thread) override;
  virtual void end_flip() override;

  virtual void update_context() override;
  virtual void unbind_context() override;

  CAMetalLayer *get_metal_layer() const { return _metal_layer; }

protected:
  virtual bool open_window() override;
  virtual void close_window() override;

private:
  CAMetalLayer *_metal_layer = nullptr;

public:
  static TypeHandle get_class_type() {
    return _type_handle;
  }
  static void init_type() {
    CocoaGraphicsWindow::init_type();
    register_type(_type_handle, "MetalGraphicsWindow",
                  CocoaGraphicsWindow::get_class_type());
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

#endif // METALGRAPHICSWINDOW_H
