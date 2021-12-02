#ifndef LAL_Reflection__Def


#define size_of(__TYPE) \
cast(sDM)(sizeof(__TYPE))

#define count_of(__TYPE)                            \
	((size_of(x) / size_of(0 [x]))                  \
	/                                               \
	(cast(sDM)( !(size_of(x) % size_of(0 [x])))))

 #if defined(_MSC_VER) || defined(__TINYC__)
 #    define offset_of(__TYPE, __ELEMENT) \
        ((sDM) & (((__TYPE *)0)->__ELEMENT))

 #else
 #    define offset_of(__TYPE, __ELEMENT) \
        __builtin_offsetof(__TYPE, __ELEMENT)
 #endif


#define LAL_Reflection__Def
#endif
