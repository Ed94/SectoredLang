#ifndef ProtoToekns__Def

#include "Core.h"


enum TokenType
{
		Params_PStart,
#define Tok_Params_PStart       '('
		Params_PEnd,
#define Tok_Params_PEnd         ')'

		OP_Assign,
#define Tok_OP_Assign           '='
	
		Literal_String,
#define Tok_Literal_String_DLim '"'
		
		Def_Start,
#define Tok_Def_Start           ':'
		Def_End,
#define Tok_Def_End             ';'

		Sym_ID,
		
		EToken_Invalid
};

typedef enum TokenType 
ETokenType;


struct Token
{
	ETokenType  Type;
	str         Value;
};

typedef struct Token 
Token;


Token* Token_Init(ETokenType _type, str _value);


#define ProtoTokens__Def
#endif
