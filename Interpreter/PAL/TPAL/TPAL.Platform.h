#ifndef TPAL_Platform__Def


#if defined(_WIN32) && defined(TPAL_Avoid_WindowsIssues)
#       define NOMINMAX              // Prevents the numeric limits error.
#       define WIN32_LEAN_AND_MEAN   // Exclude rarely-used stuff from Windows headers
#endif


#define TPAL_Platform__Def
#endif
