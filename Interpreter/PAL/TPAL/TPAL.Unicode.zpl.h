#if defined(TPAL_zpl) \
&& !defined(TPAL_Unicode__Def)
#   define  TPAL_Unicode__Def

// Note main interface is based directly off of zpl.

#include "LAL.C_STL.h"
#include "LAL.Declarations.h"
#include "LAL.String.h"
#include "LAL.Types.h"


typedef u8 
utf8;

typedef u16
utf16, ucs2;


// Conversions

ucs2*   utf8_to_ucs2         (ucs2* _buffer, sw _length, const utf8* _str);
utf8*   ucs2_to_utf8         (utf8* _buffer, sw _length, const ucs2* _str);
ucs2*   utf8_to_ucs2_buffered(const u8*  _str); // NOTE: Uses locally persisting buffer
utf8*   ucs2_to_utf8_buffered(const u16* _str); // NOTE: Uses locally persisting buffer

// Length

ForceInline sw utf8_Length(const utf8* _str             );
ForceInline sw utf8_Legnth(const utf8* _str, sw _length);

// Runes

sw rune_Encode(utf8 _buffer[4], rune _rune);
sw rune_Decode(const utf8* _str, sw _length, rune* _rune);
sw rune_Size  (const utf8* _str, sw _length);


#endif // TPAL_Unicode__Def

