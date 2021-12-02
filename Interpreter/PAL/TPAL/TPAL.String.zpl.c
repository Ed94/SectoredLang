#ifdef LAL_zpl

#include "TPAL.String.zpl.h"


#define rstr    _self->Data
#define length  _self->Length


String* String_Make(ro_str _content)
{
	String* newString = Mem_GlobalAlloc(String, 1);
	
	newString->Data   = zpl_string_make(zpl_heap(), _content);
	newString->Length = zpl_string_length(newString->Data);

	return newString;
}

bool String_IsEqual(String* restrict _string_in, String* restrict _other_in)
{
	return zpl_string_are_equal(_string_in->Data, _other_in->Data);
}

bool String_Reserve(String* _self, uDM _amount)
{
	str newStr = zpl_string_make_reserve(zpl_heap(), _amount);
	
	if (newStr != nullptr)
	{
		rstr   = newStr;
		length = zpl_string_length(newStr);

		return true;
	}
	
	return false;
}

#undef rstr
#undef length

#endif
