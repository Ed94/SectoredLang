class_name Lexer extends Object

var SRX = SRegex.new()


# NOTE:
# The lexer model used here is able to tokenize symbols that the interpreter at the 
# "GDScript level" of implementation will not be able to support (Or possibly LLVM for that matter).
# So those tokens will not be support on the demo langauge platform.

const TType : Dictionary = \
{
#----------------------------------------------------------------------------------------- Universal
# Comments
	cmt_SL = "Comment Single-Line",
	cmt_ML = "Comment Multi-Line",

# Formatting
	fmt_S  = "Formatting",							# Regex yeets it all with one expr.
	fmt_NL = "Formatting: NewLine",
	
# Captures
	cap_PStart  = "Capture: Parenthesis Start",
	cap_PEnd    = "Capture: Parenthesis End",
	cap_SBStart = "Capture: Bracket Start",
	cap_SBEnd   = "Capture: Square Bracket End",

	def_Start = "start definition block",
	def_End   = "end definition block",
		
# Operators
	op_Define = "Define",
	op_CD     = "Comma delimiter",
	op_SMA    = "Member Resolution",
	op_Map    = "Map Resolution",
	
# Literals	(All literals are expression elements)
	literal_True    = "Bool: True",
	literal_False   = "Bool: False",
	literal_Char    = "Character",
	literal_Binary  = "Binary",
	literal_Octal   = "Octal",
	literal_Hex     = "Hex",
	literal_Decimal = "Decimal Format",  
	literal_Digit   = "Integer Digits",
	literal_String  = "Literal: String",

# Sectors
	# Directors
#	sec_Layer = "Explicit LP layer use",
#	sec_Meta  = "Metaprogramming",

	# Symbol Context Aliasing
	sec_Alias = "Aliasing",
	sec_Using = "Expose Member Symbols",
		
	# Conditional
	sec_If   = "Conditional If",
	sec_Else = "Conditional Else",

# Symbols
	sym_Enum   = "Enumeration",					# Sector, Type Constraint
	sym_LP     = "Language Platform",			# Sector
	sym_Self   = "Self Referiential Symbol",	# Capture Term
	sym_TT     = "Translation Time",			# Sector, Specifier
	sym_Type   = "Type Symbol / Top Type",      # Sector, Type
#	sym_Invalid = "Invalid",

	sym_Identifier = "Module Defined Symbol",	# Sector, Expression Element

#------------------------------------------------------------------------------------- Universal END

#------------------------------------------------------------------------------------- Layer 0
# Operators
	# Inference
#	op_Alignof  = "Alignment Accessor",
#	op_OffsetOf = "Member Offset",
#	op_PosOf    = "Member Position",
	op_SizeOf   = "Type Memory Footprint", 
	
	# Indirection
#	op_Val = "Value Accessor",
	
	# Execution
	op_Break    = "Jump out of block",
#	op_Continue = "Jump to start of loop",
#	op_Fall     = "Switch fall directive",
#	op_GoTo     = "Jump to label",
#	op_Pop      = "Pop current stack",
#	op_Push     = "Push current stack",
	op_Return   = "Return",
	
	# Logical
	op_LNot  = "Logical Not",
	op_LAnd  = "Logical And",
	op_LOr   = "Logical Or",
	op_BAnd  = "Bitwise And",
	op_BOr   = "Bitwise Or",
	op_BXOr  = "Bitwise XOr",
	op_BNot  = "Bitwise Not",
	op_BSL   = "Bitwise Shift Left",
	op_BSR   = "Bitwise Shift Right",
	
	# Arithmetic
	op_Add       = "Addition",
	op_Subtract  = "Subtraction",
	op_Multiply  = "Multiply",
	op_Divide    = "Divide",
	op_Modulo    = "Modulo",
#	op_Increment = "Increment",
#	op_Decreemnt = "Decrement",
	
	# Relational
	op_Equal        = "Equals",
	op_NotEqual     = "Not Equal",
	op_Greater      = "Greater",
	op_Lesser       = "Lesser",
	op_GreaterEqual = "Greater Equal",
	op_LesserEqual  = "Lesser Equal",
	
	# Assignment
	op_A_Infer    = "Type Inferred Assignment",
	op_Assign     = "Assignment",
#	op_AB_And     = "Assign Bit And",
#	op_AB_Or      = "Assign Bit Or",
#	op_AB_XOr     = "Assign Bit XOr",
#	op_AB_Not     = "Assign Bit Not",
#	op_AB_SL      = "Assign Bit Shift Left",
#	op_AB_SR      = "Assign Bit Shift Right",
	op_A_Add      = "Assign Add",
#	op_A_Subtract = "Assign Subtract",
#	op_A_Multiply = "Assign Multiply",
#	op_A_Divide   = "Assign Divide",
#	op_A_Modulo   = "Assign Modulo",
	
# Sectors
	# Encoding
#	sec_Binary  = "Binary Block",
#	sec_Octal   = "Octal Block",
#	sec_Hex     = "Hex BLock",
	
	# Control Flow
#	sec_Label   = "Label",
	sec_Loop    = "Loop execution",
	sec_Switch  = "Switch on value",
	
	# Memory 
#	sec_Align    = "Alignment",
#	sec_Mempage  = "Memory Paging Segments",
	sec_Stack    = "Stack Segment",
	sec_Static   = "Static Segment",
#	sec_Strict   = "Strict Reference",
	sec_Struct   = "Data Record/ Structure", 
#	sec_Volatile = "Volatile Reference",
	sec_Union    = "Discriminated Union",
	
	# Execution
#	sec_Inline   = "Redefine Inplace",
#	sec_Operator = "Operator Defining",
	
# Symbols
	sym_Byte     = "Smallest Addressable Unit of Bits",		# Type
	sym_Exe      = "Execution Block",						# Sector, Type
	sym_RO       = "Read-Only",								# Sector, Specifier
	sym_Ptr      = "Address Pointer",						# Type
#	sym_Register = "Register Type",
#------------------------------------------------------------------------------------- Layer 0   END

#------------------------------------------------------------------------------------- Layer OS
# Operators
	# Memory
	op_Alloc   = "Memory Allocate",
	op_Free    = "Memory Free",
	op_Resize  = "Memory Resize",
	op_Wipe    = "Memory Wipe (Free All)",
# Sectors
	sec_Heap = "Heap Memory Block",     # Sector, 
# Symbols
	# Memory
	sym_Allocator = "Allocator Symbol", # Also used as sector.
#------------------------------------------------------------------------------------- Layer OS  END

#------------------------------------------------------------------------------------- Layer 1
# Operators
	# Type System
	op_Cast   = "Type cast",
#	op_TypeOf = "Type Accessor",
	
# Sectors
	# Execution
#	sec_SOA = "Secture of Arrays",
#------------------------------------------------------------------------------------- Layer 1   END

#------------------------------------------------------------------------------------- Layer 2   
# Operators
	# Type System
	
# Sectors
	# Execution
#	sec_Interface = "Dispatch Specification",
#	sec_Trait     = "Static Dispatch",
#	sec_Virtual   = "Dynamic Dispatch",
	# Memory
#	sec_Mut       = "Mutable"
#------------------------------------------------------------------------------------- Layer 2   END

#------------------------------------------------------------------------------------- Layer 3
# Sectors
	# Memory
#	sec_GC = "Garbage Collector",
#------------------------------------------------------------------------------------- Layer 3   END

#------------------------------------------------------------------------------------- Layer 4
#------------------------------------------------------------------------------------- Layer 4   END

#------------------------------------------------------------------------------------- Godot     
# Symbols
	sym_gd_Bool   = "bool",
	sym_gd_Int    = "int",
	sym_gd_Float  = "float",
	sym_gd_Array  = "Array",
	sym_gd_Dict   = "Dictionary",
	sym_gd_String = "String",
#------------------------------------------------------------------------------------- Godot     END
}

