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
	fmt_S  = "Formatting",
	
# Captures
	cap_PStart  = "Capture: Parenthesis Start",
	cap_PEnd    = "Capture: Parenthesis End",
	cap_ABStart = "Angle Bracket Start",
	cap_ABEnd   = "Angle Bracket End",
	cap_SBStart = "Capture: Bracket Start",
	cap_SBEnd   = "Capture: Square Bracket End",

	def_Start = "start definition block",
	def_End   = "end definition block",
		
# Operators
	op_Define = "Define",
	op_CD     = "Comma delimiter",
	op_SMA    = "Member Resolution",
	op_Map    = "Map Resolution",
	
# Literals
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
	sec_LP    = "Language Platform",
#	sec_Meta  = "Metaprogramming",
	sec_TT    = "Translation Time",
	
	# Symbol Context Aliasing
#	sec_Alias = "Aliasing",
#	sec_In    = "Expose Member Symbols",
		
	# Conditional
	sec_If   = "Conditional If",
	sec_Else = "Conditional Else",
	
	# General
#	sec_Expose = "Expose symbol as",
	sec_Enum   = "Enumeration",
	
# Symbols
	sym_Identifier = "Module Defined Symbol",  # Also used as a sector
	
	# LP Symbols
	sym_Self   = "Self Referiential Symbol", 
	sym_Type   = "Type Symbol / Top Type",     # Also used as a sector.
#	sym_Invalid = "Invalid",
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
#	op_A_Add      = "Assign Add",
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
#	sec_Union    = "Discriminated Union",
	
	# Execution
	sec_Exe      = "Execution Block",
#	sec_Inline   = "Redefine Inplace",
#	sec_Operator = "Operator Defining",
#	sec_Proc     = "Procedure",                          # May not need
	
# Symbols
#	sym_Byte     = "Smallest Addressable Unit of Bits",
	sym_RO       = "Read-Only",                          # ALso used as a sector
	sym_Ptr      = "Address Pointer",                    # Also used as operator.
#	sym_Register = "Register Type",
#	sym_Word     = "Machine data model width"
#------------------------------------------------------------------------------------- Layer 0   END

#------------------------------------------------------------------------------------- Layer OS
# Operators
	# Memory
	op_Alloc   = "Memory Allocate",
	op_Free    = "Memory Free",
	op_Resize  = "Memory Resize",
	op_Wipe    = "Memory Wipe (Free All)",
# Symbols
	# Memory
	sym_Heap = "Heap Memory Block",     # Also used as sector.
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
# Sectors
#	sec_FN = "Function"
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
	TType.fmt_S : "start whitespace.repeat(1-).lazy",
	
	TType.cmt_SL : "start // inline.repeat(0-)",
	TType.cmt_ML : "start /* set(whitespace !whitespace).repeat(0-).lazy */",
	
	TType.cap_PStart  : "start \\(",
	TType.cap_PEnd    : "start \\)",
	TType.cap_ABStart : "start \\<",
	TType.cap_ABEnd   : "start \\>",
	TType.cap_SBStart : "start \\[",
	TType.cap_SBEnd   : "start \\]",
	
	TType.op_Equal        : "start ==",
	TType.op_NotEqual     : "start \\!=",
	TType.op_GreaterEqual : "start >=",
	TType.op_LesserEqual  : "start <=",
	TType.op_Greater      : "start >",
	TType.op_Lesser       : "start <",
	
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
	TType.op_BSL  : "start <<",
	TType.op_BSR  : "start >>",
	
	TType.op_Add       : "start \\+",
	TType.op_Subtract  : "start \\\\-",
	TType.op_Multiply  : "start *",
	TType.op_Divide    : "start \\/",
	TType.op_Modulo    : "start \\%",

	TType.def_Start : "start set(  {)",
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
	
	TType.sec_If     : "start \"if\"",
	TType.sec_Else   : "start \"else\"",
	
	TType.sec_Enum   : "start \"enum\"",
	TType.sec_Exe    : "start \"exe\"",
	TType.sec_LP     : "start \"LP\"",
	TType.sec_Loop   : "start \"loop\"",
	
	TType.sec_Stack  : "start \"stack\"",
	TType.sec_Static : "start \"static\"",
	TType.sec_Struct : "start \"struct\"",
	TType.sec_Switch : "start \"switch\"",
	TType.sec_TT     : "start \"tt\"",
		
	TType.sym_Allocator : "start \"allocator\"",
	TType.sym_Heap      : "start \"heap\"",
	TType.sym_Ptr       : "start \"ptr\"",
	TType.sym_RO        : "start \"ro\"",
	TType.sym_Self      : "start \"self\"",
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
		(	set(A-z).repeat(1-) |
			set(\\_).repeat(1-)
		).repeat(0-1)
		(	set(A-z).repeat(1-) |
			set(\\_).repeat(1-) |
			set(0-9).repeat(1-) 
		).repeat(0-)
	"""
}


class Token extends RefCounted:
	var Type  : String
	var Value : String


var SourceText : String
var Cursor     : int
var SpecRegex  : Dictionary
var Tokens     : Array
var TokenIndex : int = 0


func compile_regex():
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
			Cursor      += ( result.get_string().length() )
			
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
		compile_regex()
