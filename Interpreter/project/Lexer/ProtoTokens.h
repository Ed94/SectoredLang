#ifndef ProtoToekns__Def

#include "Core.h"


enum TokenType
{
// Universal

#define Tok_Comp_WS                 ' '
#define Tok_Comp_UnderS             '_'
#define Tok_Comp_Null               '\0'
#define Tok_Comp_EOF                EOF
#define Tok_Literal_String_DLim     '"'
#define STok_Literal_String_DLim    "\""

#define Tok_Fmt_Tab                 '\t'
#define Tok_Fmt_CR                  '\r'
#define Tok_Fmt_NL                  '\n'
#define Tok_Fmt_OB                  '{'
#define Tok_Fmt_CB                  '}'
	
		Params_PStart,
#define Tok_Params_PStart           '('
#define STok_Params_PStart          "("
		Params_PEnd,
#define Tok_Params_PEnd             ')'
#define STok_Params_PEnd            ")"

		OP_Assign,
#define Tok_OP_Assign               '='
#define STok_OP_Assign              "="
	
		Literal_String,
#define STok_Literal_String         "{string}"
		
		Def_Start,
#define Tok_Def_Start               ':'
#define STok_Def_Start              ":"
		Def_End,
#define Tok_Def_End                 ';'
#define STok_Def_End                ";"

		Sym_TType,
#define STok_Sym_TType              "type"
		Sym_User,
#define STok_Sym_User               "{Identifier}"
		Sym_Invalid,
#define SToke_Sym_Invalid           "{undefined}"

// Layer 0

		Sec_Static,
#define STok_Sec_Static             "static"

		Sym_Ptr,
#define STok_Sym_Ptr                "ptr"
		Sym_Byte,
#define STok_Sym_Byte               "byte"

		EToken_Invalid
#define TokenType_Size EToken_Invalid
};

typedef enum TokenType 
ETokenType;

struct Token
{
	ETokenType  Type;
	str         Value;
};

typedef struct Token 
Token,
TokenArray[];

struct TokenStrEntry
{
	str Str;
};


Token* Token_Init(ETokenType _type, str _value);


ForceInline
const struct TokenStrEntry*
Internal_TokenTo()
{
	const static
	struct TokenStrEntry
	Internal_TokenToArray[] = 
	{
	#define Entry(_enum)    { #_enum },

	#include "TokenEntires.inline.macro"

	#undef Entry
	};
		
	return Internal_TokenToArray;
}
#define TokenTo Internal_TokenTo()

enum TokenType
ToToken(str _str);

#define ProtoTokens__Def
#endif
