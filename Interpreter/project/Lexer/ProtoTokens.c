#include "ProtoTokens.h"


Token* 
Token_Init(ETokenType _type, str _value)
{
	Token* newToken = Mem_GlobalAllocClear(Token, 1);
	
	newToken->Type  = _type;
	newToken->Value = _value;
	
	return newToken;
}

