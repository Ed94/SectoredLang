#ifndef LAL_Platform__Def


#define LAL_Avoid_WindowsIssues


#ifdef _WIN32 

#ifdef LAL_Avoid_WindowsIssues
	#define NOMINMAX              // Prevents the numeric limits error.
	#define WIN32_LEAN_AND_MEAN   // Exclude rarely-used stuff from Windows headers
#endif
	
#endif


#define LAL_Platform__Def
#endif
