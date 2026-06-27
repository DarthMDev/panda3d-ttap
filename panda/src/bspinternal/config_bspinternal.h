#pragma once

#include "pandabase.h"

// macOS/arm64 port: empty Windows dllexport macros on non-Windows. # -- macOS port
#if !defined(_WIN32) && !defined(EXPORT_CLASS)
#define EXPORT_CLASS
#define EXPORT_TEMPL
#define IMPORT_CLASS
#define IMPORT_TEMPL
#endif

#ifdef BUILDING_BSPINTERNAL
#define EXPCL_BSPINTERNAL EXPORT_CLASS
#define EXPTP_BSPINTERNAL EXPORT_TEMPL
#else
#define EXPCL_BSPINTERNAL IMPORT_CLASS
#define EXPTP_BSPINTERNAL IMPORT_TEMPL
#endif

extern EXPCL_BSPINTERNAL void init_libbspinternal();
