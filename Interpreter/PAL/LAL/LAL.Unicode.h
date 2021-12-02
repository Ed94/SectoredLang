#ifndef LAL_Unicode__Def
#define LAL_Unicode__Def

#include "LAL.String.h"


 #define rune_invalid   cast(zpl_rune)(0xfffd)
 #define rune_max       cast(zpl_rune)(0x0010ffff)
 #define rune_bom       cast(zpl_rune)(0xfeff)
 #define rune_EOF       cast(zpl_rune)(-1)


typedef c32 rune;

#ifdef LAL_zpl
#   include "LAL.Unicode.zpl.h"
#endif


#endif  // LAL_Unicode__Def
