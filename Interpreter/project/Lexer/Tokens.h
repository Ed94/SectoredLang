#ifndef Tokens__Def

#include "Core.h"


enum TokenType
{
// Universal

#define Tok_Comp_WS                 ' '
#define Tok_Comp_UnderS             '_'
#define Tok_Comp_Null               '\0'
#define Tok_Comp_EOF                EOF
#define STok_Comp_EOF               SL("EOF")
#define Tok_Literal_String_DLim     '"'
#define STok_Literal_String_DLim    SL("\"")

#define Tok_Fmt_Tab                 '\t'
#define Tok_Fmt_CR                  '\r'
#define Tok_Fmt_NL                  '\n'
#define Tok_Fmt_OB                  '{'
#define Tok_Fmt_CB                  '}'
	
		Params_PStart,
#define Tok_Params_PStart           '('
#define STok_Params_PStart          SL("(")
		Params_PEnd,
#define Tok_Params_PEnd             ')'
#define STok_Params_PEnd            SL(")")

		OP_Assign,
#define Tok_OP_Assign               '='
#define STok_OP_Assign              SL("=")
	
		Literal_Digit,
#define STok_Literal_Digit          SL("{0-9}")
		Literal_String,
#define STok_Literal_String         SL("{string}")
		
		Def_Start,
#define Tok_Def_Start               ':'
#define STok_Def_Start              SL(":")
		Def_End,
#define Tok_Def_End                 ';'
#define STok_Def_End                SL(";")

		Sym_TType,
#define STok_Sym_TType              SL("type")
		Sym_Identifier,
#define STok_Sym_Identifier         SL("{Identifier}")
		Sym_Invalid,
#define STok_Sym_Invalid            SL("{undefined}")

// Layer 0

		Sec_Static,
#define STok_Sec_Static             SL("static")

		Sym_Ptr,
#define STok_Sym_Ptr                SL("ptr")
		Sym_Byte,
#define STok_Sym_Byte               SL("byte")

		Token_Invalid,

		TokenType_ArraySize = Token_Invalid,
		TokenType_Size      = S32_Max
};

typedef enum TokenType
ETokenType;

struct Token
{
	enum TokenType  Type;
	const String*   Value;
};

typedef struct Token 
Token,
TokenArray[];

struct TokenStrEntry
{
	str Str;
};

struct TokenS
{
	ETokenType Type;
	String     Value[1];
};

ForceInline 
Token* Internal_Token_EOF()
{
	static 
	const struct TokenS 
	_Token_EOF =
	{
		Tok_Comp_EOF,
		{ STok_Comp_EOF }
	};
	
	return cast(Token*)(ptrof _Token_EOF);
}

#define Token_EOF Internal_Token_EOF()


Token* Token_Init(ETokenType _type, const String* _value);


ForceInline
const struct TokenStrEntry*
Internal_TokenTo()
{
	static 
	const struct TokenStrEntry
	_TokenToArray[TokenType_ArraySize] = 
	{
	#define Entry(_enum)    { #_enum },

	#include "TokenEntires.inline.macro"

	#undef Entry
	};
	
	return _TokenToArray;
}
#define TokenTo Internal_TokenTo()

enum TokenType
ToToken(str _str);





#define Tokens__Def
#endif
