#ifndef LAL_String__Def

#include "Config.LAL.h"

#include "LAL.Declarations.h"
#include "LAL.Types.h"
#include "LAL.Memory.h"

#include "TPAL.h"


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

// TODO: Should prob setup interning for this mess...


bool nchar_IsAlpha       (nchar _char);
bool nchar_IsAlphaNumeric(nchar _char);
bool nchar_IsDigit       (nchar _char);


ForceInline
nstr ncharTo_nstr(nchar _char)
{
	nstr converted = Mem_GlobalAlloc(nchar, 2);
	
	converted[0] = _char;
	converted[1] = '\0';
	
	return converted;
}

#define nchar_to_str(__CHAR)    { __CHAR, '\0' }

inline
ro_nstr ncharTo_ro_nstr(nchar _char)
{
	static 
	const nchar _Table_ncharTo_nStr
	[256][2] =
	{
	#define Entry(__VALUE)   { __VALUE, '\0' }, 
	#define Row(_N_)                                                                \
			Entry(0x##_N_##0) Entry(0x##_N_##1) Entry(0x##_N_##2) Entry(0x##_N_##3) \
			Entry(0x##_N_##4) Entry(0x##_N_##5) Entry(0x##_N_##6) Entry(0x##_N_##7) \
			Entry(0x##_N_##8) Entry(0x##_N_##9) Entry(0x##_N_##A) Entry(0x##_N_##B) \
			Entry(0x##_N_##C) Entry(0x##_N_##D) Entry(0x##_N_##E) Entry(0x##_N_##F) 

			Row(0) Row(1) Row(2) Row(3) Row(4) Row(5) Row(6) Row(7) 
			Row(8) Row(9) Row(A) Row(B) Row(C) Row(D) Row(E) Row(F)
			
	#undef  Entry
	#undef  Row
	};
	
	return _Table_ncharTo_nStr[cast(u8)_char];
}

s32 nstr_Compare(ro_nstr _str1, ro_nstr _str2);

ErrorType nstr_Concat
(
   nstr             _dest_out,   uDM _destSize,
   ro_nstr restrict _srcStrA_in, uDM _srcStrSizeA,
   ro_nstr restrict _srcStrB_in, uDM _srcStrSizeB	
);

ErrorType nstr_Copy
(
	nstr restrict    _self,      uDM _selfSize,
	ro_nstr restrict _source_in
);

s32 nstr_Format (nstr restrict _string_out, uDM _stringLength, ro_nstr restrict _format, ...);
s32 nstr_FormatV(nstr restrict _string_out, uDM _stringLength, ro_nstr restrict _format, va_list _argList);

uDM nstr_Length(ro_nstr _self);

s32 nStr_StdWrite (IO_Std* restrict _stream_in, ro_nstr _format, ...);
s32 nstr_StdWriteV(IO_Std* restrict _stream_in, ro_nstr _format, va_list _argList);

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

typedef s32 
EStr_CompareResult;

// For some reason the config file is not getting here...
#define LAL_CharWidth_Narrow

#if defined(LAL_CharWidth_Narrow)

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
bool schar_IsDigit(schar _char)
{
	return nchar_IsDigit(_char);
}

#define schar_to_str(__CHAR)    { __CHAR, '\0' }

ForceInline
str scharTo_str(schar _char)
{
	return ncharTo_nstr(_char);
}

ForceInline
ro_str scharTo_ro_str(schar _char)
{
	return ncharTo_ro_nstr(_char);
}

ForceInline 
s32 str_Compare(ro_str _str1, ro_str _str2)
{
	return nstr_Compare(_str1, _str2);
}

ForceInline
ErrorType str_Concat
(
   str             _dest_out,   uDM _destSize,
   ro_str restrict _srcStrA_in, uDM _srcStrSizeA,
   ro_str restrict _srcStrB_in, uDM _srcStrSizeB
)
{
	return nstr_Concat
	(
		_dest_out,   _destSize,
		_srcStrA_in, _srcStrSizeA,
		_srcStrB_in, _srcStrSizeB
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
s32 str_StdWriteV(IO_Std* restrict _stream_in, ro_nstr _format, va_list _argList)
{
	return nstr_StdWriteV(_stream_in, _format, _argList);
}

ForceInline 
s32 str_StdWrite(IO_Std* restrict _stream_in, ro_nstr _format, ...)
{
	s32     result;
	va_list argList;

	va_start(argList, _format);
		result = nstr_StdWriteV(_stream_in, _format, argList);
	va_end(argList);

	return result;
}

#ifndef text
#define text(_STR_LITERAL) #_STR_LITERAL
#endif

#endif 


#ifdef LAL_CharWidth_Wide
#define sl L
#endif


#pragma region String

typedef struct String
  String,
* StringPtr;


struct String
{
	uDM        Length;
	zpl_string Data;
};


#define SL(__STR)    { sizeof(__STR), __STR }


struct String_ofchar
{
	uDM   Length;
	schar Data[2];
};

String* scharTo_String(schar _char);

inline
const String* scharTo_ro_String(schar _char)
{
	static 
	const struct String_ofchar
	_Table_scharTo_String
	[256] =
	{
	#define Entry(__VALUE)  { 2, schar_to_str(__VALUE) },
	#define Row(_N_)                                                                \
			Entry(0x##_N_##0) Entry(0x##_N_##1) Entry(0x##_N_##2) Entry(0x##_N_##3) \
			Entry(0x##_N_##4) Entry(0x##_N_##5) Entry(0x##_N_##6) Entry(0x##_N_##7) \
			Entry(0x##_N_##8) Entry(0x##_N_##9) Entry(0x##_N_##A) Entry(0x##_N_##B) \
			Entry(0x##_N_##C) Entry(0x##_N_##D) Entry(0x##_N_##E) Entry(0x##_N_##F) 

			Row(0) Row(1) Row(2) Row(3) Row(4) Row(5) Row(6) Row(7) 
			Row(8) Row(9) Row(A) Row(B) Row(C) Row(D) Row(E) Row(F)
			
	#undef  Entry
	#undef  Row
	};
	
	return cast(String*)(ptrof _Table_scharTo_String[cast(u8)_char]);
}

String* strTo_String(ro_str _str);
String* strTo_String_wLength(ro_str _str, uDM _length);

// Creates a string allocation with the provided string as its initial content
String* String_Make       (ro_str _content, uDM _length);
String* String_MakeMove   (str _content, uDM _length);
String* String_MakeReserve(uDM _length);

void                String_Append (String* restrict _string, const String* restrict _other); 
void                String_Append_WFormat(String* restrict _self, ro_str restrict _format, ...);
EStr_CompareResult  String_Compare(const String* restrict _string_in, const String* restrict _other_in);
void                String_Concat ();
uDM                 String_Hash   (String* _string);
bool                String_IsEqual(String* restrict _string_in, String* restrict _other_in);
bool                String_Reserve(String* _string, uDM _amount);

ForceInline
String* scharTo_String(schar _char)
{
	return String_Make(scharTo_ro_str(_char), 2);
}

ForceInline
String* strTo_String(ro_str _str)
{
	String* newString = String_Make(_str, str_Length(_str));
	
	return newString;
}

ForceInline
String* strTo_String_wLength(ro_str _str, uDM _length)
{
	String* newString = String_Make(_str, _length);
	
	return newString;
}

// #define strTo_String(_str, ...)

ForceInline
uDM String_Hash(String* _string)
{
	return str_Hash(_string->Data);
}

#pragma endregion String

#pragma endregion Character_String_Generics

// TPAL
#include "TPAL.String.h"

#endif // LAL_String__Def
