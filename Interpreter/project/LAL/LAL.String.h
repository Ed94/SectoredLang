#ifndef LAL_String__Def

#include "LAL.C_STL.h"
#include "LAL.Declarations.h"
#include "LAL.FundamentalTypes.h"
#include "LAL.Memory.h"
#include "LAL.Types.h"


// IO Forward
typedef FILE 
IO_StdStream;

typedef unsigned char     c8;
typedef          char16_t c16;
typedef          char32_t c32;


#pragma region Narrow

typedef char
   nchar,
*  nstr,
** nstrPtr,
*  nstrArray[]
;

typedef const char 
*  ro_nstr,
** ro_nstrPtr,
*  ro_nstrArray[]
;

ForceInline 
bool nchar_IsAlpha(nchar _char)
{
	return isalpha(_char);	
}

ForceInline
bool nchar_IsAlphaNumeric(nchar _char)
{
	return isalnum(_char);
}

ForceInline
nstr ncharTo_nStr(nchar _char)
{
	nstr converted = Mem_GlobalAlloc(nchar, 3);
	
	converted[0] = _char;
	converted[1] = '\0';
	
	return converted;
}

ForceInline 
s32 nstr_Compare(ro_nstr _str1, ro_nstr _str2)
{
	return strcmp(_str1, _str2);
}

ForceInline
ErrorType nstr_Concat
(
	nstr    restrict _appendStr_out, uDM _appendStrSize,
	ro_nstr restrict _copyStr_in,    uDM _copyStrSize
)
{
	return strncat_s
	(
		_appendStr_out, 
		_appendStrSize, 
		_copyStr_in, 
		_copyStrSize
	);
}

ForceInline
ErrorType nstr_Copy
(
	nstr restrict    _self,      uDM _selfSize,
	ro_nstr restrict _source_in
)
{
	return strcpy_s(_self, _selfSize, _source_in);
}

ForceInline
s32 nstr_Format(nstr restrict _string_out, uDM _stringLength, ro_nstr restrict _format, ...)
{
	s32     result;
	va_list argList;

	va_start(argList, _format);
		result = vsprintf_s(_string_out, _stringLength, _format, argList);
	va_end(argList);

	return result;
}

ForceInline
s32 nstr_FormatV(nstr restrict _string_out, uDM _stringLength, ro_nstr restrict _format, va_list _argList)
{
	return vsprintf_s(_string_out, _stringLength, _format, _argList);
}

ForceInline
uDM nstr_Length(ro_nstr _self)
{
	return strlen(_self);
}

ForceInline 
s32 nStr_StdWrite(IO_StdStream* restrict _stream_in, ro_nstr _format, ...)
{
	s32     result;
	va_list argList;

	va_start(argList, _format);
		result = vfprintf_s(_stream_in, _format, argList);
	va_end(argList);

	return result;
}

ForceInline 
s32 nstr_StdWriteV(IO_StdStream* restrict _stream_in, ro_nstr _format, va_list _argList)
{
	return vfprintf_s(_stream_in, _format, _argList);
}

#pragma endregion Narrow

#pragma region Wide

typedef wchar_t
   wc,
*  wstr,
** wstrPtr,
*  wstrArray[]
;
typedef const wchar_t
   ro_wc,
*  ro_wstr,
** ro_wstrPtr,
*  ro_wstrArray[]
;

#pragma endregion Wide


#pragma region Character_String_Generics

enum Str_CompareResult
{
	Str_Compare_FirstLower   = -1,
	Str_Compare_Equal        =  0,
	Str_Compare_FirstGreater =  1
};

#ifdef LAL_CharWidth_Narrow

// str literal
#define sl

typedef nchar
   schar,
*  str,
** strPtr,
*  strArray
;

typedef const nchar
   ro_schar,
*  ro_str,
** ro_strPtr,
*  ro_strArray
;

ForceInline
bool schar_IsAlpha(schar _char)
{
	return nchar_IsAlpha(_char);
}

ForceInline
bool schar_IsAlphaNumeric(schar _char)
{
	return nchar_IsAlphaNumeric(_char);
}

ForceInline
str scharTo_str(schar _char)
{
	return ncharTo_nStr(_char);
}

ForceInline 
s32 str_Compare(ro_str _str1, ro_str _str2)
{
	return nstr_Compare(_str1, _str2);
}

