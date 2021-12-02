#if defined(LAL_zpl) && !defined(TPAL_String_zpl__Def)
#                        define  TPAL_String_zpl__Def

#include "LAL.C_STL.h"
#include "LAL.String.h"


#pragma region Narrow

ForceInline 
bool nchar_IsAlpha(nchar _char)
{
	return zpl_isalpha(_char);	
}

ForceInline
bool nchar_IsAlphaNumeric(nchar _char)
{
	return zpl_isalphanumeric(_char);
}

ForceInline 
s32 nstr_Compare(ro_nstr _str1, ro_nstr _str2)
{
	return zpl_strcmp(_str1, _str2);
}

ForceInline
ErrorType nstr_Concat
(
	nstr    restrict _appendStr_out, uDM _appendStrSize,
	ro_nstr restrict _copyStr_in,    uDM _copyStrSize
)
{
	return zpl_strncat_s
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
	return zpl_strncpy(_self, _source_in, _selfSize);
}

ForceInline
s32 nstr_Format(nstr restrict _string_out, uDM _stringLength, ro_nstr restrict _format, ...)
{
	s32     result;
	va_list argList;

	va_start(argList, _format);
		result = zpl_snprintf_va(_string_out, _stringLength, _format, argList);
	va_end(argList);

	return result;
}

ForceInline
s32 nstr_FormatV(nstr restrict _string_out, uDM _stringLength, ro_nstr restrict _format, va_list _argList)
{
	return zpl_snprintf_va(_string_out, _stringLength, _format, _argList);
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
		// No support for zpl_files yet.
		// result = zpl_printf_va(_stream_in, _format, argList);
		result = vfprintf_s(_stream_in, _format, argList);
	va_end(argList);

	return result;
}

ForceInline 
s32 nstr_StdWriteV(IO_StdStream* restrict _stream_in, ro_nstr _format, va_list _argList)
{
	// No support for zpl_files yet.
	// return zpl_printf_va(_stream_in, _format, _argList);
	return vfprintf_s(_stream_in, _format, _argList);
}

#pragma endregion Narrow

#pragma region Character_String_Generics

#pragma region String

ForceInline
enum Str_CompareResult 
String_Compare(const String* restrict _string_in, const String* restrict _other_in)
{
	s32 result = zpl_strcmp(_string_in->Data, _other_in->Data);

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

ForceInline 
void String_SetLength(String* _string, uDM _length)
{
	zpl__set_string_length(_string->Data, _length);
}

#pragma endregion String

#pragma endregion Character_String_Generics


#endif // LAL_String_zpl__Def
