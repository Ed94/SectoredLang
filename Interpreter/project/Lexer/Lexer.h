#ifndef Lexer__DEF

#include "Core.h"
#include "Tokens.h"


struct Lexer
{
	u64   Index;
	str   Contents;	
	uDM   ContentSize;
	schar CurrentChar;
	
	TokenArray Tokens;
	Token*     PreviousToken;
	Token*     CurrentToken;
};

typedef struct Lexer
Lexer;


void Lexer_Init(const String* _contents);

void Lexer_Tokenize(const String* _content);

void Lexer_Advance();
void Lexer_SkipWS ();

Token* Lexer_NextToken      ();
Token* Lexer_AdvWithToken   (Token* _token);

Token* Lexer_Collect_Comment        ();
Token* Lexer_Collect_CommentBlock   ();
Token* Lexer_Collect_Decimal        ();
Token* Lexer_Collect_Str            ();
Token* Lexer_Collect_Symbol         ();


#define Lexer__DEF
#endif
	