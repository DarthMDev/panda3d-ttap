if(NOT HAVE_BULLET)
  return()
endif()

set(PANDABSP_HEADERS
  config_bsp.h
  #actor.h
  ambient_boost_effect.h
  ambient_probes.h
  audio_3d_manager.h
  aux_data_attrib.h
  bloom_attrib.h
  bounding_kdop.h
  bsp_render.h
  bsp_trace.h
  bsploader.h
  ciolib.h
  cubemaps.h
  decals.h
  entity.h
  glow_node.h
  interpolated.h
  interpolatedvar.h
  lerp_functions.h
  lighting_origin_effect.h
  lightmap_palettes.h
  physics_character_controller.h
  planar_reflections.h
  pssmCameraRig.h
  py_bsploader.h
  rangecheckedvar.h
  raytrace.h
  shader_csmrender.h
  shader_decalmodulate.h
  shader_features.h
  shader_generator.h
  shader_lightmappedgeneric.h
  shader_skybox.h
  shader_spec.h
  shader_unlitgeneric.h
  shader_unlitnomat.h
  shader_vertexlitgeneric.h
  static_props.h
  subprocess.h
  texture_filter.h
  TexturePacker.h

  kdtree/KDTree.h
  kdtree/utils.h

  postprocess/bloom.h
  postprocess/blur_passes.h
  postprocess/fxaa.h
  postprocess/hdr.h
  postprocess/postprocess.h
  postprocess/postprocess_defines.h
  postprocess/postprocess_effect.h
  postprocess/postprocess_pass.h
  postprocess/postprocess_scene_pass.h
  postprocess/ssao.h
)

set(PANDABSP_SOURCES
  config_bsp.cpp
  ambient_boost_effect.cpp
  ambient_probes.cpp
  audio_3d_manager.cpp
  aux_data_attrib.cpp
  bloom_attrib.cpp
  bounding_kdop.cpp
  bsp_render.cpp
  bsp_trace.cpp
  bsploader.cpp
  ciolib.cpp
  decals.cpp
  entity.cpp
  glow_node.cpp
  interpolated.cpp
  interpolatedvar.cpp
  lighting_origin_effect.cpp
  lightmap_palettes.cpp
  planar_reflections.cpp
  pssmCameraRig.cpp
  rangecheckedvar.cpp
  raytrace.cpp
  shader_csmrender.cpp
  shader_decalmodulate.cpp
  shader_features.cpp
  shader_generator.cpp
  shader_lightmappedgeneric.cpp
  shader_skybox.cpp
  shader_spec.cpp
  shader_unlitgeneric.cpp
  shader_unlitnomat.cpp
  shader_vertexlitgeneric.cpp
  static_props.cpp
  texture_filter.cpp
  TexturePacker.cpp

  kdtree/KDTree.cpp

  postprocess/bloom.cpp
  postprocess/fxaa.cpp
  postprocess/hdr.cpp
  postprocess/postprocess.cpp
  postprocess/postprocess_effect.cpp
  postprocess/postprocess_pass.cpp
  postprocess/postprocess_scene_pass.cpp
  postprocess/ssao.cpp
)

composite_sources(pandabsp PANDABSP_SOURCES)
add_library(pandabsp ${PANDABSP_SOURCES} ${PANDABSP_HEADERS})
set_target_properties(pandabsp PROPERTIES DEFINE_SYMBOL BUILDING_LIBPANDABSP)
# macOS port: enable the python-aware BSP loaders (Py_CL_BSPLoader/Py_AI_BSPLoader, guarded
# by _PYTHON_VERSION) that the game imports. # -- macOS port
target_compile_definitions(pandabsp PUBLIC _PYTHON_VERSION)

# macOS port: the renderer uses bspbase (bspfile/mathlib/winding) and embree, which the
# original makepanda build linked implicitly. Wire them explicitly here. # -- macOS port
target_include_directories(pandabsp PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../bspbase>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../bspbase/mathlib>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../bullet>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../glgsg>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../glstuff>
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../bspinternal>
  PRIVATE
  ${PYTHON_INCLUDE_DIRS})  # py_panda.h -> Python.h, bspinternal headers # -- macOS port
find_package(embree 4 QUIET)
# macOS port: pandagl/pandabullet are MODULE (loadable) libs and can't be linked; the bsp
# library is bundled into the panda3d.bsp python module which imports them at runtime. The
# static helpers (p3bspbase, embree, bullet) are linked PRIVATE so pandabsp stays cleanly
# exportable (PUBLIC interface is only the already-exported panda/pandaegg). # -- macOS port
if(embree_FOUND)
  set(_BSP_EMBREE embree)
else()
  find_library(EMBREE_LIB NAMES embree4 embree HINTS /opt/homebrew/opt/embree/lib /usr/local/lib)
  target_include_directories(pandabsp PRIVATE /opt/homebrew/opt/embree/include)
  set(_BSP_EMBREE ${EMBREE_LIB})
endif()
target_link_libraries(pandabsp PUBLIC panda pandaegg p3bullet PKG::BULLET PRIVATE p3bspbase ${_BSP_EMBREE})
target_compile_definitions(pandabsp PUBLIC VERSION_OTHER POSIX)
# Python C-API and cross-module panda/interrogate symbols resolve at runtime when this is
# loaded as the panda3d.bsp python module. # -- macOS port
if(APPLE)
  target_link_options(pandabsp PRIVATE -undefined dynamic_lookup)
endif()
set(PANDABSP_IGATE_HEADERS ${PANDABSP_HEADERS})
list(REMOVE_ITEM PANDABSP_IGATE_HEADERS subprocess.h)
target_interrogate(pandabsp ${PANDABSP_IGATE_HEADERS})

install(TARGETS pandabsp
  EXPORT PandaBSP COMPONENT PandaBSP
  DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/panda3d
  ARCHIVE COMPONENT PandaBSPDevel)
install(FILES ${PANDABSP_HEADERS} COMPONENT PandaBSPDevel DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/panda3d)

export_targets(PandaBSP COMPONENT PandaBSPDevel)
