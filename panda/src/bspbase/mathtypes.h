#ifndef MATHTYPES_H__
#define MATHTYPES_H__
#include "cmdlib.h" //--vluzacn

#if _MSC_VER >= 1000
#pragma once
#endif

typedef unsigned char byte;

// macOS/arm64 port: Valve fixed-width integer aliases used by the SSE math/winding code.
// # -- macOS port
#include <cstdint>
typedef int32_t  int32;
typedef uint32_t uint32;
typedef uint32_t UINT32;

typedef double vec_t;
typedef vec_t   vec3_t[3];                                 // x,y,z

#endif //MATHTYPES_H__
