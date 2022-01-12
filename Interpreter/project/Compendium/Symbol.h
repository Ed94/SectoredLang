#ifndef Symbol__Def

#include "LAL.h"


enum Sym_ContextAttribs
{
// Universal
		// SCA_alias,
		// SCA_ct,
		// SCA_layer,
		// SCA_meta,

// Layer 0
	// Encoding
		// SCA_binary,
		// SCA_ternary,
		// SCA_octal,
		// SCA_hex,
	// Specifier
		// SCA_inline,
		// SCA_interrupt,
		// SCA_label,
		// SCA_page,
	SCA_proc,
		// SCA_stack,
	SCA_static,
	// Mutatbility
		// SCA_ro,
	SCA_struct,
	SCA_sector,
	SCA_type,
	
// Layer 1
	
};

typedef uw
Sym_ContextAttribsFlags;





struct Symbol
{
	


	str Value;
	
	
};


#define Symbol__Def
#endif
