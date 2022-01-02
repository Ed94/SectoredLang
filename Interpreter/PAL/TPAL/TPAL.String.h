#if defined(TPAL_zpl)               \
&& !defined(TPAL_String_zpl__Def)
#   define  TPAL_String_zpl__Def


#pragma region Narrow

ForceInline 
bool nchar_IsAlpha(nchar _char)
{
	return zpl_char_is_alpha(_char);	
}

ForceInline
bool nchar_IsAlphaNumeric(nchar _char)
{
	return zpl_char_is_alphanumeric(_char);
}

ForceInline
bool nchar_IsDigit(nchar _char)
{
	return zpl_char_is_digit(_char);
}

ForceInline 
s32 nstr_Compare(ro_nstr _str1, ro_nstr _str2)
{
	return zpl_strcmp(_str1, _str2);
}

ForceInline
ErrorType nstr_Concat
(
   nstr             _dest_out,   uDM _destSize,
   ro_nstr restrict _srcStrA_in, uDM _srcStrSizeA,
   ro_nstr restrict _srcStrB_in, uDM _srcStrSizeB
)
{
	if (! _dest_out)
		return -1;

	zpl_str_concat
	(
		_dest_out,  _destSize,
		_srcStrA_in, _srcStrSizeA,
		_srcStrB_in, _srcStrSizeB
	);
	
	return 0;
}

ForceInline
ErrorType nstr_Copy
(
	nstr restrict    _self,      uDM _selfSize,
	ro_nstr restrict _source_in
)
{
	nstr result = zpl_strncpy(_self, _source_in, _selfSize);
	
	if (! result)
	{
		return -1;
	}
	
	return 0;
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
	// return strlen(_self);
	return zpl_strlen(_self);
}

ForceInline 
s32 nStr_StdWrite(IO_Std* restrict _stream_in, ro_nstr _format, ...)
{
	s32     result;
	va_list argList;

	va_start(argList, _format);
		// No support for zpl_files yet.
		result = zpl_fprintf_va(_stream_in, _format, argList);
		// result = vfprintf_s(_stream_in, _format, argList);
	va_end(argList);

	return result;
}

ForceInline 
s32 nstr_StdWriteV(IO_Std* restrict _stream_in, ro_nstr _format, va_list _argList)
{
	// No support for zpl_files yet.
	return zpl_fprintf_va(_stream_in, _format, _argList);
	// return vfprintf_s(_stream_in, _format, _argList);
}

#pragma endregion Narrow

#pragma region Character_String_Generics

#pragma region String

ForceInline
void
String_Append(String* restrict _self, const String* restrict _other)
{
	_self->Data   = zpl_string_append(_self->Data, _other->Data);
	_self->Length = zpl_string_length(_self->Data);
}

ForceInline
void
String_Append_WFormat(String* restrict _self, ro_str restrict _format, ...)
{
	zpl_isize result;

	char buffer[ZPL_PRINTF_MAXLEN] = { 0 };

	va_list args;
	va_start(args, _format);
		result = zpl_snprintf_va(buffer, zpl_count_of(buffer) - 1, _format, args) - 1;
	va_end(args);

	_self->Data = zpl_string_append_length(_self->Data, buffer, result);
	_self->Length = zpl_string_length(_self->Data);
}

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
bool String_IsEqual(String* restrict _string_in, String* restrict _other_in)
{
	return zpl_string_are_equal(_string_in->Data, _other_in->Data);
}

ForceInline 
void String_SetLength(String* _string, uDM _length)
{
	zpl__set_string_length(_string->Data, _length);
}

#pragma endregion String

#pragma endregion Character_String_Generics


#endif // TPAL_String_zpl__Def
