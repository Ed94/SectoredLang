#include "LAL.String.h"

#include "LAL.Exception.h"


#ifndef LAL_zpl

#define rstr    _self->Data
#define length  _self->Length

String* String_Make(ro_str _content)
{
	String* newString = Mem_GlobalAlloc(String, 1);

	newString->Length = str_Length(_content);
	newString->Data   = Mem_GlobalAllocClear(schar, newString->Length + 1);

	Mem_FormatWithData(str, newString->Data, _content, newString->Length);

	return newString;
}

bool String_IsEqual(String* restrict _string_in, String* restrict _other_in)
{
	return String_Compare(_string_in, _other_in) == Str_Compare_Equal;
}

bool String_Reserve(String* _self, uDM _amount)
{
	if (rstr)
	{
		rstr = Mem_GlobalRealloc(schar, rstr, _amount);
		
		if (rstr != nullptr)
		{
			length = _amount;

			return true;
		}
		
		return false;
	}
	
	rstr = Mem_GlobalAllocClear(schar, _amount);
	
	if (rstr != nullptr)
	{
		length = _amount;
		
		return true;			
	}
	
	return false;
}

#undef rstr
#undef length

#endif
