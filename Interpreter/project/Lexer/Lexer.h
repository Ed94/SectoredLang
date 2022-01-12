#ifndef Lexer__DEF

#include "Core.h"
#include "Tokens.h"


struct Lexer
{
	u64   Index;
	str   Contents;	
	uw    ContentSize;
	schar CurrentChar;
	
	DArray_Tokens TokensArray;
	const Token*  PreviousToken;
	const Token*  CurrentToken;
};

typedef struct Lexer
Lexer;

void Lexer_Tokenize(const String* _content);

// Grabs the next token (provides first token if current token is the first).
const Token*	Lexer_Next();
// Provides the previous token without changing the current token index;
const Token*	Lexer_Previous();
// Provides the token at the state index
const Token* 	Lexer_TokenAt(uw _index);
// Provides the token (_index) away from current token.
const Token*	Lexer_TokenRelative(sw _index);

// Reset lexer to the first token.
void			Lexer_Reset();

#define Lexer__DEF
#endif
	