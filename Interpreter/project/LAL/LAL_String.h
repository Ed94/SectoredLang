#ifndef LAL_String__Def

#include "LAL_C_STL.h"
#include "LAL_Declarations.h"
#include "LAL_FundamentalTypes.h"
#include "LAL_Memory.h"
#include "LAL_Types.h"


// IO Forward
typedef FILE 
IO_StdStream;

typedef unsigned char     c8;
typedef          char16_t c16;
typedef          char32_t c32;


#pragma region Narrow

typedef char
   nchar,
*  nStr,
** nStrPtr,
*  nStrArray[]
;

typedef const char 
*  ro_nStr,
** ro_nStrPtr,
*  ro_nStrArray[]
;

ForceInline
bool nChar_IsAlphaNumeric(nChar _char)
{
	return isalnum(_char);
}

ForceInline
nStr nCharTo_nStr(nChar _char)
{
	nStr converted = GlobalAlloc(_char, 2);
	
	converted[0] = _char;
	converted[1] = '\0';
}

ForceInline 
s32 nStr_Compare(ro_nStr _str1, ro_nStr _str2)
{
		return strcmp(_str1, _str2);
}

ForceInline
ErrorType nStr_Concat
(
	nStr    restrict _appendStr_out, uDM _appendStrSize,
	ro_nStr restrict _copyStr_in,    uDM _copyStrSize
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
ErrorType
(
	nStr restrict    _self,      uDM _selfSize,
	ro_nStr restrict _source_in, uDM _sourceSize
)
{
	return strcpy_s(_self, _selfSize, _source_in, _sourceSize);
}

ForceInline
s32 nStr_Format(nStr restrict _string_out, uDM _stringLength, ro_nStr restrict _format, ...)
{
		s32     result;
		va_list argList;

		va_start(argList, _format);
				result = vsprintf_s(_string_out, _stringLength, _format, argList);
		va_end(argList);

		return result;
}

ForceInline
s32 nStr_FormatV(nStr restrict _string_out, uDM _stringLength, ro_nStr restrict _format, va_list _argList)
{
return vsprintf_s(_string_out, _stringLength, _format, _argList);
}

ForceInline
uDM nStr_Length(ro_nStr _self)
{
	return strlen(_self);
}

ForceInline 
s32 nStr_StdWrite(IO_StdStream* restrict _stream_in, ro_nStr _format, ...)
{
		s32     result;
		va_list argList;

		va_start(argList, _format);
				result = vfprintf_s(_stream_in, _format, argList);
		va_end(argList);

		return result;
}

ForceInline 
s32 nStr_StdWriteV(IO_StdStream* restrict _stream_in, ro_nStr _format, va_list _argList)
{
		return vfprintf_s(_stream_in, _format, _argList);
}

#pragma endregion Narrow

#pragma region Wide

typedef wchar_t
   wc,
*  wStr,
** wStrPtr,
*  wStrArray[]
;
typedef const wchar_t
   ro_wc,
*  ro_wStr,
** ro_wStrPtr,
*  ro_wStrArray[]
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
   sChar,
*  str,
** strPtr,
*  strArray
;

typedef const nchar
   ro_sChar,
*  ro_str,
** ro_strPtr,
*  ro_strArray
;

ForceInline
bool sChar_IsAlphaNumeric(sChar _char)
{
	return nChar_IsAlphaNumeric(_char);
}

ForceInline
str sCharTo_str(sChar _char)
{
	return nCharTo_nStr(_char);
}

ForceInline 
s32 str_Compare(ro_str _str1, ro_str _str2)
{
		return nStr_Compare(_str1, _str2);
}

ForceInline
ErrorType str_Concat
(
   str    restrict _appendStr_out, uDM _appendStrSize,
   ro_str restrict _copyStr_in,    uDM _copyStrSize
)
{
		return nStr_Concat
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
	ro_str restrict _source_in, uDM _sourceSize
)
{
		return nStr_Copy(_self, _selfSize, _source_in, _sourceSize);
}

ForceInline
s32 str_FormatV(str restrict _string_out, uDM _stringLength, ro_str restrict _format, va_list _argList)
{
		return nStr_FormatV(_string_out, _stringLength, _format, _argList);
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
uDM str_Length(ro_str _self)
{
	nStr_Length(_self);
}

ForceInline 
s32 str_StdWriteV(IO_StdStream* restrict _stream_in, ro_nStr _format, va_list _argList)
{
		return nStr_StdWriteV(_stream_in, _format, _argList);
}

ForceInline 
s32 str_StdWrite(IO_StdStream* restrict _stream_in, ro_nStr _format, ...)
{
		s32     result;
		va_list argList;

		va_start(argList, _format);
				result = nStr_StdWriteV(_stream_in, _format, argList);
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

ForceInline
String* strTo_String(ro_str _str)
{
#ifdef LAL_zpl
		return (String*)zpl_string_make(zpl_heap(), _str);
#else
		String* newString = GlobalAlloc(String, 1);
		
		newString->Length = str_Length(_str);
		str_Copy(newString->rStr, newString->Length, _str, newString->Length);
		
		return newString;
#endif
}

// Get raw character string from String.
ForceInline
str String_str(String* _string_in)
{
#ifdef LAL_zpl
		return _string_in->zStr;
#else
		return _string_in->rStr;
#endif
}

ForceInline
ro_str String_ro_str(const String* _string_in)
{
#ifdef LAL_zpl
		return _string_in->zStr;
#else
		return _string_in->rStr;
#endif 
}

// Creates a string allocation with the provided string as its initial content
// String* String_Create(ro_str _content);

ForceInline
enum Str_CompareResult 
String_Compare(const String* restrict _string_in, const String* restrict _other_in)
{
#ifdef LAL_zpl
		s32 result = zpl_strcmp(_string_in->zStr, _other_in->zStr);
#else
		s32 result = str_Compare(String_str(_string_in), String_str(_other_in));
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
uDM String_Length(const String* _string)
{
#ifdef LAL_zpl
#else
	return _string->Length;
#endif
}


#pragma endregion Character_String_Generics


// Low-Level Header
//#include "LAL_String.low.h"

#define LAL_String__Def
#endif
