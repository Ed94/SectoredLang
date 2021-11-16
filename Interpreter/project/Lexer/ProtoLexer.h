#ifndef ProtoLexer__DEF

#include "Core.h"
#include "ProtoTokens.h"


struct Lexer
{
	u32   Index;
	str   Contents;	
	uDM   ContentSize;
	sChar CurrentChar;
};

typedef struct Lexer
Lexer;

void Lexer_Init(str _contents);

void Lexer_Advance();
void Lexer_SkipWS ();

struct Token* Lexer_NextToken    ();
struct Token* Lexer_AdvWithToken (Token* _token);
struct Token* Lexer_CollectSymbol();
struct Token* Lexer_CollectStr   ();

#define ProtoLexer__DEF
#endif
