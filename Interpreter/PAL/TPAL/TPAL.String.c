#include "Config.TPAL.h"
#ifdef TPAL_zpl

#include "LAL.String.h"


#define rstr    _self->Data
#define length  _self->Length


String* String_Make(ro_str _content, uDM _length)
{
	String* newString = Mem_GlobalAlloc(String, 1);
	
	newString->Data   = zpl_string_make(Mem_GlobalAllocator(), _content);
	newString->Length = zpl_string_length(newString->Data);

	return newString;
}

String* String_MakeReserve(uDM _amount)
{
	String* newString = Mem_GlobalAlloc(String, 1);

	str newStr = zpl_string_make_reserve(Mem_GlobalAllocator(), _amount);
	
	if (newStr != nullptr)
	{
		newString->Data   = newStr;
		newString->Length = 0;

		return newString;
	}
	
	return nullptr;
}

bool String_Reserve(String* _self, uDM _amount)
{
	if (!_self)
	{
		_self = Mem_GlobalAlloc(String, 1);
	
		if (! _self)
			return false;
	}

	str newStr = zpl_string_make_reserve(Mem_GlobalAllocator(), _amount);
	
	if (newStr != nullptr)
	{
		rstr   = newStr;
		length = 0;

		return true;
	}
	
	return false;
}


#undef rstr
#undef length


#endif // TPAL_zpl
