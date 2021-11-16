#ifndef Tokens__Def

#include "LAL.h"

enum TokenType
{
	TokenT_Comment,
	TokenT_Formmating,
	TokenT_Parameters,
	TokenT_Literal,
	TokenT_Sector,
	TokenT_Specifier,
	TokenT_Statement,
	TokenT_Operator,
	TokenT_Symbol
};

enum LiteralType
{
	LiteralT_Character,
	LiteralT_Binary,
	LiteralT_Hex,
	LiteralT_Digit,
	LiteralT_String	
};

enum SymbolType
{
	SymT_Procedure = bit(0),
	SymT_Struct = bit(1),
	SymT_DataType = bit(2),
};

// Universal Tokens
enum TokenU
{
	CMT_SS,
	CMT_SD,
	CMT_DS,
	
	FMT_WSS,
	FMT_OB,
	FMT_CB,
	FMT_NL,
	FML_EOF,
	
	Params_PStart,
	Params_PEnd,
	Params_AB_Start,
	Params_AB_End,
	Params_SB_Start,
	Params_SB_End,
	
	OP_SSA,
	OP_SMA,
	OP_Map,
	OP_Cast,
	OP_TypeOf,
	OP_GetElement,
	
	Literal_CD,
	Litearl_Binary,
	Literal_Tenary,
	Literal_Octal,
	Literal_Hex,
	Literal_Digit,
	Literal_String,
	
	Sec_alias,
	Sec_append,
	Sec_ct,
	Sec_else,
	Sec_enum,
	Sec_expose,
	Sec_identifier,
	Sec_if,
	Sec_in,
	Sec_layer,
	Sec_meta,
	Sec_ro,
	Sec_mut,
	Sec_struct,
	
	Def_start,
	Def_end,
	Def_WSD,
	Def_CD,
	
	Sym_Identifier,
	Sym_TType
};

// Layer 0 Tokens
enum TokenL0
{
	OP_alignof,
	OP_identifier,
	OP_offsetof,
	OP_posof,
	OP_sizeof,
	
	OP_ptr,
	OP_val,

	OP_ret,
	OP_pop,
	OP_push,
	OP_goto,
	OP_continue,
	OP_break,
	OP_CallProc,
	
	OP_LNot,
	OP_LAnd,
	OP_LOr,
	OP_BAnd,
	OP_BOr,
	OP_BXOr,
	OP_BNot,
	OP_BSL,
	OP_BSR,
	
	OP_Add,
	OP_Subtract,
	OP_Divide,
	OP_Modulo,
	OP_Increment,
	OP_Decrement,
	OP_Equal,
	OP_NotEqual,
	OP_GreaterEqual,
	OP_LesserEqual,
	
	OP_Assign,
	OP_ABAnd,
	OP_ABOr,
	OP_ABNot,
	OP_ABSL,
	OP_ABSR,
	OP_AAdd,
	OP_ASubtract,
	OP_AMultiply,
	OP_ADivide,
	OP_AModulo,
	
	
	Sec_binary,
	Sec_ternary,
	Sec_octal,
	Sec_hex,
	Sec_inline,
	Sec_interrupt,
	Sec_label,
	Sec_loop,
	Sec_mempage,
	Sec_proc,
	Sec_stack,
	Sec_static,
	
	
	Specifier_align,
	Specifier_register,
	Specifier_strict,
	Specifier_volatile,
	
	
	Sym_Ptr,
	Sym_Byte,
	Sym_Word,
};


// Token Sets
enum TokenSet
{
	U,
	L0,
	L1,
	L2,
	L3,
	L4,
	L5
};

#define Tokens__Def
#endif
