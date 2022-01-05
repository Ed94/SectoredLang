#ifndef Config_TPAL__Def
#define Config_TPAL__Def

		// Required for LAL: IO, String
#define TPAL_zpl

		// Has been refactored without the HEDLEY_ namespace.
#define TPAL_hedley

// Libraries to expose but not wrapped.
// #define  TPAL_STD
// #define  TPAL_allegro
// #define  TPAL_qlib
// #define  TPAL_sqlite
// #define  TPAL_zlib


// Both require posix and I don't feel like supporting. I'll keep them listed I guess..
	//#define TPAL_bstring
	//#define TPAL_klib   


#endif
