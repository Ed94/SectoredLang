#include "LAL.String.h"


#include "LAL.Exception.h"


#define rstr    _self->rStr
#define length  _self->Length


String* String_Create(ro_str _content)
{
	String* newString = Mem_GlobalAlloc(String, 1);

	newString->Length = str_Length(_content);
	newString->rStr   = Mem_GlobalAllocClear(schar, newString->Length + 1);

	Mem_FormatWithData(str, newString->rStr, _content, newString->Length);

	return newString;
}

bool String_IsEqual(String* restrict _string_in, String* restrict _other_in)
{
#ifdef LAL_zpl
	return zpl_string_are_equal(_string_in->zStr, _other_in->zStr);
#else
	return String_Compare(_string_in, _other_in) == Str_Compare_Equal;
#endif
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


#undef str
#undef length
