#ifndef LAL_Declarations_Def
#define LAL_Declarations_Def

#include "Config.Build.h"
#include "Config.LAL.h"

// Casting

#define cast(__TYPE)          (__TYPE)
#define ocast(__TYPE, __OBJ)  (*(__TYPE*)(&__OBJ))

// Debug

#if Build_Debug
#   define debug    if (1)
#else
#   define debug    if (0)
#endif

// Execution

#define loop    for (;;)

// Procedures

#ifdef LAL_Use_FastCall
#       define FastCall        _fastcall
#else 
#       define FastCall
#endif

// Alias for an inline variable that is supposed to have a constant value, 
// but exist in multiple definitions.
#define multiDefs       inline

#ifdef		LAL_ForceInlineMode_EnforceDiscretion
	// Standard force inline define. See: https://en.wikipedia.org/wiki/Inline_function
#   ifdef	_MSC_VER
#           define      ForceInline     __forceinline
#   endif
#   ifdef	__GNUC__
#           define      ForceInline     inline __attribute__((__always_inline__))
#   endif
#   ifdef	__CLANG__
#           if		    __has_attribute(__always_inline__)
#           define      ForceInline     inline __attribute__((__always_inline__))
#           endif
	#endif
#endif

#ifndef ForceInline
// Using compiler discretion.
#define ForceInline     inline
#endif

#ifdef LAL_StaticLibrary
#   undef   ForceInline
#   define  ForceInline
#endif

#endif

// Statics

// Creates a static duration variable only accessible to the file. (Global scope/File scope only)
#define NoLink          static
// Creates a static duration variable accessible to any file or linkage. (Global/File scope Only)
#define ExportLink      extern
#define ImportLink      extern

