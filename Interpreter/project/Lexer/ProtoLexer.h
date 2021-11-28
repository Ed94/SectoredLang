#ifndef ProtoLexer__DEF

#include "Core.h"
#include "ProtoTokens.h"


struct Lexer
{
	u32   Index;
	str   Contents;	
	uDM   ContentSize;
	schar CurrentChar;
};

typedef struct Lexer
Lexer;

void Lexer_Init(str _contents);

void Lexer_Advance();
void Lexer_SkipWS ();

Token* Lexer_NextToken    ();
Token* Lexer_AdvWithToken (Token* _token);
Token* Lexer_CollectStr   ();
Token* Lexer_CollectSymbol();

#define ProtoLexer__DEF
#endif
	









