#ifndef Tokens__Def

#include "Core.h"


enum TokenType
{
//---------------------------------------------------------- Universal
		
		Cmt_SS,
#define STok_Cmt_SS                 SL("//")
#define STok_Cmt_SC                 SL("/-")
#define STok_Cmt_EC                 SL("-/")
		Cmt_Body,
#define STok_Cmt_Body               SL("/-{Body}-/")

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
	
		Params_PStart,
#define Tok_Params_PStart           '('
#define STok_Params_PStart          SL("(")
		Params_PEnd,
#define Tok_Params_PEnd             ')'
#define STok_Params_PEnd            SL(")")
		Params_ABStart,
#define Tok_Params_ABStart          '<'
#define STok_Params_ABStart         SL("<")
		Params_ABEnd,
#define Tok_Params_ABEnd            '>'
#define STok_Params_ABEnd           SL(">")
		Params_SBStart,
#define Tok_Params_SBStart          '['
#define STok_Params_SBStart         SL("[")
		Params_SBEnd,
#define Tok_Params_SBEnd            ']'
#define STok_Params_SBEnd           SL("]")

		OP_SMA,
#define Tok_OP_SMA                  '.'
#define STok_OP_SMA                 SL(".")
		OP_Map,
#define STok_OP_Map                 SL("->")

		Literal_Char,
#define STok_Literal_Char           SL("{char}")
		Literal_Binary,
#define	STok_Literal_Binary         SL("{binary}")
		Literal_Ternary,
#define STok_Literal_Ternary        SL("{Ternary}")
		Literal_Octal,
#define STok_Literal_Octal          SL("{Octal}")
		Literal_Hex,
#define STok_Literal_Hex            SL("{Hex}")
		Literal_Digit,
#define STok_Literal_Digit          SL("{0-9}")
		Literal_String,
#define STok_Literal_String         SL("{string}")
		

		Sec_TT,
#define STok_Sec_TT                 SL("tt")
		Sec_Alias,
#define STok_Sec_Alias              SL("alias")
		Sec_Expose,
#define STok_Sec_Expose             SL("expose")
		Sec_In,
#define STok_Sec_In                 SL("in")
		Sec_Layer,
#define STok_Sec_Layer              SL("layer")
		Sec_Meta,
#define STok_Sec_Meta               SL("meta")
		Sec_Macro,
#define STok_Sec_Macro				SL("macro")
		Sec_If,
#define STok_Sec_If                 SL("if")
		Sec_Else,
#define STok_Sec_Else               SL("else")
		Sec_Enum,
#define STok_Sec_Enum               SL("enum")
		Sec_DefSym,
#define STok_Sec_DefSym				SL("{Identifier}")
		Sec_Sym_Type,
#define STok_Sec_Sym_Type			SL("type")

		Def_Start,
#define Tok_Def_Start               ':'
#define Tok_Def_StartB				'{'
#define STok_Def_Start              SL(":")
#define STok_Def_StartB				SL("{")
		Def_End,
#define Tok_Def_End                 ';'
#define Tok_Def_EndB				'}'
#define STok_Def_End                SL(";")
#define STok_Def_EndB				SL("}")
		Def_CD,
#define Tok_Def_CD                  ','
#define STok_Def_CD                 SL(",")

		// Sym_TType = Sec_Type,
// #define STok_Sym_TType              SL("type")
		Sym_Identifier,
#define STok_Sym_Identifier         SL("{Identifier}")
		Sym_Invalid,
#define STok_Sym_Invalid            SL("{undefined}")

//------------------------------------------------------------ Layer 0

		OP_AlignOf,
#define STok_OP_AlignOf             SL("alignof")
		OP_Cast,					
#define STok_OP_Cast				SL("cast")
		OP_OffsetOf,
#define STok_OP_OffsetOf            SL("offsetof")
		OP_PosOf,
#define STok_OP_PosOf               SL("posof")
		OP_SizeOf,
#define STok_OP_SizeOf              SL("sizeof")
		
		OP_Sym_Ptr,
#define STok_OP_Sym_Ptr             SL("ptr")
		OP_Val,
#define STok_OP_Val                 SL("val")

		OP_Break,
#define STok_OP_Break               SL("break")
		OP_Continue,
#define STok_OP_Continue            SL("continue")
		OP_Goto,
#define STok_OP_Goto                SL("goto")
		OP_Pop,
#define STok_OP_Pop                 SL("pop")
		OP_Push,
#define STok_OP_Push                SL("push")
		OP_Return,
#define STok_OP_Return              SL("ret")

		OP_LNot,
#define Tok_OP_LNot                 '!'
#define STok_OP_LNot                SL("!")
		OP_LAnd,
#define STok_OP_LAnd                SL("&&")
		OP_LOr,
#define STok_OP_LOr                 SL("||")
		OP_BAnd,
#define STok_OP_BAnd                SL("&")
		OP_BOr,
#define STok_OP_BOr                 SL("|")
		OP_BXOr,
#define STok_OP_BXOr                SL("^")
		OP_BNot,
#define Tok_OP_BNot                 '~'
#define STok_OP_BNot                SL("~")
		OP_BSL,
#define STok_OP_BSL                 SL("<<")
		OP_BSR,
#define STok_OP_BSR                 SL(">>")
		