const Spec : Dictionary = \
{
	TType.fmt_NL : "start \\R",
	TType.fmt_S  : "start whitespace.repeat(1-).lazy",
	
	TType.cmt_SL : "start // inline.repeat(0-)",
	TType.cmt_ML : "start /* set(whitespace !whitespace).repeat(0-).lazy */",
	
	TType.cap_PStart  : "start \\(",
	TType.cap_PEnd    : "start \\)",
	TType.cap_SBStart : "start [",
	TType.cap_SBEnd   : "start ]",
	
	TType.op_BSL  : "start <<",
	TType.op_BSR  : "start >>",
	
	TType.op_Equal        : "start ==",
	TType.op_NotEqual     : "start \\!=",
	TType.op_GreaterEqual : "start >=",
	TType.op_LesserEqual  : "start <=",
	TType.op_Greater      : "start >",
	TType.op_Lesser       : "start <",
	
	TType.op_A_Add : "start \\+\\=",
	
	TType.op_A_Infer : "start :=",
	TType.op_Assign  : "start =",
	TType.op_Define  : "start :",
	TType.op_Map     : "start \\->",
	
	TType.op_LNot : "start \\!",
	TType.op_LAnd : "start &&",
	TType.op_LOr  : "start ||",
	TType.op_BNot : "start \\~",
	TType.op_BAnd : "start \\&",
	TType.op_BOr  : "start \\|",
	TType.op_BXOr : "start \\^",
	
	TType.op_Add       : "start \\+",
	TType.op_Subtract  : "start \\-",
	TType.op_Multiply  : "start *",
	TType.op_Divide    : "start /",
	TType.op_Modulo    : "start \\%",

	TType.def_Start : "start {",
	TType.def_End   : "start set(; })",
	
	TType.op_CD  : "start \\,",
	TType.op_SMA : "start \\.",
	
	TType.op_Break  : "start \"break\"",
	TType.op_Cast   : "start \"cast\"",
	TType.op_Return : "start \"ret\"",
	TType.op_SizeOf : "start \"sizeof\"",
	
	TType.op_Alloc      : "start \"allocate\"",
	TType.op_Free       : "start \"free\"",
	TType.op_Resize     : "start \"resize\"",
	TType.op_Wipe       : "start \"wipe\"",
	
	TType.literal_True   : "start \"true\"",
	TType.literal_False  : "start \"false\"",
	TType.literal_Binary  : "start 0b set(0-1).repeat(1-)",
	TType.literal_Octal   : "start 0o set(0-7).repeat(1-)",
	TType.literal_Hex     : "start 0x (set(0-9)|set(A-F)|set(a-f)).repeat(1-)",
	TType.literal_Decimal : \
	"""start 
		set(+ \\-).repeat(0-1)	
		set(0-9).repeat(1-) \\..repeat(1) 
		set(0-9).repeat(1-) 
	""",
	TType.literal_Digit  : "start set(+ \\-).repeat(0-1) set(0-9).repeat(1-)",
	TType.literal_Char   : "start \\\' !set( \\\' ).repeat(1) \\\'",
	TType.literal_String : "start \\\" !set( \\\" ).repeat(0-) \\\" ",
	
	TType.sec_Alias  : "start \"alias\"",
	TType.sec_Else   : "start \"else\"",
	TType.sec_If     : "start \"if\"",
	TType.sec_Stack  : "start \"stack\"",
	TType.sec_Static : "start \"static\"",
	TType.sec_Struct : "start \"struct\"",
	TType.sec_Switch : "start \"switch\"",
	TType.sec_Union  : "start \"union\"",
	TType.sec_Using  : "start \"using\"",
		
	TType.sym_Allocator : "start \"allocator\"",
	TType.sym_Byte      : "start \"byte\"",
	TType.sym_Enum      : "start \"enum\"",
	TType.sym_Exe       : "start \"exe\"",
	TType.sym_LP        : "start \"LP\"",
	TType.sec_Loop      : "start \"loop\"",
	TType.sec_Heap      : "start \"heap\"",
	TType.sym_Ptr       : "start \"ptr\"",
	TType.sym_RO        : "start \"ro\"",
	TType.sym_Self      : "start \"self\"",
	TType.sym_TT        : "start \"tt\"",
	TType.sym_Type      : "start \"type\"",
	
#------------------------------------------- Godot specific symbols
	TType.sym_gd_Bool   : "start \"bool\"",
	TType.sym_gd_Int    : "start \"int\"",
	TType.sym_gd_Float  : "start \"float\"",
	TType.sym_gd_Array  : "start \"darray\"",
	TType.sym_gd_Dict   : "start \"dmap\"",
	TType.sym_gd_String : "start \"string\"",
#------------------------------------------- Godot specific symbols	END
	
	# Must be last, as if none of the above matches this is the last thing it could be.
	TType.sym_Identifier : 
	"""start 
		(	set(A-Z a-z).repeat(1-) |
			set(\\_).repeat(1-)
		).repeat(0-1)
		(	set(A-Z a-z).repeat(1-) |
			set(\\_).repeat(1-) |
			set(0-9).repeat(1-) 
		).repeat(0-)
	"""
}

