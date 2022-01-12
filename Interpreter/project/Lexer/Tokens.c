#include "Tokens.h"



enum TokenType
ToToken(str _str)
{
	static uw _ToTokenArray[TokenType_ArraySize];
	
	static 
	bool _DoOnce = true;
	if  (_DoOnce)
	{
	#define Entry(_enum)                                        \
	String _enum##_String = STok_##_enum;                       \
	_ToTokenArray[_enum] = String_Hash(ptrof _enum##_String);

	#include "TokenEntires.inline.macro"

	#undef Entry
	
		_DoOnce = false;
	}
	
	#define Entry(_enum)                        \
	if (str_Hash(_str) == _ToTokenArray[_enum]) \
		return _enum;
		
	#include "TokenEntires.inline.macro"

	#undef Entry
	
	return Token_Invalid;
}
