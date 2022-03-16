#ifndef LAL_Unicode__Def
#define LAL_Unicode__Def

#include "LAL.String.h"


 #define rune_invalid   cast(rune)(0xfffd)
 #define rune_max       cast(rune)(0x0010ffff)
 #define rune_bom       cast(rune)(0xfeff)
 #define rune_EOF       cast(rune)(-1)


typedef c32 
rune;

#ifdef TPAL_zpl
#   include "TPAL.Unicode.zpl.h"
#endif


#endif  // LAL_Unicode__Def
