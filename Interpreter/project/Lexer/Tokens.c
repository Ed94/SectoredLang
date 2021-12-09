#include "Tokens.h"


// For later... Once I get the setup for mvp down packed
// I wont be needing dynamic memory and should just be fine with static sector buffers.
// NoLink
// Token   TokenBuffer
// [_1K];


Token* 
Token_Init(ETokenType _type, const String* _value)
{
	Token* newToken = Mem_GlobalAllocClear(Token, 1);
	
	newToken->Type  = _type;
	newToken->Value = _value;

	return newToken;
}

enum TokenType
ToToken(str _str)
{
	static uDM _ToTokenArray[TokenType_ArraySize];
	
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