		OP_Add,
#define Tok_OP_Add                  '+'
#define STok_OP_Add                 SL("+")
		OP_Subtract,
#define Tok_OP_Subtract             '-'
#define STok_OP_Subtract            SL("-")
		OP_Multiply,
#define Tok_OP_Multiply             '*'
#define STok_OP_Multiply            SL("*")
		OP_Divide,
#define Tok_OP_Divide               '/'
#define STok_OP_Divide              SL("/")
		OP_Modulo,
#define Tok_OP_Modulo               '%'
#define STok_OP_Modulo              SL("%")
		OP_Increment,
#define STok_OP_Increment           SL("++")
		OP_Decrement,
#define STok_OP_Decrement           SL("--")
		OP_Equal,
#define STok_OP_Equal               SL("==")
		OP_NotEqual,
#define STok_OP_NotEqual            SL("!=")
		OP_GreaterEqual,
#define STok_OP_GreaterEqual        SL(">=")
		OP_LesserEqual,
#define STok_OP_LesserEqual         SL("<=")

		OP_Assign,
#define Tok_OP_Assign               '='
#define STok_OP_Assign              SL("=")
		OP_AB_And,
#define STok_OP_AB_And              SL("&=")
		OP_AB_Or,
#define STok_OP_AB_Or               SL("|=")
		OP_AB_XOr,
#define STok_OP_AB_XOr              SL("^=")
		OP_AB_Not,
#define STok_OP_AB_Not              SL("~=")
		OP_AB_SL,
#define STok_OP_AB_SL               SL("<<=")
		OP_AB_SR,
#define STok_OP_AB_SR               SL(">>=")
		OP_A_Add,
#define STok_OP_A_Add               SL("+=")
		OP_A_Subtract,
#define STok_OP_A_Subtract          SL("-=")
		OP_A_Multiply,
#define STok_OP_A_Multiply          SL("*=")
		OP_A_Divide,
#define STok_OP_A_Divide            SL("/=")
		OP_A_Modulo,
#define STok_OP_A_Modulo            SL("%=")

		Sec_Binary,
#define STok_Sec_Binary             SL("binary")
		Sec_Ternary,
#define STok_Sec_Ternary            SL("ternary")
		Sec_Octal,
#define STok_Sec_Octal              SL("octal")
		Sec_Hex,
#define STok_Sec_Hex                SL("hex")

		Sec_Label,
#define STok_Sec_Label				SL("label")
		Sec_Loop,
#define STok_Sec_Loop				SL("loop")

		Sec_Align,
#define STok_Sec_Align              SL("align")
		Sec_Embed,
#define STok_Sec_Embed              SL("embed")
		Sec_Mempage,
#define STok_Sec_Mempage            SL("mpage")
		Sec_Register,
#define STok_Sec_Register           SL("register")
		Sec_Ro,
#define STok_Sec_Ro                 SL("ro")
		Sec_Stack,
#define STok_Sec_Stack              SL("stack")
		Sec_Static,
#define STok_Sec_Static             SL("static")
		Sec_Strict,
#define STok_Sec_Strict             SL("strict")
		Sec_Struct,
#define STok_Sec_Struct             SL("struct")
		Sec_Volatile,
#define STok_Sec_Volatile           SL("volatile")
		Sec_Union,
#define STok_Sec_Union				SL("union")

		Sec_Exe,
#define STok_Sec_Exe				SL("exe")
		Sec_Inline,
#define STok_Sec_Inline             SL("inline")	
		Sec_Interrupt,
#define STok_Sec_Interrupt			SL("Interrupt")
		Sec_OP,
#define STok_Sec_OP					SL("op")
		Sec_Proc,
#define STok_Sec_Proc               SL("proc")

		// Sym_Ptr = OP_Ptr,
// #define STok_Sym_Ptr                SL("ptr")
		Sym_Byte,
#define STok_Sym_Byte               SL("byte")
		Sym_Word,
#define STok_Sym_Word               SL("word")

//------------------------------------------------------------ Layer 1

		OP_Alloc,
#define STok_OP_Alloc               SL("allocate")
		OP_Dealloc,
#define STok_OP_Dealloc             SL("deallocate")

		OP_TypeOf,
#define STok_OP_TypeOf              SL("typeof")

		Sec_Heap,
#define STok_Sec_Heap               SL("heap")

		Sec_For,
#define STok_Sec_For                SL("for")

// Layer 2-4 are unsupported in the C implementation.

		Token_Invalid,

		TokenType_ArraySize = Token_Invalid,
		TokenType_Size      = S32_Max
};


typedef s32
ETokenType;

typedef struct Token        	Token;
typedef struct DArray_Tokens	DArray_Tokens;


struct Token
{
	ETokenType      Type;
	const String*   Value;
};

struct DArray_Tokens
{	
	Token*    Data;
	const sw* Length;
};

struct TokenStrEntry
{
	str Str;
};

struct TokenS
{
	ETokenType Type;
	String     Value[1];
};


#define Token_CmtEmpty  Internal_Token_CmtEmpty()
inline
Token* Internal_Token_CmtEmpty()
{
	static
	const struct TokenS
	_Token_Cmt_Empty =
	{
		Cmt_Body,
		{ { sizeof(""), "" } }
	};
	
	return cast(Token*)(ptrof _Token_Cmt_Empty);
}

#define Token_EOF   Internal_Token_EOF()
inline
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

#define InvalidToken 	Internal_Token_Invalid()
inline
Token* Internal_Token_Invalid()
{
	static
	const struct TokenS
	_Token_Invalid =
	{
		Token_Invalid,
		{ SL("Invalid Token :(") }
	};

	return cast(Token*)(ptrof _Token_Invalid);
}

#define TokenTo Internal_TokenTo()
inline
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


enum TokenType
ToToken(str _str);

#define Tokens__Def
#endif
