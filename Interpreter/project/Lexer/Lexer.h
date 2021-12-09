#ifndef Lexer__DEF

#include "Core.h"
#include "Tokens.h"


struct Lexer
{
	u64   Index;
	str   Contents;	
	uDM   ContentSize;
	schar CurrentChar;
};

typedef struct Lexer
Lexer;


void Lexer_Init(const String* _contents);

void Lexer_Tokenize(const String* _content);

void Lexer_Advance();
void Lexer_SkipWS ();

Token* Lexer_NextToken    ();
Token* Lexer_AdvWithToken (Token* _token);
Token* Lexer_CollectDecimal();
Token* Lexer_CollectStr   ();
Token* Lexer_CollectSymbol();


#define Lexer__DEF
#endif
	









