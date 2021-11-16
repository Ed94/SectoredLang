#include "LAL_String.h"


#include "LAL_Exception.h"



bool
String_IsEqual(String* restrict _string_in, String* restrict _other_in)
{
#ifdef LAL_zpl
return zpl_string_are_equal(_string_in->zStr, _other_in->zStr);
#else
return String_Compare(_string_in, _other_in) == Str_Compare_Equal;
#endif
}

struct String*
String_Create(ro_str _content)
{
	Fatal_NotImplemented("String_Create");

	return nullptr;
}
