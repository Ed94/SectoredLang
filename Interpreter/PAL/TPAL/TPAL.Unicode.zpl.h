#ifndef LAL_Unicode_zpl__Def

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

ucs2*   utf8_to_ucs2         (ucs2* _buffer, sDM _length, const utf8* _str);
utf8*   ucs2_to_utf8         (utf8* _buffer, sDM _length, const ucs2* _str);
ucs2*   utf8_to_ucs2_buffered(const u8*  _str); // NOTE: Uses locally persisting buffer
utf8*   ucs2_to_utf8_buffered(const u16* _str); // NOTE: Uses locally persisting buffer

// Length

ForceInline sDM utf8_Length(const utf8* _str             );
ForceInline sDM utf8_Legnth(const utf8* _str, sDM _length);

// Runes

sDM rune_Encode(utf8 _buffer[4], rune _rune);
sDM rune_Decode(const utf8* _str, sDM _length, rune* _rune);
sDM rune_Size  (const utf8* _str, sDM _length);


#define LAL_Unicode_zpl__Def
#endif
