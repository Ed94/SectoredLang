#ifndef LAL_Declarations_Def


// Statics:

// Creates a static duration variable only accessible to the file. (Global scope/File scope only)
#define NoLink        static
// Creates a static duration variable accessible to any file or linkage. (Global/File scope Only)
#define ExportLink    extern
#define ImportLink    extern

// Inlines
// Alias for an inline variable that is supposed to have a constant value, but exist in multiple definitions.
#define multiDefs    inline


#ifdef		LAL_ForceInlineMode_EnforceDiscretion
	// Standard force inline define. See: https://en.wikipedia.org/wiki/Inline_function
	#ifdef	_MSC_VER
						#define ForceInline     __forceinline
	#endif
	#ifdef	__GNUC__
						#define ForceInline     inline __attribute__((__always_inline__))
	#endif
	#ifdef	__CLANG__
						#if		__has_attribute(__always_inline__)
						#define ForceInline     inline __attribute__((__always_inline__))
						#endif
	#endif
#endif
#ifndef ForceInline
						// Using compiler discretion.
						#define ForceInline     inline
#endif




#define LAL_Declarations_Def
#endif