const TCatVal = \
{
	formatting        = "Formatting",
	comment           = "Comment",
	capture           = "capture",
	builtin           = "builitin",
	literal           = "literal",
	op_Control        = "OP; Control Flow",
	op_Memory         = "Op: Memory",
	op_Define         = "Op: Define",
	op_Unary          = "Op: Unary",
	op_Assignment     = "Op: Assignment",
	op_Bitshift       = "Op: Bitshift",
	op_Logical        = "Op: Logical",
	op_Additive       = "Op: Additive",
	op_Multiplicative = "Op: Multiplicative",
	op_Member         = "Op: Member",
	scope             = "scope",
	sector            = "Sector",
	symbol            = "Symbol",
}

const TCategory = \
{
	TType.fmt_NL : TCatVal.formatting,
	TType.fmt_S  : TCatVal.formatting,
	
	TType.cmt_SL : TCatVal.comment,
	TType.cmt_ML : TCatVal.comment,
	
	TType.cap_PStart  : TCatVal.capture,
	TType.cap_PEnd    : TCatVal.capture,
	TType.cap_SBStart : TCatVal.capture,
	TType.cap_SBEnd   : TCatVal.capture,
	
	TType.op_BSL  : TCatVal.op_Bitshift,
	TType.op_BSR  : TCatVal.op_Bitshift,
	
	TType.op_Equal        : TCatVal.op_Logical,
	TType.op_NotEqual     : TCatVal.op_Logical,
	TType.op_GreaterEqual : TCatVal.op_Logical,
	TType.op_LesserEqual  : TCatVal.op_Logical,
	TType.op_Greater      : TCatVal.op_Logical,
	TType.op_Lesser       : TCatVal.op_Logical,
	
	TType.op_A_Add : TCatVal.op_Assignment,
	
	TType.op_A_Infer : TCatVal.op_Assignment,
	TType.op_Assign  : TCatVal.op_Assignment,
	TType.op_Define  : TCatVal.op_Define,
	TType.op_Map     : TCatVal.op_Define,
	
	TType.op_LNot : TCatVal.op_Unary,
	TType.op_LAnd : TCatVal.op_Logical,
	TType.op_LOr  : TCatVal.op_Logical,
	TType.op_BNot : TCatVal.op_Unary,
	TType.op_BAnd : TCatVal.op_Logical,
	TType.op_BOr  : TCatVal.op_Logical,
	TType.op_BXOr : TCatVal.op_Logical,
	
	TType.op_Add       : TCatVal.op_Additive,
	TType.op_Subtract  : TCatVal.op_Additive,
	TType.op_Multiply  : TCatVal.op_Multiplicative,
	TType.op_Divide    : TCatVal.op_Multiplicative,
	TType.op_Modulo    : TCatVal.op_Multiplicative,

	TType.def_Start : TCatVal.scope,
	TType.def_End   : TCatVal.scope,
	
	TType.op_CD  : "op_CD",
	TType.op_SMA : "op_SMA",
	
	TType.op_Break  : TCatVal.op_Control,
	TType.op_Cast   : TCatVal.op_Control,
	TType.op_Return : TCatVal.op_Control,
	
	TType.op_SizeOf : TCatVal.op_Member,
	
	TType.op_Alloc      : TCatVal.op_Memory,
	TType.op_Free       : TCatVal.op_Memory,
	TType.op_Resize     : TCatVal.op_Memory,
	TType.op_Wipe       : TCatVal.op_Memory,
	
	TType.sym_gd_Bool    : TCatVal.builtin,
	TType.sym_gd_Int     : TCatVal.builtin,
	TType.sym_gd_Float   : TCatVal.builtin,
	TType.sym_gd_Array   : TCatVal.builtin,
	TType.sym_gd_Dict    : TCatVal.builtin,
	TType.sym_gd_String  : TCatVal.builtin,
	
	TType.literal_True    : TCatVal.literal,
	TType.literal_False   : TCatVal.literal,
	TType.literal_Binary  : TCatVal.literal,
	TType.literal_Octal   : TCatVal.literal,
	TType.literal_Hex     : TCatVal.literal,
	TType.literal_Decimal : TCatVal.literal,
	TType.literal_Digit   : TCatVal.literal,
	TType.literal_Char    : TCatVal.literal,
	TType.literal_String  : TCatVal.literal,
	
	TType.sec_Alias  : TCatVal.sector,
	TType.sec_Else   : TCatVal.sector,
	TType.sec_If     : TCatVal.sector,
	TType.sec_Stack  : TCatVal.sector,
	TType.sec_Static : TCatVal.sector,
	TType.sec_Struct : TCatVal.sector,
	TType.sec_Switch : TCatVal.sector,
	TType.sec_Union  : TCatVal.sector,
	TType.sec_Using  : TCatVal.sector,
		
	TType.sym_Allocator  : TCatVal.symbol,
	TType.sym_Byte       : TCatVal.symbol,
	TType.sym_Enum       : TCatVal.symbol,
	TType.sym_Exe        : TCatVal.symbol,
	TType.sym_LP         : TCatVal.symbol,
	TType.sec_Loop       : TCatVal.symbol,
	TType.sec_Heap       : TCatVal.symbol,
	TType.sym_Ptr        : TCatVal.symbol,
	TType.sym_RO         : TCatVal.symbol,
	TType.sym_Self       : TCatVal.symbol,
	TType.sym_TT         : TCatVal.symbol,
	TType.sym_Type       : TCatVal.symbol,
	TType.sym_Identifier : TCatVal.symbol
}

