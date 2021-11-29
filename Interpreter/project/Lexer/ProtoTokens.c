#include "ProtoTokens.h"


Token* 
Token_Init(ETokenType _type, str _value)
{
	Token* newToken = Mem_GlobalAllocClear(Token, 1);
	
	newToken->Type  = _type;
	newToken->Value = _value;

	return newToken;
}

enum TokenType
ToToken(str _str)
{
	static uDM Internal_ToTokenArray[TokenType_Size];
	
	static bool doOnce = true;
	
	if (doOnce)
	{
	#define Entry(_enum) Internal_ToTokenArray[_enum] = str_Hash(STok_##_enum);

	#include "TokenEntires.inline.macro"

	#undef Entry
	}
	
	#define Entry(_enum)              \
	if (str_Hash(_str) == Internal_ToTokenArray[_enum]) \
		return _enum;
		
	#include "TokenEntires.inline.macro"

	#undef Entry
	
	return EToken_Invalid;
}
