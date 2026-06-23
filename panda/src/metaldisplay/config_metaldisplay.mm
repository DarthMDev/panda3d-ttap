/**
 * PANDA 3D SOFTWARE
 * Copyright (c) Carnegie Mellon University.  All rights reserved.
 *
 * All use of this software is subject to the terms of the revised BSD
 * license.  You should have received a copy of this license along
 * with this source code in a file named "LICENSE."
 *
 * @file config_metaldisplay.mm
 * @author Michael
 * @date 2026-06-24
 */

#include "config_metaldisplay.h"
#include "metalGraphicsPipe.h"
#include "metalGraphicsWindow.h"
#include "metalGraphicsStateGuardian.h"
#include "metalGeomMunger.h"
#include "metalTextureContext.h"
#include "metalVertexBufferContext.h"
#include "metalIndexBufferContext.h"
#include "metalShaderContext.h"

#include "graphicsPipeSelection.h"
#include "dconfig.h"
#include "pandaSystem.h"

Configure(config_metaldisplay);
NotifyCategoryDef(metaldisplay, "display");

ConfigureFn(config_metaldisplay) {
  init_libmetaldisplay();
}

/**
 * Initializes the library.  This must be called at least once before any of
 * the functions or classes in this library can be used.
 */
void
init_libmetaldisplay() {
  static bool initialized = false;
  if (initialized) {
    return;
  }
  initialized = true;

  MetalGeomMunger::init_type();
  MetalGraphicsPipe::init_type();
  MetalGraphicsStateGuardian::init_type();
  MetalGraphicsWindow::init_type();
  MetalTextureContext::init_type();
  MetalVertexBufferContext::init_type();
  MetalIndexBufferContext::init_type();
  MetalShaderContext::init_type();

  GraphicsPipeSelection *selection = GraphicsPipeSelection::get_global_ptr();
  selection->add_pipe_type(MetalGraphicsPipe::get_class_type(),
                           MetalGraphicsPipe::pipe_constructor);

  PandaSystem *ps = PandaSystem::get_global_ptr();
  ps->set_system_tag("Metal", "native_window_system", "Cocoa");
}

/**
 * Returns the TypeHandle index of the recommended graphics pipe type defined
 * by this module.
 */
int
get_pipe_type_p3metaldisplay() {
  return MetalGraphicsPipe::get_class_type().get_index();
}