ForceInline
ErrorType str_Concat
(
   str    restrict _appendStr_out, uDM _appendStrSize,
   ro_str restrict _copyStr_in,    uDM _copyStrSize
)
{
	return nstr_Concat
	(
		_appendStr_out, 
		_appendStrSize, 
		_copyStr_in, 
		_copyStrSize
	);
}

ForceInline
ErrorType str_Copy
(
	str restrict    _self,      uDM _selfSize,
	ro_str restrict _source_in
)
{
	return nstr_Copy(_self, _selfSize, _source_in);
}

ForceInline
s32 str_FormatV(str restrict _string_out, uDM _stringLength, ro_str restrict _format, va_list _argList)
{
	return nstr_FormatV(_string_out, _stringLength, _format, _argList);
}

ForceInline
s32 str_Format(str restrict _string_out, uDM _stringLength, ro_str restrict _format, ...)
{
	s32     result;
	va_list argList;

	va_start(argList, _format);
		result = str_FormatV(_string_out, _stringLength, _format, argList);
	va_end(argList);

	return result;
}

ForceInline
uDM str_Hash(str _str)
{
    uDM hash = 5381;
    
    u32 character;

    while ((character = dref _str++))
        hash = ((hash << 5) + hash) + character;

    return hash;
}

ForceInline
uDM str_Length(ro_str _self)
{
	return nstr_Length(_self);
}

ForceInline 
s32 str_StdWriteV(IO_StdStream* restrict _stream_in, ro_nstr _format, va_list _argList)
{
	return nstr_StdWriteV(_stream_in, _format, _argList);
}

ForceInline 
s32 str_StdWrite(IO_StdStream* restrict _stream_in, ro_nstr _format, ...)
{
	s32     result;
	va_list argList;

	va_start(argList, _format);
		result = nstr_StdWriteV(_stream_in, _format, argList);
	va_end(argList);

	return result;
}

struct String;

#ifdef LAL_zpl

struct String
{
	zpl_string zStr;
};

#else // OS_Vendor

struct String
{
	uDM Length;
	str rStr;
};

#endif

typedef struct String
  String,
* StringPtr,
  StringArray[]
;
#ifndef text

#define text(_STR_LITERAL) #_STR_LITERAL
#endif

#endif 

#ifdef LAL_CharWidth_Wide
#define sl L
#endif

String* String_Create(ro_str _content);

ForceInline
String* strTo_String(ro_str _str)
{
#ifdef LAL_zpl
	return (String*)zpl_string_make(zpl_heap(), _str);
#else
	String* newString = String_Create(_str);
	
	return newString;
#endif
}

// Get raw character string from String.
ForceInline
str StringTo_str(String* _string_in)
{
#ifdef LAL_zpl
	return _string_in->zStr;
#else
	return _string_in->rStr;
#endif
}

ForceInline
ro_str StringTo_ro_str(const String* _string_in)
{
#ifdef LAL_zpl
	return _string_in->zStr;
#else
	return _string_in->rStr;
#endif 
}

// Creates a string allocation with the provided string as its initial content
String* String_Create(ro_str _content);

ForceInline
enum Str_CompareResult 
String_Compare(const String* restrict _string_in, const String* restrict _other_in)
{
#ifdef LAL_zpl
		s32 result = zpl_strcmp(_string_in->zStr, _other_in->zStr);
#else
		s32 result = str_Compare(_string_in->rStr, _other_in->rStr);
#endif
	if (result < 0)
		return Str_Compare_FirstLower;
	if (result > 0)
		return Str_Compare_FirstGreater;
	else 
		return Str_Compare_Equal;
}

ForceInline
void String_Concat(void)
{
}

//ForceInline
bool
String_IsEqual(String* restrict _string_in, String* restrict _other_in);

ForceInline
str* String_str(String* _string)
{
#ifdef LAL_zpl
#else
	return ptrof _string->rStr;
#endif
}

ForceInline
uDM String_Length(const String* _string)
{
#ifdef LAL_zpl
#else
		return _string->Length;
#endif
}

bool String_Reserve(String* _string, uDM _amount);

ForceInline 
void String_SetLength(String* _string, uDM _length)
{
#ifndef LAL_zpl
		_string->Length = _length;
#endif
}


#pragma endregion Character_String_Generics


// Low-Level Header
//#include "LAL_String.low.h"

#define LAL_String__Def
#endif
