# FIXME: This should be split up. Libraries that just need to read BSP files
# should not have to use all the BSP tool-related code.

set(P3BSPBASE_HEADERS
  common_config.h
  anorms.h
  blockmem.h
  bsp_boundingbox.h
  bspfile.h
  bsptools.h
  cmdlib.h
  cmdlinecfg.h
  filelib.h
  halton.h
  hlassert.h
  log.h
  mathlib.h
  mathtypes.h
  messages.h
  resourcelock.h
  scriplib.h
  threads.h
  TimeCounter.h
  win32fix.h
  winding.h
  mathlib/sse.h
  mathlib/ssemath.h
)

set(P3BSPBASE_SOURCES
  anorms.cpp
  blockmem.cpp
  bspfile.cpp
  bsptools.cpp
  cmdlib.cpp
  cmdlinecfg.cpp
  filelib.cpp
  files.cpp
  halton.cpp
  log.cpp
  mathlib.cpp
  messages.cpp
  resourcelock.cpp
  scriplib.cpp
  threads.cpp
  winding.cpp
  mathlib/powsse.cpp
  mathlib/sse.cpp
  mathlib/sseconst.cpp
)

# macOS/arm64 port: mathlib/sse.cpp is x86 inline-asm/MMX-only (Valve _SSE_* primitives)
# and is entirely unused (nothing in the bsp subsystem calls any _SSE_* function), so drop
# it on non-x86 architectures rather than port dead code. # -- macOS port
if(CMAKE_SYSTEM_PROCESSOR MATCHES "arm|aarch64|ARM64")
  list(REMOVE_ITEM P3BSPBASE_SOURCES mathlib/sse.cpp)
endif()

composite_sources(p3bspbase P3BSPBASE_SOURCES)
add_library(p3bspbase STATIC ${P3BSPBASE_HEADERS} ${P3BSPBASE_SOURCES})
if (WIN32)
  if (CMAKE_GENERATOR_PLATFORM MATCHES "x64")
    target_compile_definitions(p3bspbase PUBLIC VERSION_64BIT)
  else()
    target_compile_definitions(p3bspbase PUBLIC VERSION_32BIT)
  endif()
elseif (IS_LINUX)
  target_compile_definitions(p3bspbase PUBLIC VERSION_LINUX POSIX)
else()
  # macOS/arm64 port: Valve SSE code (sse.cpp) branches on the POSIX macro. # -- macOS port
  target_compile_definitions(p3bspbase PUBLIC VERSION_OTHER POSIX)
endif()
target_compile_definitions(p3bspbase PUBLIC NOMINMAX)
# macOS/arm64 port: Valve SSE constant tables init int32 arrays with 0xFFFFFFFF etc.;
# clang treats the narrowing as an error by default. # -- macOS port
if(NOT WIN32)
  target_compile_options(p3bspbase PRIVATE -Wno-narrowing -Wno-c++11-narrowing)
endif()
target_link_libraries(p3bspbase panda)

# NOTE: This package is not installed.
