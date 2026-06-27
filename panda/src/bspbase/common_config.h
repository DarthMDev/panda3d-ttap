#ifndef BSPCOMMON_CONFIG_H_
#define BSPCOMMON_CONFIG_H_

#ifdef _WIN32
  #ifdef BUILDING_BSPCOMMON
  #define _BSPEXPORT __declspec(dllexport)
  #else
  #define _BSPEXPORT __declspec(dllimport)
  #endif
#else
  // macOS/arm64 port: default dylib visibility is public; no declspec. # -- macOS port
  #define _BSPEXPORT
#endif

#endif // BSPCOMMON_CONFIG_H_