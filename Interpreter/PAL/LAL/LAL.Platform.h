#ifndef LAL_Platform__Def


#if defined(_WIN32) && defined(LAL_Avoid_WindowsIssues)
#       define NOMINMAX              // Prevents the numeric limits error.
#       define WIN32_LEAN_AND_MEAN   // Exclude rarely-used stuff from Windows headers
#endif


#define LAL_Platform__Def
#endif
