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
#	params_PStart  = "Parenthesis Start",
#	params_PEnd    = "Parenthesis End",
#	params_ABStart = "Angle Bracket Start",
#	params_ABEnd   = "Angle Bracket End",
#	params_SBStart = "Square Bracket Start",
#	params_SBEnd   = "Square Bracket End",
#
	def_Start = "start definition block",
	def_End   = "end definition block",
	
#	def_CD = "Comma delimiter",
		
# Operators
#	op_SMA = "Member Resolution",
#	op_Map = "Map Resolution",
	
# Literals
	literal_Char    = "Character",
	literal_Binary  = "Binary",
#	literal_Ternary = "Ternary",
	literal_Octal   = "Octal",
	literal_Hex     = "Hex",
	literal_Decimal = "Decimal Format",  
	literal_Digit   = "Integer Digits",
	literal_String  = "Literal: String",

# Sectors
	# Directors
#	sec_Layer = "Explicit LP layer use",
#	sec_LP    = "Language Platform",
#	sec_Meta  = "Metaprogramming",
#	sec_TT    = "Translation Time",
	
	# Symbol Context Aliasing
#	sec_Alias = "Aliasing",
#	sec_In    = "Expose Member Symbols",
	
	# Symbol Typesystem
#	sec_Depend = "Symbol depends on",
		
	# Conditional
#	sec_If   = "Conditional If",
#	sec_Else = "Conditional Else",
	
	# General
#	sec_Expose = "Expose symbol as",
#	sec_Enum   = "Enumeration",
	sec_Type   = "Type Definition",
	
# Symbols
	sym_Identifier = "Module Defined Symbol",
	
	# LP Symbols
#	sym_TType   = "Top Type",
#	sym_Invalid = "Invalid",
#------------------------------------------------------------------------------------- Universal END

#------------------------------------------------------------------------------------- Layer 0
# Operators
	# Inference
#	op_Alignof  = "Alignment Accessor",
#	op_OffsetOf = "Member Offset",
#	op_PosOf    = "Member Position",
#	op_SizeOf   = "Type Memory Footprint", 
	
	# Indirection
#	op_Ptr = "Pointer Accessor",
#	op_Val = "Value Accessor",
	
	# Execution
#	op_Break    = "Jump out of block",
#	op_Continue = "Jump to start of loop",
#	op_Fall     = "Switch fall directive",
#	op_GoTo     = "Jump to label",
#	op_Pop      = "Pop current stack",
#	op_Push     = "Push current stack",
#	op_Return   = "Return",
	
	# Logical
#	op_LNot  = "Logical Not",
#	op_LAND  = "Logical Amd",
#	op_LOR   = "Logical Or",
#	op_BAND  = "Bitwise And",
#	op_BXOR  = "Bitwise XOr",
#	op_BNOT  = "Bitwise Not",
#	op_BSL   = "Bitwise Shift Left",
#	op_BSR   = "Bitwise Shift Right",
	
	# Arithmetic
	op_Add       = "Addition",
#	op_Subtract  = "Subtraction",
#	op_Multiply  = "Multiply",
#	op_Divide    = "Divide",
#	op_Modulo    = "Modulo",
#	op_Increment = "Increment",
#	op_Decreemnt = "Decrement",
	
	# Relational
#	op_Equals       = "Equals",
#	op_NotEqual     = "Not Equal",
#	op_GreaterEqual = "Greater Equal",
#	op_LesserEqual  = "Lesser Equal",
	
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
#	sec_Ternary = "Ternary Block",
#	sec_Octal   = "Octal Block",
#	sec_Hex     = "Hex BLock",
	
	# Control Flow
#	sec_Label   = "Label",
#	sec_Loop    = "Loop execution",
#	sec_Switch  = "Switch on value",
	
	# Memory 
#	sec_Align    = "Alignment",
#	sec_Mempage  = "Memory Paging Segments",
#	sec_RO       = "Read-Only",
	sec_Static   = "Static Segment",
#	sec_Strict   = "Strict Reference",
#	sec_Struct   = "Data Record/ Structure", 
#	sec_Volatile = "Volatile Reference",
#	sec_Union    = "Discriminated Union",
	
	# Execution
	sec_Exe      = "Execution Block",
#	sec_Inline   = "Redefine Inplace",
#	sec_Operator = "Operator Defining",
#	sec_Proc     = "Procedure",
	
# Symbols
#	sym_Byte     = "Smallest Addressable Unit of Bits",
#	sym_Ptr      = "Address Pointer",
#	sym_Register = "Register Type",
#	sym_Word     = "Machine data model width"
#------------------------------------------------------------------------------------- Layer 0   END

#------------------------------------------------------------------------------------- Layer OS
# Operators
	# Memory
#	op_Alloc   = "Heap Allocate",
#	op_Dealloc = "Heap Deallocate",
# Sectors
	# Memory
#	sec_Heap = "Heap Memory Block",
#------------------------------------------------------------------------------------- Layer OS  END

#------------------------------------------------------------------------------------- Layer 1
# Operators
	# Type System
#	op_Cast   = "Type cast",
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
	literal_True  = "true",
	literal_False = "false",
	
	sym_Bool   = "bool",
	sym_Int    = "int",
	sym_Float  = "float",
	sym_String = "String",
#------------------------------------------------------------------------------------- Godot     END
}

const Spec : Dictionary = \
{
	TType.fmt_S : "start whitespace.repeat(1-).lazy",
	
	TType.cmt_SL : "start // inline.repeat(0-)",
	TType.cmt_ML : "start /* set(whitespace !whitespace).repeat(0-).lazy */",
		
	TType.op_A_Infer : "start :=",
	TType.op_Assign  : "start =",
	
	TType.op_Add : "start \\+",
		
	TType.def_Start : "start set(: {)",
	TType.def_End   : "start set(; })",
	
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
	
	TType.sec_Exe    : "start \"exe\"",
	TType.sec_Static : "start \"static\"",
	TType.sec_Type   : "start \"type\"",
	
	
		
#------------------------------------------- Godot specific symbols
	TType.literal_True   : "start \"true\"",
	TType.literal_False  : "start \"false\"",

	TType.sym_Bool   : "start \"bool\"",
	TType.sym_Int    : "start \"int\"",
	TType.sym_Float  : "start \"float\"",
	TType.sym_String : "start \"String\"",
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


# Lexing UNIT

#class Unit:
#	var SourceText : String
#	var Tokens     : Array
#	var TokenIndex : int = 0
#
#	func next_Token():
#		var nextToken = null
#
#		if Tokens.size() > TokenIndex :
#			nextToken   = Tokens[TokenIndex]
#			TokenIndex += 1
#
#		return nextToken
		
		
# Lexing UNIT END


# Lexing Optimized Pipeline

#class TUnit:
#	var Handle : int
#
#class TUnits :
#	var Sources      : Array
#	var CursorSets   : Array
#	var TokenSets    : Array
#	var TokenIndexes : Array
#
#
#var TextUnits : TUnits
#
#
#func tunit_Tokenize():
#	return

# Lexing Optimized Pipeline END