class Token extends RefCounted:
	var Type  : String
	var Value : String
	
	# Line , Col
	var Start : Vector2i
	var End   : Vector2i

var SourceText : String
var Cursor     : int
var Line       : int
var Column     : int
var SpecRegex  : Dictionary
var Tokens     : Array
var TokenIndex : int = 0


func compile_Regex():
	for type in TType.values() :
		var regex  = RegEx.new()
		var result = SRX.compile( Spec[type] )
		
		regex.compile( result )
		SpecRegex[type] = regex

func next_Token():
	var nextToken = null
	
	if Tokens.size() > TokenIndex :
		nextToken   = Tokens[TokenIndex]
		TokenIndex += 1
	
	return nextToken

func last_Token():
	return Tokens[TokenIndex - 1]

func reached_EndOfText():
	return Cursor >= SourceText.length()

func tokenize(programSrcText):
	SourceText = programSrcText
	Cursor     = 0
	TokenIndex = 0

	Tokens.clear()

	while reached_EndOfText() == false :
		var srcLeft = SourceText.substr(Cursor)
		var token   = Token.new()

		var error = true
		for type in Spec.keys() :
			var result = SpecRegex[type].search( srcLeft )
			if  result == null || result.strings[0].length() == 0 || result.get_start() != 0 :
				continue
				
			if type == TType.fmt_NL:
				var addVal   = result.get_string().length()
				
				Cursor += addVal
				Line   += 1
				Column  = 0
				error   = false
				break
				
			# Skip Whitespace
			if type == TType.fmt_S :
				var addVal   = result.get_string().length()
				
				Cursor += addVal
				error   = false
				break

			# Skip Comments
			if type == TType.cmt_SL || type == TType.cmt_ML :
				Cursor += result.get_string().length()
				error   = false
				break

			token.Type   = type
			token.Value  = result.get_string()
			token.Start  = Vector2i(Line, Column)
			Column      += ( result.get_string().length() )
			Cursor      += Column
			token.End    = Vector2i(Line, Column)
			
			Tokens.append( token )
			
			error = false
			break;

		if error :
			var msgT = "Source text not understood by tokenizer at Cursor pos: {value} : {txt}"
			var msg  = msgT.format({"value" : Cursor, "txt" : srcLeft})
			
			return G.Error.new(false, msg)
			
	return G.allgood


func _init():
	if SpecRegex.size() == 0 :
		compile_Regex()
