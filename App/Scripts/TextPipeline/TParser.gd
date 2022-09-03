# Note: Rename to token parser: TParser
# Parses tokens to generate SNodes
# As opposed to the SEditor which may generate them directly
# (Or may be usd by the SEditor to generate nodes from user text input)

class_name TParser extends Object

#region  Assertion Setup
#var Error = G.Error

func throw(msg : String, shouldAssert := false):
	G.throw(G.Error.new(shouldAssert, msg))

#endregion Assertion Setup


# NOTE:
# The parser  model used here may be able to generate an ast that the interpreter at the 
# "GDScript level" of implementation will not be able to support (Or possibly LLVM for that matter).
# So those nodes will not be supported on the demo langauge platform.
 
const SAttribute = \
{
	fmt_NewLine = "Format: NewLine",
	
	allocator = "Allocator",
	
	builtin = "Builtin",
	literal = "Literal",
	
	exe = "Executable Element",
	
	expression = "Expression",

	operation  = "Operation",
	op_Logical = "Op: Logical",
	op_Unary   = "Op: Unary",
	
	sector = "Sector",
	symbol = "Symbol",
}

const SType = \
{
	fmt_NL = "NewLine",
	
	empty = "Empty Statement",
	unit  = "Module Unit",

	expr_Cap   = "Capture",
	expr_SBCap = "Bracketed Capture",
	
	op_Dependent = "Op: Dependent",
	op_CD        = "Op: Comma Delimiter",
	op_Ptr       = "Op: Address Of (Get Pointer)",
	op_Val       = "Op: Value accessor",
	op_SMA       = "Op: Member Resolution",
	op_AlignOf   = "Op: Alignment of",
	op_OffsetOf  = "Op: Offset of",
	op_PosOf     = "Op: Position of",
	op_SizeOf    = "Op: Size of",
	
	op_Break    = "Op: Break",
	op_Continue = "Op: Continue",
	op_Fall     = "Op: Fall",
	op_GoTo     = "Op: GoTo",
	op_Return   = "Op: Return",
	
	op_Cast    = "Op: Cast",
	op_Typedef = "Op: Typedef",
	
	op_Alloc  = "Op: Allocate",
	op_Resize = "Op: Resize",
	op_Free   = "Op: Free",
	op_Wipe   = "Op: Wipe",
	
	op_LNot = "Op: Logical Not",
	op_LOr  = "Op: Logical Or",
	op_LAnd = "Op: Logical And",
	op_BNot = "Op: Bitwise Not",
	op_BAnd = "Op: Bitwise And",
	op_BOr  = "Op: Bitwise Or",
	op_BXOr = "Op: Bitwise XOr",
	op_BSL  = "Op: Bitshift Left",
	op_BSR  = "Op: Bitshift Right",
	
	op_Assign   = "Op: Assign",
	
	
	op_AB_And     = "Op: Assign Bit And",
	op_AB_Or      = "Op: Assign Bit Or",
	op_AB_XOr     = "Op: Assign Bit XOr",
	op_AB_Not     = "Op: Assign Bit Not",
	op_AB_SL      = "Op: Assign Bit Shift Left",
	op_AB_SR      = "Op: Assign Bit Shift Right",
		
	op_A_Add      = "Op: Assign Add",
	op_A_Subtract = "Op: Assign Subtract",
	op_A_Multiply = "Op: Assign Multiply",
	op_A_Divide   = "Op: Assign Divide",
	op_A_Modulo   = "Op: Assign Modulo",
	
	op_Add      = "Op: Add",
	op_Subtract = "Op: Subtract",
	op_Multiply = "Op: Multiply",
	op_Divide   = "Op: Divide",
	op_Modulo   = "Op: Modulo",
	op_UnaryNeg = "Op: Unary Negation",
	
	op_Equal        = "Op: Equal",
	op_NotEqual     = "Op: NotEqual",
	op_Greater      = "Op: Greater",
	op_Lesser       = "Op: Lesser",
	op_GreaterEqual = "Op: Greater Equal",
	op_LesserEqual  = "Op: Lesser Equal",
	
	literal_True    = "Literal: True",
	literal_False   = "Literal: False",
	literal_Binary  = "Literal: Binary",
	literal_Octal   = "Litearl: Octal",
	literal_Hex     = "Literal: Hex",
	literal_Decimal = "Literal: Decimal",
	literal_Digit   = "Literal: Digit",
	literal_Char    = "Literal: Char",
	literal_String  = "Literal: String",
	
	sec_Alias       = "Sector: Alias",
	sec_Allocator   = "Sector: Allocator",
	sec_Cap         = "Sector: Capture",
	sec_CapArgs     = "Sector: Capture Arguments",
	sec_Cond        = "Sector: Conditional",
	sec_CondBody    = "Sector: Conditional Body",
	sec_Enum        = "Sector: Enum",
	sec_EnumElement = "Sector: Enum Element",
	sec_Exe         = "Sector: Execution",
	sec_External    = "Sector: External",
	sec_Heap        = "Sector: Heap",
	sec_Identifier  = "Sector: Identifier",
	sec_Interface   = "Sector: Interface",
	sec_Inline      = "Sector: Inline",
	sec_Label       = "Sector: Label",
	sec_Layer       = "Sector: Layer",
	sec_Layout      = "Sector: Layout",
	sec_Loop        = "Sector: Loop",
	sec_RO          = "Sector: Readonly",
	sec_RetMap      = "Sector: Return Map",
	sec_Stack       = "Sector: Stack",
	sec_Static      = "Sector: Static",
	sec_Struct      = "Sector: Struct",
	sec_StructUsing = "Sector: Struct Using",
	sec_Switch      = "Sector: Switch",
	sec_SwitchCase  = "Sector: Switch Case",
	sec_Trait       = "Sector: Trait",
	sec_TT          = "Sector: Translation Time",
	sec_Type        = "Sector: Type",
	sec_Union       = "Sector: Union",
	sec_Using       = "Sector: Using",
	sec_Virtual     = "Sector: Virtual",

	builtin_Bool   = "GD: bool",
	builtin_Int    = "GD: int",
	builtin_Float  = "GD: float",
	builtin_Array  = "GD: Array",
	builtin_Dict   = "GD: Dictionary",
	builtin_String = "GD: String",
	
	sym_Allocator  = "Symbol: Allocator",
	sym_Array      = "Symbol: Array",
	sym_Byte       = "Symbol: Byte",
	sym_Bytepad    = "Symobl: Bytepad",
	sym_Infer      = "Symbol: Type Inferred",
	sym_LP         = "Symbol: Language Platform",
	sym_Null       = "Symbol: Null",
	sym_Proc       = "Symbol: Procedure",
	sym_Ptr        = "Symbol: Pointer",
	sym_RO         = "Symbol: Readonly",
	sym_Self       = "Symbol: Self",
	sym_Type       = "Symbol: Type",
	sym_TType      = "Symbol: Top Type",
	sym_TT_Type    = "Symbol: Translation Time Type",
	sym_Word       = "Symbol: Word",

	sym_Identifier = "Symbol: Identifier",
}

const STxt = {
	TType.op_Define: ":",
	TType.sec_Else : "else",

	SType.unit : "unit",

	SType.builtin_Bool   : "bool",
	SType.builtin_Int    : "int",
	SType.builtin_Float  : "float",
	SType.builtin_Array  : "gd_array",
	SType.builtin_Dict   : "gd_dict",
	SType.builtin_String : "gd_string",
		
	SType.literal_True  : "true",
	SType.literal_False : "false",
	
	SType.op_CD       : ",",
	SType.op_Ptr      : "ptr",
	SType.op_Val      : "val",
	SType.op_SMA      : ".",
	SType.op_Break    : "break",
	SType.op_Continue : "continue",
	SType.op_Fall     : "fall",
	SType.op_GoTo     : "goto",
	SType.op_Cast     : "cast",
	SType.op_Return   : "ret",
	
	SType.op_SizeOf   : "sizeof",
	SType.op_PosOf    : "posof",
	SType.op_OffsetOf : "offsetof",
	SType.op_AlignOf  : "alignof",
	
	SType.op_Alloc  : "allocate",
	SType.op_Resize : "resize",
	SType.op_Free   : "free",
	SType.op_Wipe   : "wipe",
	
	SType.op_BNot : "~",
	SType.op_BAnd : "&",
	SType.op_BOr  : "|",
	SType.op_BXOr : "^",
	SType.op_BSL  : "<<",
	SType.op_BSR  : ">>",
	
	SType.op_LNot : "!",
	SType.op_LOr  : "||",
	SType.op_LAnd : "&&",

	SType.op_Equal        : "=",
	SType.op_NotEqual     : "!=",
	SType.op_Lesser       : "<",
	SType.op_LesserEqual  : "<=",
	SType.op_Greater      : ">",
	SType.op_GreaterEqual : ">=",

	SType.op_Assign  : "=",
	
	SType.op_AB_Not : "~=",
	SType.op_AB_And : "&=",
	SType.op_AB_Or  : "|=",
	SType.op_AB_XOr : "^=",
	SType.op_AB_SL  : "<<=",
	SType.op_AB_SR  : ">>=",
	
	SType.op_A_Add      : "+=",
	SType.op_A_Subtract : "-=",
	SType.op_A_Multiply : "*=",
	SType.op_A_Divide   : "/=",
	SType.op_A_Modulo   : "%=",
	
	SType.op_Add      : "+",
	SType.op_Subtract : "-",
	SType.op_Multiply : "*",
	SType.op_Divide   : "/",
	SType.op_Modulo   : "%",
	SType.op_UnaryNeg : "-",
		
	SType.sec_Alias       : "alias",
	SType.sec_Allocator   : "allocator",
	SType.sec_Cond        : "if",
	SType.sec_Enum        : "enum",
	SType.sec_Exe         : "exe",
	SType.sec_External    : "external",
	SType.sec_Heap        : "heap",
	SType.sec_Label       : "label",
	SType.sec_Layer       : "layer",
	SType.sec_Layout      : "layout",
	SType.sec_Loop        : "loop",
	SType.sec_RO          : "ro",
	SType.sec_RetMap      : "->",
	SType.sec_Stack       : "stack",
	SType.sec_Static      : "static",
	SType.sec_Struct      : "struct",
	SType.sec_StructUsing : "using",
	SType.sec_Switch      : "switch",
	SType.sec_Trait       : "trait",
	SType.sec_TT          : "tt",
	SType.sec_Type        : "type",
	SType.sec_Union       : "union",
	SType.sec_Using       : "using",
	SType.sec_Virtual     : "virtual",
	
	SType.sym_Allocator : "allocator",
	SType.sym_Array     : "array",
	SType.sym_Byte      : "byte",
	SType.sym_Infer     : ":=",
	SType.sym_LP        : "LP",
	SType.sym_Null      : "null",
	SType.sym_Proc      : "exe",
	SType.sym_Ptr       : "ptr",
	SType.sym_Self      : "self",
	SType.sym_TT_Type   : "tt",
	SType.sym_TType     : "type",
	SType.sym_Type      : "type",
	SType.sym_Word      : "word",
}

const Sector_Precedence = [
	# Unit Sector Level
	# Alias, Cap, Cond, Exe, External, Identifier, Inline, Layer, Readonly, Static, Switch, TT
	SType.sec_Cap,
	SType.sec_Cond,
	SType.sec_Layer,
	SType.sec_Switch,
	
	# Alias, Cap, Cond, Enum, Exe, External, Identifier, Inline, Interface, Layer, Layout, RO, 
	# RetMap, Static, Struct, Switch, Trait, TT, Typedef, Union, Virtual
	SType.sec_Identifier,
	
	# Alias, Cap, Cond, Exe, Identifier, Interface, Layer, Static, Switch
	SType.sec_TT,

	# Cap, Cond, Exe, Identifier, Switch, Allocator Impl Sectors
	SType.sec_Interface,
	SType.sec_Trait,
	SType.sec_Virtual,

	# Cap, Cond, Identifier, Static, Switch
	SType.sec_RO,
	
	# Cap, Cond, Identifier, Switch
	SType.sec_External,
	SType.sec_Inline,
	
	# Execution Block completely changes availability.
	SType.sec_Exe,
	
	# Do not have available sectors
	SType.sec_Alias,
	SType.sec_Enum,
	SType.sec_Heap,
	SType.sec_Layout,
	SType.sec_Stack,
	SType.sec_Static,
	SType.sec_Struct,
	SType.sec_StructUsing,
	SType.sec_Using,
	SType.sec_Type
]

var AS_Unit = {
	TType.sec_Alias      : parse_sec_Alias,
	TType.cap_PStart     : parse_sec_Capture,
	TType.sec_If         : parse_sec_Cond,
	TType.sym_Exe        : parse_sec_Exe,
	TType.sec_External   : parse_sec_External,
	TType.sym_Identifier : parse_sec_Identifier,
	TType.sec_Inline     : parse_sec_Inline,
	TType.sec_Interface  : parse_sec_Interface,
	TType.sec_Layer      : parse_sec_Layer,
	TType.sym_RO         : parse_sec_Readonly,
	TType.sec_Static     : parse_sec_Static,
	TType.sec_Switch     : parse_sec_Switch,
	TType.sym_TT         : parse_sec_TranslationTime,
}

var AS_Identifier = {
	TType.sec_Alias      : parse_sec_Alias,
	TType.cap_PStart     : parse_sec_Capture,
	TType.sec_If         : parse_sec_Cond,
	TType.sym_Enum       : parse_sec_Enum,
	TType.sym_Exe        : parse_sec_Exe,
	TType.sec_External   : parse_sec_External,
	TType.sym_Identifier : parse_sec_Identifier,
	TType.sec_Inline     : parse_sec_Inline,
	TType.sec_Interface  : parse_sec_Interface,
	TType.sec_Layer      : parse_sec_Layer,
	TType.sec_Layout     : parse_sec_Layout,
	TType.sym_RO         : parse_sec_Readonly,
	TType.sec_Static     : parse_sec_Static,
	TType.sec_Struct     : parse_sec_Struct,
	TType.sec_Switch     : parse_sec_Switch,
	TType.sec_Trait      : parse_sec_Trait,
	TType.sym_TT         : parse_sec_TranslationTime,
	TType.sym_Type       : parse_sec_Type,
	TType.sec_Union      : parse_sec_Union,
	TType.sec_Virtual    : parse_sec_Virtual,
}

var AS_TranslationTime = {
	TType.sec_Alias      : parse_sec_Alias,
	TType.cap_PStart     : parse_sec_Capture,
	TType.sec_If         : parse_sec_Cond,
	TType.sym_Exe        : parse_sec_Exe,
	TType.sym_Identifier : parse_sec_Identifier,
	TType.sec_Interface  : parse_sec_Interface,
	TType.sec_Layer      : parse_sec_Layer,
	TType.sec_Static     : parse_sec_Static,
	TType.sec_Switch     : parse_sec_Switch,
}

var AS_TT_Identifier = {
	TType.sec_Alias      : parse_sec_Alias,
	TType.cap_PStart     : parse_sec_Capture,
	TType.sec_If         : parse_sec_Cond,
	TType.sym_Enum       : parse_sec_Enum,
	TType.sym_Exe        : parse_sec_Exe,
	TType.sym_Identifier : parse_sec_Identifier,
	TType.sec_Interface  : parse_sec_Interface,
	TType.sec_Layer      : parse_sec_Layer,
	TType.sec_Layout     : parse_sec_Layout,
	TType.sec_Static     : parse_sec_Static,
	TType.sec_Struct     : parse_sec_Struct,
	TType.sec_Switch     : parse_sec_Switch,
	TType.sym_TT         : parse_sec_TranslationTime,
	TType.sym_Type       : parse_sec_Type,
	TType.sec_Union      : parse_sec_Union,
	TType.sec_Virtual    : parse_sec_Virtual,
}

var AS_Readonly = {
	TType.cap_PStart     : parse_sec_Capture,
	TType.sec_If         : parse_sec_Cond,
	TType.sym_Identifier : parse_sec_Identifier,
	TType.sec_Static     : parse_sec_Static,
	TType.sec_Switch     : parse_sec_Switch,
}

var AS_Interface = {
	TType.op_Alloc  : parse_sec_Alloc,
	TType.op_Resize : parse_sec_Resize,
	TType.op_Free   : parse_sec_Free,
	TType.op_Wipe   : parse_sec_Wipe,
	
	TType.cap_PStart     : parse_sec_Capture,
	TType.sec_If         : parse_sec_Cond,
	TType.sym_Exe        : parse_sec_Exe,
	TType.sym_Identifier : parse_sec_Identifier,
	TType.sec_Switch     : parse_sec_Switch,
}

# Run-time Director
var AS_RTD = {
	TType.cap_PStart     : parse_sec_Capture,
	TType.sec_If         : parse_sec_Cond,
	TType.sym_Exe        : parse_sec_Exe,
	TType.sym_Identifier : parse_sec_Identifier,
	TType.sec_Switch     : parse_sec_Switch,
}

class Range2i:
	var Start : Vector2i
	var End   : Vector2i
	
	func _init(start = null, end = null):
		Start = Vector2i() if start == null else start
		End   = Vector2i() if end   == null else end

# Going to rename to SNode or SyntaxNode, this is the nodes generated and managed by the frontend
class SNode extends RefCounted :
	var Type         :  String
	var Attributes   :  Dictionary
	var Span         := Range2i.new()
	var Context      : Array
	var Data         : Array

#region Methods
	func name() -> String:
		return STxt[Type]
		
	func parent():
		return Context.back()

	func add_Entry( _entry ) -> void:
#		if typeof(_entry) == TYPE_OBJECT:
#			_entry.set_Context(self)
		
		Data.append( _entry )
		
	func insert_Entry( index, _entry ) -> void:
#		if typeof(_entry) == TYPE_OBJECT:
#			_entry.set_Context(self)
		
		Data.insert(index, _entry )
		
	func set_Entry( index, _entry ) -> void:
#		if typeof(_entry) == TYPE_OBJECT:
#			_entry.set_Context(self)
		
		Data[index] = _entry

	func add_TokVal( token ) -> void:
		Data.append( token.Value )

	func entry( id : int):
		return  Data[id - 1]
		
	func num_Entries() -> int:
		return Data.size()
		
	func string() -> String:
		return entry(1).substr(1, entry(1).length() - 2)
		
	func has_Attribute(attribute):
		return Attributes.has(attribute)

	func set_Type( type ) -> void:
		if G.check( SType.values().find(type) != null, "Attempted to set a type thats not in SType."):
			return
			
		Type = type
#endregion Methods

#region Serialization
	func array_Serialize(array) -> Array:
		var result = [ Type ]

		for _entry in array :
			if typeof(_entry) == TYPE_ARRAY :
				result.append( array_Serialize( _entry ) )

			elif typeof(_entry) == TYPE_OBJECT :
				if _entry.get_class() ==  "Eve":
					result.append(_entry)
				else:
					result.append( _entry.to_SExpression() )

			else :
				result.append( _entry )
				
		return result

	func to_SExpression() -> Array:
		return array_Serialize( self.Data )
#endregion Serialization
	
#region Object
	func typename():
		return "SNode"

	func _init(type =  ""):
		if type != "":
			set_Type(type)
#endregion Object

class Sec_Alias extends SNode:
	func name():
		return Data[0]
		
	func arg():
		return Data[1]
	
	func _init():
		set_Type(SType.sec_Alias)
		Attributes[SAttribute.sector] = true

class Sec_Allocator extends SNode:
	func name(): 
		return Data[0]

	func entry( id : int ):
		return Data[ id ]

	func num_Entries() -> int:
		return Data.size() - 1
		
	func _init():
		set_Type( SType.sec_Allocator )
		Attributes[SAttribute.sector] = true
		Attributes[SAttribute.allocator] = true

class Sec_AllocatorOp extends SNode:
	func identifier():
		return Data[0]
		
	func custom():
		return Data[1]
		
	func capture():
		return Data[2]
		
	func _init(SType =  ""):
		if SType != "":
			set_Type(SType)
		Attributes[SAttribute.exe] = true
		Data.append(null) # identiifer
		Data.append(null) # custom
		Data.append(null) # capture

class Sec_AllocatorImpl extends SNode:
	func _init(type):
		set_Type(type)
		Attributes[SAttribute.sector] = true

class Sec_Capture extends SNode:
	func args():
		return Data[0]

	func ret_Map():
		return Data[1]
		
	func entry( id : int ):
		return Data[ id + 1 ]
		
	func num_Entries() -> int:
		return Data.size() - 2
		
	func _init():
		set_Type( SType.sec_Cap )
		Attributes[SAttribute.sector] = true
		Data.append(null) # Capture Args
		Data.append(null) # Return Map

class Sec_CaptureArgs extends SNode:
	func contains_self() -> bool:
		for _entry in Data:
			if _entry.Type == SType.sym_Self:
				return true
				
		return false

	func _init():
		set_Type( SType.sec_CapArgs )
		Attributes[SAttribute.sector] = true

class Sec_Cond extends SNode:
	func cond():
		return Data[0]
		
	func body():
		return Data[1]
		
	func alt():
		return Data[2]
		
	func _init():
		set_Type( SType.sec_Cond )
		Attributes[SAttribute.sector] = true
		Data.append(null)
		Data.append(null)
		Data.append(null)

class Sec_CondBody extends SNode: 
	func _init():
		set_Type( SType.sec_CondBody )
		Attributes[SAttribute.sector] = true

class Sec_Enum extends SNode:
	func capture():
		return Data[0]
		
	func entry( id ):
		return Data[ id ]
		
	func num_Entries():
		return Data.size() - 1
		
	func _init():
		set_Type( SType.sec_Enum )
		Attributes[SAttribute.sector] = true
		Data.append(null) # Capture Slot

class Sec_EnumElement extends SNode:
	func name():
		return Data[0]
		
	func assignment():
		return Data[1]
	
	func _init():
		set_Type(SType.sec_EnumElement)
		Attributes[SAttribute.sector] = true
		Data.append(null) # Name
		Data.append(null) # Assignment

class Sec_Exe extends SNode:
	func _init():
		set_Type(SType.sec_Exe)
		Attributes[SAttribute.sector] = true

class Sec_External extends SNode:
	func _init():
		set_Type(SType.sec_External)
		Attributes[SAttribute.sector] = true

class Sec_Heap extends SNode:
	func _init():
		set_Type( SType.sec_Heap )
		Attributes[SAttribute.sector] = true
		Attributes[SAttribute.allocator] = true

class Sec_Identifier extends SNode:
	func name() -> String:
		return Data[0]
		
	func ret_Map():
		return Data[1]
	
	func entry( id : int ):
		return Data [ id + 1 ]
		
	func num_Entries() -> int:
		return Data.size() - 2

	func _init():
		set_Type( SType.sec_Identifier )
		Attributes[SAttribute.sector] = true
		Data.append(null) # Name
		Data.append(null) # Optional Return Map

class Sec_Inline extends SNode:
	func _init():
		set_Type(SType.sec_Inline)
		Attributes[SAttribute.sector] = true

class Sec_Interface extends SNode:
	func identifier():
		return Data[0]
	
	func _init():
		set_Type(SType.sec_Interface)
		Attributes[SAttribute.sector] = true

class Sec_Label extends SNode:
	func _init():
		set_Type(SType.sec_Label)
		Attributes[SAttribute.sector] = true

class Sec_Layer extends SNode:
	func _init():
		set_Type(SNode.sec_Layer)
		Attributes[SAttribute.sector] = true

class Sec_Layout extends SNode:
	func _init():
		set_Type(SType.sec_Layout)
		Attributes[SAttribute.sector] = true

class Sec_Loop extends SNode:
	func cond():
		return Data[0]
		
	func entry( id ):
		return Data[ id ]
		
	func num_Entries():
		return Data.size() - 1
	
	func _init():
		set_Type(SType.sec_Loop)
		Attributes[SAttribute.sector] = true
		Attributes[SAttribute.exe] = true
		Data.append(null) # Capture Slot

class Sec_ReadOnly extends SNode:
	func _init():
		set_Type(SType.sec_RO)
		Attributes[SAttribute.sector] = true

class Sec_ReturnMap extends SNode:
	func expression():
		return Data[0]

	func _init():
		set_Type( SType.sec_RetMap )
		Attributes[SAttribute.sector] = true

class Sec_Stack extends SNode:
	func _init():
		set_Type(SType.sec_Static)
		Attributes[SAttribute.sector] = true
		Attributes[SAttribute.exe] = true
		
class Sec_Static extends SNode:
	func _init():
		set_Type(SType.sec_Static)
		Attributes[SAttribute.sector] = true
		Attributes[SAttribute.exe] = true

class Sec_Struct extends SNode:
	func _init():
		set_Type(SType.sec_Struct)
		Attributes[SAttribute.sector] = true

class Sec_StructUsing extends SNode:
	func value():
		return Data[0]
	
	func _init():
		set_Type(SType.sec_StructUsing)
		Attributes[SAttribute.sector] = true
		
class Sec_Switch extends SNode:
	func cond():
		return Data[0]
		
	func entry( id ):
		return Data[id]
		
	func num_Entries():
		return Data.size() - 1
	
	func _init():
		set_Type(SType.sec_Switch)
		Attributes[SAttribute.sector] = true

class Sec_SwitchCase extends SNode:
	func case():
		return Data[0]
		
	func entry( id ):
		return Data[id]
		
	func num_Entries():
		return Data.size() - 1
	
	func _init():
		set_Type(SType.sec_SwitchCase)
		Attributes[SAttribute.sector] = true
		Data.append(null)

class Sec_Trait extends SNode:
	func _init():
		set_Type(SType.sec_Trait)
		Attributes[SAttribute.sector] = true

class Sec_TranslationTime extends SNode:
	func _init():
		set_Type(SType.sec_TT)
		Attributes[SAttribute.sector] = true

class Sec_Type extends SNode:
	func typedef():
		return Data[0]
	
	func assignment():
		return Data[1]
	
	func _init():
		set_Type( SType.sec_Type )
		Attributes[SAttribute.sector] = true
		Data.append(null) # typedef
		Data.append(null) # assignment

class Sec_Union extends SNode:
	func _init():
		set_Type( SType.sec_Union )
		Attributes[SAttribute.sector] = true

class Sec_Using extends SNode:
	func name():
		return Data[0]
	
	func _init():
		set_Type(SType.sec_Using)
		Attributes[SAttribute.sector] = true
		Data.append(null) # Name

class Sec_Virtual extends SNode:
	func _init():
		set_Type(SType.sec_Virtual)
		Attributes[SAttribute.sector] = true

class Expr_SMA extends SNode:
	func name():
		return Data[0]
	
	func member():
		return Data[1]
	
	func _init():
		set_Type(SType.op_SMA)
		Attributes[SAttribute.expression] = true
		Data.append(null) # Name
		Data.append(null) # Member

class Expr_Binary extends SNode:
	func left():
		return Data[0]
		
	func right():
		return Data[1]
	
	func _init( type = "" ):
		if type != "":
			set_Type(type)
		Attributes[SAttribute.expression] = true
		Attributes[SAttribute.operation] = true

class Expr_SBCap extends SNode:
	func left():
		return Data[0]
		
	func arg():
		return Data[1]

	func sma():
		return Data[2]
	
	func _init():
		set_Type(SType.expr_SBCap)
		Attributes[SAttribute.expression] = true
		Attributes[SAttribute.operation] = true
		Data.append(null) # left
		Data.append(null) # right
		Data.append(null) # sma

class Expr_Cast extends SNode:
	func arg_Type():
		# Data[0] : Capture, args().entry(1) should be a symbol that resolves to a type
		return Data[0].args().entry(1)
		
	func arg_Identifier():
		# Data[0] : Capture, args().entry(2) should be a symbol that resolves to an identifier
		return Data[0].args().entry(2) 
	
	func _init():
		set_Type(SType.op_Cast)
		Attributes[SAttribute.expression] = true
		Attributes[SAttribute.operation] = true

class Expr_Dependent extends SNode:
	func name():
		return Data[0]
		
	func args():
		return Data[1]
	
	func _init():
		set_Type(SType.op_Dependent)
		Attributes[SAttribute.expression] = true
		Attributes[SAttribute.operation] = true

class Expr_Unary extends SNode:
	func operand():
		return Data[0]
	
	func _init( type = "" ):
		if type != "":
			set_Type(type)
		Attributes[SAttribute.expression] = true
		Attributes[SAttribute.operation] = true

class Sym_Array extends SNode:
	func amount():
		return Data[0]
		
	func assoc_type():
		return Data[1]
	
	func _init():
		set_Type(SType.sym_Array)
		Attributes[SAttribute.symbol] = true
	
class Sym_Bytepad extends SNode:
	func _init():
		set_Type(SType.sym_Bytepad)
		Attributes[SAttribute.symbol] = true
	
class Sym_Identifier extends SNode:
	func name() -> String:
		return Data[0]
		
	func has_Typedef() -> bool:
		return Data.size() > 1 && Data[1].Type == SType.sec_Type
	
	func typedef() -> SNode:
		return Data[1]

	func _init():
		set_Type( SType.sym_Identifier )
		Attributes[SAttribute.symbol] = true
	
class Sym_Literal extends SNode:
	func value():
		return Data[0]
	
	func _init(type):
		if type != "":
			set_Type(type)
		Attributes[SAttribute.symbol] = true
		Attributes[SAttribute.literal] = true
	
class Sym_Proc extends SNode:
	func capture():
		return Data[0]
		
	func ret_Map():
		return Data[1]
	
	func _init():
		set_Type(SType.sym_Proc)
		Data.append(null)
		Data.append(null)
		Attributes[SAttribute.symbol] = true

class Sym_Ptr extends SNode:
	func typedef():
		return Data[0]
	
	func _init():
		set_Type(SType.sym_Ptr)
		Attributes[SAttribute.symbol] = true

class Sym_RO extends SNode:
	func _init():
		set_Type(SType.sym_RO)
		Attributes[SAttribute.symbol] = true
		
class Sym_Self extends SNode:
	func typedef():
		return Data[0]
		
	func _init():
		set_Type(SType.sym_Self)
		Attributes[SAttribute.symbol] = true
		Data.append(null) # Typedef

class Sym_Type extends SNode:
	func value():
		return Data[0]
	
	func _init():
		set_Type(SType.sym_Type)
		Attributes[SAttribute.symbol] = true

class Sym_Infer extends SNode:
	func builtin():
		return Data[0]
	
	func _init():
		set_Type(SType.sym_Infer)
		Attributes[SAttribute.symbol] = true
		Data.append(null)

class Sym_TT_Type extends SNode:
	func _init():
		set_Type(SType.sym_TT_Type)
		Attributes[SAttribute.symbol] = true

class Op_Break extends SNode:
	func _init():
		set_Type(SType.op_Break)
		Attributes[SAttribute.operation] = true

class Op_Continue extends SNode:
	func _init():
		set_Type(SType.op_Continue)
		Attributes[SAttribute.operation] = true
		
class Op_Fall extends SNode:
	func _init():
		set_Type(SType.op_Fall)
		Attributes[SAttribute.operation] = true

class Op_GoTo extends SNode:
	func _init():
		set_Type(SType.op_GoTo)
		Attributes[SAttribute.operation] = true

class Op_Return extends SNode:
	func expression():
		return Data[0]
	
	func _init():
		set_Type(SType.op_Return)
		Attributes[SAttribute.operation] = true
		Data.append(null) # Optional Expression

const TType     = Lexer.TType
const TCatVal   = Lexer.TCatVal
const TCategory = Lexer.TCategory
var   Lex   : Lexer
var   Tok
var   LastNode
var   Context := []

func chk_Tok( tokeSType ):
	if G.check(Tok != null, "Tok is null!"):
		return null
		
	return Tok.Type == tokeSType

# Gets the next token only if the current token is the specified intended token (tokeSType)
func eat( tokeSType ) -> bool:
	var currToken = Tok
	
	if G.check(currToken != null, "Tok was null!"):
		return true
	
	var assertStrTmplt = "Unexpected token:   {value} \nExpected:   {type} \nSpan: {start} {end}"
	var assertStr      = assertStrTmplt.format({"value" : currToken.Value, "type" : tokeSType, "start" : currToken.Start, "end" : currToken.End})
		
	if G.check(currToken.Type == tokeSType, assertStr):
		Tok = null
		return true

	Tok = Lex.next_Token()
	
	if Tok == null:
		return false
	
	var matched = false
	match Tok.Type:
		TType.fmt_NL:
#			if LastNode:
#				LastNode.Attributes[SAttribute.fmt_NewLine] = true
			matched = true

#		TType.cmt_SL:
#			LastNode.add_Comment( parse_Comment() )
#			matched = true

#		TType.cmt_ML:
#			LastNode.add_Comment( parse_Comment() 
#			matched = true

	while matched && Tok && Tok.Type == TType.fmt_NL:
		Tok = Lex.next_Token()

	return false

func get_SectorParser(ast) -> Dictionary:
	var precedentNode = [ 0, null ]
	
	for node in ast.Context:
		if ! Sector_Precedence.find(node.Type):
			continue

		var value = Sector_Precedence.find(node.Type)
		if precedentNode[0] <= value:
			precedentNode[0] = value
			precedentNode[1] = node
	
	var value = Sector_Precedence.find(ast.Type)
	if precedentNode[0] <= value:
		precedentNode[0] = value
		precedentNode[1] = ast
		
	if precedentNode[1].Type == SType.sec_TT \
	&& ast.Type              == SType.sec_Identifier:
		return AS_TT_Identifier
			
	if precedentNode == null:
		return Dictionary()

	match precedentNode[1].Type:
		SType.sec_Cap       : return AS_Unit
		SType.sec_Cond      : return AS_Unit
		SType.sec_CondBody  : return AS_Unit
		SType.sec_Layer     : return AS_Unit
		SType.sec_Switch    : return AS_Unit
		
		SType.sec_Identifier : return AS_Identifier
		
		SType.sec_TT : return AS_TranslationTime

		SType.sec_Interface : return AS_Interface
		SType.sec_Trait     : return AS_Interface
		SType.sec_Virtual   : return AS_Interface
		SType.op_Alloc      : return AS_Interface
		SType.op_Resize     : return AS_Interface
		SType.op_Free       : return AS_Interface
		SType.op_Wipe       : return AS_Interface
				
		SType.sec_RO : return AS_Readonly
		
		SType.sec_External : return AS_RTD
		SType.sec_Inline   : return AS_RTD
		
		SType.sec_Exe         : pass
		SType.sec_Alias       : pass 
		SType.sec_Enum        : pass
		SType.sec_Heap        : pass
		SType.sec_Layout      : pass
		SType.sec_Stack       : pass
		SType.sec_Static      : pass
		SType.sec_Struct      : pass
		SType.sec_StructUsing : pass
		SType.sec_Using       : pass
		SType.sec_Type        : pass
		
	return Dictionary()

func push_Context(node) -> void:
	Context.push_front(node)
	
func pop_Context() -> void:
	Context.pop_front()

func start_span(node) -> void:
	node.Span.Start = Tok.Start
	
func end_span(node) -> void:
	node.Span.End = Lex.last_Token().End
	
func start(node) -> void:
	node.Context = Context.duplicate()
	start_span(node)
	push_Context(node)
	
func end(node) -> void:
	LastNode = node
	end_span(node)
	pop_Context()

func parse_unit() -> SNode:
	var node = SNode.new(SType.unit)
	
	Tok = Lex.next_Token()
	if Tok == null:
		return node

	start(node)
	
	while Tok != null :
		var matched = false
		
		match Tok.Type:
			TType.sec_Alias:
				node.add_Entry( parse_sec_Alias() )
			
			TType.cap_PStart:
				node.add_Entry( parse_sec_Capture() )
				matched = true
			
			TType.sec_If:
				node.add_Entry( parse_sec_Cond() )
				matched = true
				
			TType.sym_Exe:
				node.add_Entry( parse_sec_Exe() )
				matched = true
				
			TType.sec_External:
				node.add_Entry( parse_sec_External() )
				matched = true
							
			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )
				matched = true
				
			TType.sec_Interface:
				node.add_Entry( parse_sec_Interface() )
				matched = true
				
			TType.sec_Layer:
				node.add_Entry( parse_sec_Layer() )
				
			TType.sym_RO:
				node.add_Entry( parse_sec_Readonly() )
				matched = true
				
			TType.sec_Static:
				node.add_Entry( parse_sec_Static() )
				matched = true
				
			TType.sec_Switch:
				node.add_Entry( parse_sec_Switch() )
				matched = true
								
			TType.sym_TT:
				node.add_Entry( parse_sec_TranslationTime() )
				matched = true
				
			TType.def_End:
				eat(TType.def_End)
				matched = true

		if !matched:
			throw("Failed to match token: {tok}".format( { "tok" : Tok.to_Str() } ))
			end_span(node)
			return node
			
	end(node)
	return node

#region Sectors

func parse_Sector(node) -> SNode:
	return null
	
func parse_SectorBody(node) -> bool:
	var availableSectors := get_SectorParser(node)
	if ! availableSectors.has(Tok.Type):
			throw("Attempted to parse sector body but sector has no available sectors: {sector}".format( { "sector" : node.Type } ))
			return false
			
	var sectorParser = availableSectors[Tok.Type]
	
	if node.Type == SType.sec_Identifier && Tok.Type == TType.sym_Type:
		node.add_Entry( parse_sec_Type(TType.sym_Type) )
		return true
	
	node.add_Entry( sectorParser.call() )
	return true
	
func parse_sec_Alias() -> SNode:
	var node = Sec_Alias.new()
	start(node)
	eat(TType.sec_Alias)
		
	var result = chk_Tok( TType.def_Start )
	if  result == null:
		end_span(node)
		return node
	
	if result: 
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			node.add_Entry( parse_sym_Identifier() )
	
			if eat(TType.op_Define):
				throw("Expecting op_Define: {tok}".format({ "tok" : Tok.to_str() }))
				end_span(node)
				return node
		
			node.add_Entry( parse_expr_Dependent() )
	else:
		node.add_Entry( parse_sym_Identifier() )
	
		if eat(TType.op_Define):
			throw("Expecting op_Define: {tok}".format({ "tok" : Tok.to_str() }))
			end_span(node) 
			return node
		
		node.add_Entry( parse_expr_Dependent() )
	
	end(node)
	return node
	
func parse_sec_Allocator() -> SNode:
	var node = Sec_Allocator.new()
	start(node)
	eat(TType.sym_Allocator)
	
	node.add_Entry( parse_expr_Dependent() )
	
	var result = chk_Tok( TType.def_Start )
	if result == null:
		end(node)
		return node
	
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var identifier 

			if Tok.Type == TType.sym_Identifier:
				identifier = parse_expr_Dependent()
				
				if eat(TType.op_Define):
					throw("Expecting op_Define {tok}".format({ "tok" : Tok.to_str() }))
					end(node)
					return node

			var op = parse_sec_AllocatorOp(node, identifier)
			node.add_Entry(op)
		
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return
		
	else:
		var identifier

		if Tok.Type == TType.sym_Identifier:
			identifier = parse_expr_Dependent()
			
			if eat(TType.op_Define):
				throw("Expecting op_Define {tok}".format({ "tok" : Tok.to_str() }))
				end(node)
				return node
		
		var op = parse_sec_AllocatorOp(node, identifier)
		node.add_Entry(op)
	
	end(node)
	return node
	
func parse_sec_AllocatorOp(node, identifier) -> SNode:
	var opNode = Sec_AllocatorOp.new()
	start(opNode)
	
	match Tok.Type:
		TType.op_Alloc:
			opNode.set_Type(SType.op_Alloc)
			opNode.set_Entry(0, identifier )
			eat(TType.op_Alloc)
			
			if Tok.Type == TType.cap_PStart:
				opNode.set_Entry(2, parse_expr_Capture() )
			
		TType.op_Resize:
			opNode.set_Type(SType.op_Resize)
			opNode.set_Entry(0, identifier )
			eat(TType.op_Resize)
			
			if Tok.Type == TType.cap_PStart:
				opNode.set_Entry(2, parse_expr_Capture() )
				
		TType.op_Free: 
			opNode.set_Type(SType.op_Free)
			opNode.set_Entry(0, identifier )
			eat(TType.op_Free)
			
			if Tok.Type == TType.cap_PStart:
				opNode.set_Entry(2, parse_expr_Capture() )
			
		TType.op_Wipe: 
			opNode.set_Type(SType.op_Wipe)
			eat(TType.op_Wipe)
			
			if Tok.Type == TType.cap_PStart:
				opNode.set_Entry(2, parse_expr_Capture() )
		
		TType.sym_Identifier:
			opNode.set_Type(SType.sym_Identifier)
			opNode.set_Entry(0, identifier )
			opNode.set_Entry(1, parse_sym_Identifier() )
			
			if Tok.Type == TType.cap_PStart:
				opNode.set_Entry(2, parse_expr_Capture() )
		_:
			throw("Expecting Allocator op or Custom op {tok}".format( { "tok" : Tok.to_str() } ))

	end(opNode)
	return opNode

#region Allocator Interface
func parse_sec_Alloc() -> SNode:
	var node = Sec_AllocatorImpl.new(SType.op_Alloc)
	start(node)
	eat(TType.op_Alloc)
	
	parse_SectorBody(node)
	
	end(node)
	return node
	
func parse_sec_Resize() -> SNode:
	var node = Sec_AllocatorImpl.new(SType.op_Resize)
	start(node)
	eat(TType.op_Resize)
	
	parse_SectorBody(node)
	
	end(node)
	return node
	
func parse_sec_Free() -> SNode:
	var node = Sec_AllocatorImpl.new(SType.op_Free)
	start(node)
	eat(TType.op_Free)
	
	parse_SectorBody(node)
	
	end(node)
	return node
	
func parse_sec_Wipe() -> SNode:
	var node = Sec_AllocatorImpl.new(SType.op_Wipe)
	start(node)
	eat(TType.op_Wipe)
	
	parse_SectorBody(node)
	
	end(node)
	return node
#endregion Allocator Interface

func parse_sec_Capture() -> SNode:
	var node = Sec_Capture.new()
	start(node)
	node.set_Entry(0, parse_sec_CaptureArgs() )
	
	if Tok == null:
		end(node)
		return node
	
	if Tok.Type == TType.op_Map:
		node.set_Entry(1, parse_sec_ReturnMap() )
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		end(node)
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			if 	! parse_SectorBody(node):
				end(node)
				return node

		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return
		
	else:
		parse_SectorBody(node)

	end(node)
	return node
	
func parse_sec_CaptureArgs() -> SNode:
	var node = Sec_CaptureArgs.new()
	start(node)
	
	eat(TType.cap_PStart)
	
	while ! chk_Tok(TType.cap_PEnd):
		match Tok.Type:	
			TType.sym_Self:
				node.add_Entry( parse_sym_Self() )
				
			TType.sym_Identifier:
				var symbols = []
				while Tok.Type == TType.sym_Identifier:
					symbols.append( parse_sym_Identifier() )
					
					if Tok.Type == TType.op_CD:
						eat(TType.op_CD)
						continue
				
				var type = parse_sec_Type(TType.op_Define)
						
				for symbol in symbols:
					symbol.add_Entry( type )
					node.add_Entry( symbol )
					
			_:
				throw("Invalid argument element: {tok}".format( { "tok" : Tok.to_str() } ))
				end(node)
				return node

		match chk_Tok(TType.op_CD):
			true: eat(TType.op_CD)
			null: end(node); return node
	
	eat(TType.cap_PEnd)
	end(node)
	return node

func parse_sec_Cond() -> SNode:
	var node = Sec_Cond.new()
	start(node)
	eat(TType.sec_If)
	
	node.set_Entry(0, parse_Expression() )
	node.set_Entry(1, parse_sec_CondBody() )
	
	if Tok && Tok.Type == TType.sec_Else:
		eat(TType.sec_Else)
		node.set_Entry(2, parse_sec_CondBody() )
		
	end(node)
	return node

func parse_sec_CondBody() -> SNode:
	var node = Sec_CondBody.new()
	start(node)
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		return null
	
	if result:
		eat(TType.def_Start)
			
		while Tok.Type != TType.def_End:
			if ! parse_SectorBody(node):
				end(node)
				return node
		
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return
		
	else:
		parse_SectorBody(node)

	end(node)
	return node
	
func parse_sec_Enum() -> SNode:
	var node = Sec_Enum.new(); 
	start(node)
	eat(TType.sym_Enum)
	
	if Tok.Type == TType.cap_PStart:
		node.set_Entry(0, parse_expr_Capture() )
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		end(node)
		return node
		
	if result:
		eat(TType.def_Start)
		
		while  Tok.Type != TType.def_End:
			if Tok.Type == TType.sym_Identifier:
				node.add_Entry( parse_sec_EnumElement() )
			else:
				throw("Failed to match token: {tok}".format( { "tok" : Tok.to_Str() } ))
				end(node)
				return node
				
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return
		
	else:
		if Tok.Type == TType.sym_Identifier:
			node.add_Entry( parse_sec_EnumElement() )
	
	end(node)
	return node
	
func parse_sec_EnumElement() -> SNode:
	var node = Sec_EnumElement.new()
	start(node)
	node.set_Entry(0, parse_sym_Identifier() )
	
	if Tok.Type == TType.op_Assign:
		eat(TType.op_Assign)
		node.set_Entry(1, parse_Expression() )
		
	end(node)
	return node

func parse_sec_Exe() -> SNode:
	var node = Sec_Exe.new()
	start(node)
	eat(TType.sym_Exe)
	
	if Tok.Type == TType.def_End:
		eat(TType.def_End)
		end(node)
		return node
	
	parse_sec_ExeBody(node)
	
	end(node)
	return node
		
func parse_sec_ExeBody(node) -> bool:
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		return false
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var matched = false
			match Tok.Type:
				TType.sym_Allocator:
					node.add_Entry( parse_sec_Allocator() )
					matched = true
				
				TType.op_Break:
					node.add_Entry( parse_op_Break() )
					matched = true
				
				TType.op_Continue:
					node.add_Entry( parse_op_Continue() )
					matched = true
									
				TType.sec_If:
					node.add_Entry( parse_sec_ExeConditional() )
					matched = true
					
				TType.op_Fall:
					node.add_Entry( parse_op_Fall() )
					matched = true
					
				TType.op_Goto:
					node.add_Entry( parse_op_Goto() )
					matched = true
					
				TType.sec_Heap:
					node.add_Entry( parse_sec_Heap() )
					matched = true
					
				TType.sec_Label:
					node.add_Entry( parse_sec_Label() )
					matched = true

				TType.sec_Loop:
					node.add_Entry( parse_sec_Loop() )
					matched = true

				TType.op_Return:
					node.add_Entry( parse_op_Return() )
					matched = true
					
				TType.sec_Stack:
					node.add_Entry( parse_sec_Stack() )
					matched = true
					
				TType.sec_Switch:
					node.add_Entry( parse_sec_ExeSwitch() )
					matched = true
					
				TType.sym_TT:
					node.add_Entry( parse_sec_ExeTT() )
					matched = true
								
				TType.sec_Using:
					node.add_Entry( parse_sec_ExeUsing() )
					matched = true
					
			if ! matched:
				var expression = parse_Expression()
			
				if expression != null:
					node.add_Entry( expression )

				matched = true
					
			if !matched:
				throw("Failed to match token: {tok}".format( { "tok" : Tok.to_Str() } ))
				return false
				
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			return false
		
	else:
		var matched = false
		match Tok.Type:
			TType.sym_Allocator:
				node.add_Entry( parse_sec_Allocator() )
				matched = true
				
			TType.op_Break:
				node.add_Entry( parse_op_Break() )
				matched = true
				
			TType.op_Continue:
				node.add_Entry( parse_op_Continue() )
				matched = true
									
			TType.sec_If:
				node.add_Entry( parse_sec_ExeConditional() )
				matched = true
					
			TType.op_Fall:
				node.add_Entry( parse_op_Fall() )
				matched = true
					
			TType.op_Goto:
				node.add_Entry( parse_op_Goto() )
				matched = true
					
			TType.sec_Heap:
				node.add_Entry( parse_sec_Heap() )
				matched = true	

			TType.sec_Loop:
				node.add_Entry( parse_sec_Loop() )
				matched = true
				
			TType.op_Return:
				node.add_Entry( parse_op_Return() )
				matched = true
					
			TType.sec_Switch:
				node.add_Entry( parse_sec_ExeSwitch() )
				matched = true
				
			TType.sym_TT:
				node.add_Entry( parse_sec_ExeTT() )
				matched = true
				
			TType.sec_Using:
				node.add_Entry( parse_sec_ExeUsing() )
				matched = true
				
		if ! matched:
			var expression = parse_Expression()
		
			if expression != null:
				node.add_Entry( expression )
				
			matched = true
					
		if !matched:
			throw("Failed to match token: {tok}".format( { "tok" : Tok.to_Str() } ))
			return false

	return true

func parse_sec_ExeConditional() -> SNode:
	var node = Sec_Cond.new()
	node.Attributes[SAttribute.exe] = true
	start(node)
	eat(TType.sec_If)
	
	node.set_Entry(0, parse_Expression() )
	
	var ifBlock = SNode.new(SType.sec_Exe)
	parse_sec_ExeBody(ifBlock)
	node.set_Entry(1, ifBlock)
	
	if Tok.Type != TType.sec_Else:
		end(node)
		return node
		
	eat(TType.sec_Else)
		
	var elseBlock = SNode.new(SType.sec_Exe)
	parse_sec_ExeBody(elseBlock)
	node.set_Entry(2, elseBlock)
	
	end(node)
	return node

func parse_sec_ExeSwitch() -> SNode:
	var node = Sec_Switch.new()
	node.Attributes[SAttribute.exe] = true
	start(node)
	eat(TType.sec_Switch)
	
	node.add_Entry( parse_Expression() )
	
	var result = chk_Tok( TType.def_Start )
	if  result == null:
		end(node)
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var scNode = Sec_SwitchCase.new()
			start(scNode)
			
			scNode.set_Entry(0, parse_Expression() )
			parse_sec_ExeBody( scNode )
			node.add_Entry( scNode )
			
			end(scNode)
			
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
	
	else:
		var scNode = Sec_SwitchCase.new()
		start(scNode)
		
		scNode.set_Entry(0, parse_Expression() )
		parse_sec_ExeBody( scNode )
		node.add_Entry( scNode )
		
		end(scNode)
	
	end(node)
	return node

func parse_sec_ExeTT() -> SNode:
	var node = Sec_TranslationTime.new()
	node.Attributes[SAttribute.exe] = true
	start(node)
	eat(TType.sym_TT)
	
	parse_sec_ExeBody(node)
	
	end(node)
	return node

func parse_sec_ExeUsing() -> SNode:
	var node = Sec_Using.new()
	node.Attributes[SAttribute.exe] = true
	start(node)
	eat(TType.sec_Using)
	
	node.set_Entry(0, parse_expr_Dependent() )
	
	if Tok.Type != TType.def_End:
		parse_sec_ExeBody(node)
	
	end(node)
	return node

func parse_sec_External() -> SNode:
	var node = Sec_External.new()
	start(node)
	eat(TType.sec_External)
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		return null
	
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			if ! parse_SectorBody(node):
				end(node)
				return node
				
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
		
	else:
		parse_SectorBody(node)
		
	end(node)
	return node

func parse_sec_Heap() -> SNode:
	var node = Sec_Heap.new()
	start(node)
	eat(TType.sec_Heap)
	
	var result = chk_Tok( TType.def_Start )
	if  result == null:
		end(node)
		return node
	
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var identifier 

			if Tok.Type == TType.sym_Identifier:
				identifier = parse_expr_Dependent()
				
			if eat(TType.op_Define):
				throw("Expecting op_Define: {tok}".format({ "tok" : Tok.to_str() }))
				end(node)
				return node

			var op = parse_sec_AllocatorOp(node, identifier)
			node.add_Entry(op)
			
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
		
	else:
		var identifier

		if Tok.Type == TType.sym_Identifier:
			identifier = parse_expr_Dependent()
			
		if eat(TType.op_Define):
			throw("Expecting op_Define: {tok}".format({ "tok" : Tok.to_str() }))
			end(node)
			return node
		
		var op = parse_sec_AllocatorOp(node, identifier)
		node.add_Entry(op)
	
	end(node)
	return node
	
func parse_sec_Identifier() -> SNode:
	var node = Sec_Identifier.new()
	start(node)

	if G.check(Tok.Type == TType.sym_Identifier, "Next token should have been an identifier symbol"):
		end(node)
		return node
		
	node.set_Entry(0, Tok.Value)
	eat(TType.sym_Identifier)
	
	if Tok.Type == TType.op_Map:
		node.set_Entry(1, parse_sec_ReturnMap() )
	
	if Tok == null || Tok.Type == TType.def_End:
		eat(TType.def_End)
		end(node)
		return node
		
	# Check for body
	if Tok.Type == TType.def_Start:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			if ! parse_SectorBody(node):
				end(node)
				return node
			
			if Tok == null:
				end(node)
				return node
					
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node

	else:
		parse_SectorBody(node)

	end(node)
	return node
	
func parse_sec_Inline() -> SNode:
	var node = Sec_Inline.new()
	start(node)
	eat(TType.sec_Inline)
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		return null
	
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			if ! parse_SectorBody(node):
				end(node)
				return node
				
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
	
	else:
		parse_SectorBody(node)

	end(node)
	return node
	
func parse_sec_Interface() -> SNode:
	var node = Sec_Interface.new()
	start(node)
	eat(TType.sec_Interface)
	
	node.add_Entry( parse_sym_Identifier() )
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		return null
	
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			if ! parse_SectorBody(node):
				end(node)
				return node
			
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
	
	else:
		parse_SectorBody(node)

	end(node)
	return node

func parse_sec_Label() -> SNode:
	var node = Sec_Label.new()
	start(node)
	eat(TType.sec_Label)
	
	node.add_Entry( parse_sym_Identifier() )
	parse_sec_ExeBody(node)
	
	end(node)
	return node
	
func parse_sec_Layer() -> SNode:
	var node = Sec_Layout.new()
	start(node)
	eat(TType.sec_Layer)
	
	node.add_Entry( parse_sec_Identifier() )
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		return null
	
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			if ! parse_SectorBody(node):
				end(node)
				return node
					
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
	
	else:
		parse_SectorBody(node)

	end(node)
	return node
	
func parse_sec_Layout() -> SNode:
	var node = Sec_Layout.new()
	start(node)
	eat(TType.sec_Layout)
	
	if Tok.Type == TType.cap_PStart:
		node.add_Entry( parse_Expression() )
	
	eat(TType.def_Start)
	
	while !chk_Tok(TType.def_End):
		match Tok.Type:
			TType.sym_Bytepad:
				node.add_Entry( parse_sym_Bytepad() )
				
			TType.sym_Identifier:
				node.add_Entry( parse_sym_Identifier() )
				
			_:
				throw("Failed to match token: {tok}".format( { "tok" : Tok.to_Str() } ))
				end(node)
				return node
		
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
	
	end(node)
	return node

func parse_sec_Loop() -> SNode:
	var node = Sec_Loop.new()
	start(node)
	eat(TType.sec_Loop)
	
	if Tok.Type == TType.sec_If:
		eat(TType.sec_If)	
		node.set_Entry(0, parse_Expression() ) 
	
	parse_sec_ExeBody(node)
		
	end(node)
	return node
	
func parse_sec_Readonly() -> SNode:
	var node = Sec_ReadOnly.new()
	start(node)
	eat(TType.sym_RO)
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		end(node)
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			if ! parse_SectorBody(node):
				end(node)
				return node
					
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
		
	else:
		parse_SectorBody(node)

	end(node)
	return node
	
func parse_sec_ReturnMap() -> SNode:
	var node = Sec_ReturnMap.new()
	start(node)
	eat(TType.op_Map)
	
	var type = parse_sym_Type()
	if type.num_Entries() > 0:
		node.add_Entry( type )
	else:
		match Tok.Type:
			TType.cap_PStart:
				node.add_Entry( parse_Expression() )
				
	end(node)
	return node

func parse_sec_Stack() -> SNode:
	var node = Sec_Stack.new()
	start(node)
	eat(TType.sec_Stack)
	
	var result = chk_Tok( TType.def_Start )
	if  result == null:
		end(node)
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var \
			identifiers = []
			identifiers.append( parse_sym_Identifier() )
			
			while Tok && Tok.Type == TType.op_CD:
				eat(TType.op_CD)
				identifiers.append( parse_sym_Identifier() )
				
			var type = parse_sec_Type(TType.op_Define)
			
			for identifier in identifiers:
				identifier.add_Entry( type )
				node.      add_Entry( identifier )
			
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
		
	else:
		var \
		identifiers = []
		identifiers.append( parse_sym_Identifier() )
		
		while Tok && Tok.Type == TType.op_CD:
			eat(TType.op_CD)
			identifiers.append( parse_sym_Identifier() )
				
		var type = parse_sec_Type(TType.op_Define)
			
		for identifier in identifiers:
			identifier.add_Entry( type )
			node.      add_Entry( identifier )
	
	end(node)
	return node

func parse_sec_Static() -> SNode:
	var node = Sec_Static.new()
	start(node)
	eat(TType.sec_Static)
	
	var result = chk_Tok( TType.def_Start )
	if  result == null:
		end(node)
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var \
			identifiers = []
			identifiers.append( parse_sym_Identifier() )
			
			while Tok && Tok.Type == TType.op_CD:
				eat(TType.op_CD)
				identifiers.append( parse_sym_Identifier() )
				
			var type = parse_sec_Type(TType.op_Define)
			
			for identifier in identifiers:
				identifier.add_Entry( type )
				node.      add_Entry( identifier )
			
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
		
	else:
		var \
		identifiers = []
		identifiers.append( parse_sym_Identifier() )
		
		while Tok && Tok.Type == TType.op_CD:
			eat(TType.op_CD)
			identifiers.append( parse_sym_Identifier() )
				
		var type = parse_sec_Type(TType.op_Define)
			
		for identifier in identifiers:
			identifier.add_Entry( type )
			node.      add_Entry( identifier )
	
	end(node)
	return node
	
func parse_sec_Struct() -> SNode:
	var node = Sec_Struct.new()
	start(node)
	eat(TType.sec_Struct)
	
	var result = chk_Tok( TType.def_Start )
	if  result == null || result == false:
		end(node)
		return node
		
	eat(TType.def_Start)
	
	while !chk_Tok(TType.def_End):
		match Tok.Type:
			TType.sec_Using:
				node.add_Entry( parse_sec_StructUsing() )
				
			TType.sym_Identifier:
				var identifier = parse_sym_Identifier()
				var type       = parse_sec_Type(TType.op_Define)
		
				identifier.add_Entry( type )
				node.      add_Entry( identifier )
		
	if eat(TType.def_End):
		throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
		end(node)
		return node
	
	end(node)
	return node
	
func parse_sec_StructUsing() -> SNode:
	var node = Sec_Using.new()
	start(node)
	eat(TType.sec_Using)
	
	node.set_Entry(0, parse_expr_Dependent())
	
	end(node)
	return node

func parse_sec_Switch() -> SNode:
	var node = Sec_Switch.new()
	start(node)
	eat(TType.sec_Switch)
	
	node.add_Entry( parse_Expression() )
		
	var result = chk_Tok( TType.def_Start )
	if  result == null:
		end(node)
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			node.add_Entry( parse_sec_SwitchCase() )
			
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
	
	else:
		node.add_Entry( parse_sec_SwitchCase() )
	
	end(node)
	return node
	
func parse_sec_SwitchCase() -> SNode: 
	var node = Sec_SwitchCase.new()
	start(node)
	node.set_Entry(0, parse_Expression() )
	
	var result = chk_Tok( TType.def_Start )
	if result == null:
		end(node)
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			if ! parse_SectorBody(node):
				end(node)
				return node

		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
		
	else:
		parse_SectorBody(node)

	end(node)
	return node

func parse_sec_Trait() -> SNode:
	var node = Sec_Trait.new()
	start(node)
	eat(TType.sec_Trait)
	
	if Tok.Type == TType.sym_Allocator:
		node.add_Entry( parse_Simple(SType.sym_Allocator, TType.sym_Allocator) )
	else:
		node.add_Entry( parse_expr_Dependent() )
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		return null
	
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			if ! parse_SectorBody(node):
				end(node)
				return node
					
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
	
	else:
		parse_SectorBody(node)

	end(node)
	return node

func parse_sec_TranslationTime() -> SNode:
	var node = Sec_TranslationTime.new()
	start(node)
	eat(TType.sym_TT)

	if Tok == null:
		end(node)
		return node
		
	# Check for body
	if Tok.Type == TType.def_Start:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			if ! parse_SectorBody(node):
				end(node)
				return node
					
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node

	else:
		parse_SectorBody(node)

	end(node)
	return node

func parse_sec_Type(typeTok : String) -> SNode:
	var node = Sec_Type.new()
	start(node)

	if typeTok == TType.op_Define && Tok.Type == TType.op_A_Infer:
		pass
	else:
		if eat(Tok.Type):
			throw("Expecting {typeTok}: {tok}".format( { "typeTok" : typeTok, "tok" : Tok.to_Str()  } ))
			end(node)

	if Tok == null:
		end(node)
		return node
	
	if Tok.Type == TType.op_A_Infer:
		eat(TType.op_A_Infer)
		
		match Tok.Type:
			TType.literal_Digit   : node.set_Entry(0, parse_sym_Inferred(SType.builtin_Int))
			TType.literal_Decimal : node.set_Entry(0, parse_sym_Inferred(SType.builtin_Float))
			TType.literal_String  : node.set_Entry(0, parse_sym_Inferred(SType.builtin_String))
			TType.literal_Char    : node.set_Entry(0, parse_sym_Inferred(SType.builtin_String))
			TType.literal_True    : node.set_Entry(0, parse_sym_Inferred(SType.builtin_Bool))
			TType.literal_False   : node.set_Entry(0, parse_sym_Inferred(SType.builtin_Bool))
			TType.literal_Binary  : node.set_Entry(0, parse_sym_Inferred(SType.builtin_Int))
			TType.literal_Octal   : node.set_Entry(0, parse_sym_Inferred(SType.builtin_Int))
			TType.literal_Hex     : node.set_Entry(0, parse_sym_Inferred(SType.builtin_Int))
			
			_:
				node.set_Entry(0, parse_sym_Inferred())

		node.set_Entry(1, parse_Expression() )

	else:
		node.set_Entry(0, parse_sym_Type() )

		if Tok == null:
			end(node)
			return node
			
		if Tok.Type ==  TType.op_Assign:
			eat(TType.op_Assign)
			
			node.set_Entry(1, parse_Expression() )
			
		elif Tok.Type == TType.def_Start:
			eat(TType.def_Start)
			
			node.set_Entry(1, parse_Expression() )
			
			if eat(TType.def_End):
				throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
				end(node)
				return node

	end(node)
	return node

func parse_sec_Union() -> SNode:
	var node = Sec_Union.new()
	start(node)
	eat(TType.sec_Union)
	
	if Tok.Type == TType.cap_PStart:
		eat(TType.cap_PStart)
		node.add_Entry( parse_sym_Identifier() )
		eat(TType.cap_PEnd)
	
	var result = chk_Tok( TType.def_Start )
	if  result == null || result == false:
		end(node)
		return node
		
	eat(TType.def_Start)
	
	while !chk_Tok(TType.def_End):
		var identifier = parse_sym_Identifier()
		var type       = parse_sec_Type(TType.op_Define)
		
		identifier.add_Entry( type )
		node.      add_Entry( identifier )
		
	if eat(TType.def_End):
		throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
		end(node)
		return node
	
	end(node)
	return node

func parse_sec_Virtual() -> SNode:
	var node = Sec_Virtual.new()
	start(node)
	eat(TType.sec_Virtual)
		
	if Tok.Type == TType.sym_Allocator:
		node.add_Entry( parse_Simple(SType.sym_Allocator, TType.sym_Allocator) )
	else:
		node.add_Entry( parse_expr_Dependent() )
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		return null
	
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			if ! parse_SectorBody(node):
				end(node)
				return node
					
		if eat(TType.def_End):
			throw("Expecting def_End {tok}".format( { "tok" : Tok.to_Str()  } ))
			end(node)
			return node
	
	else:
		parse_SectorBody(node)

	end(node)
	return node
#endregion Sectors

#region Expressions
func parse_Expression() -> SNode:
	return parse_expr_Delimited()
	
func parse_expr_Binary_tok(elementFn : Callable, tType : String, SType) -> SNode:
	var left = elementFn.call()

	var   result = Tok != null && Tok.Type == tType
	while result:
		var node = Expr_Binary.new(SType)
		start_span(node)
		eat(Tok.Type)
	
		var right = parse_Expression()
		
		node.add_Entry(left)
		node.add_Entry(right)
		
		node.Span.Start = left.Span.End
		node.Span.End   = right.Span.End
		node.Context = Context.duplicate()
		
		push_Context(node)
		left.Context  = Context.duplicate()
		right.Context = Context.duplicate()
		pop_Context()
		
		left   = node
		result = Tok != null && Tok.Type == tType
	
	return left
	
func parse_expr_Binary(elementFn : Callable, op : Callable) -> SNode:
	var left = elementFn.call()

	var   result = op.call()
	while result:
		eat(Tok.Type)
	
		var right = parse_Expression()
		
		var \
		node = SNode.new(result)
		node.add_Entry(left)
		node.add_Entry(right)
		
		node.Span.Start = left.Span.End
		node.Span.End   = right.Span.End
		node.Context = Context.duplicate()
		
		push_Context(node)
		left.Context  = Context.duplicate()
		right.Context = Context.duplicate()
		pop_Context()
		
		left = node
		
		result = op.call()
	
	return left

# Sorted by precedence (First is highest)
	
func parse_expr_Element() -> SNode:
	var matched = false
	match Tok.Type:
		TType.sym_Null : return parse_Simple(SType.sym_Null, TType.sym_Null)
		TType.sym_Self : return parse_sym_Self(true)
		TType.sym_Ptr  : return parse_sym_Ptr()
#		TType.sym_RO   : return parse_sym_RO()
		TType.sym_LP   : return parse_Simple(SType.sym_LP, TType.sym_LP)
			
		TType.sym_Identifier:
			return parse_sym_Identifier()
		
		# Literal detection needs to be moved to its own block...
		TType.literal_String  : return parse_Literal(SType.literal_String,  TType.literal_String)
		TType.literal_Digit   : return parse_Literal(SType.literal_Digit,   TType.literal_Digit)
		TType.literal_Decimal : return parse_Literal(SType.literal_Decimal, TType.literal_Decimal)
		TType.literal_Char    : return parse_Literal(SType.literal_Char,    TType.literal_Char)
		TType.literal_True    : return parse_Literal(SType.literal_True,    TType.literal_True)
		TType.literal_False   : return parse_Literal(SType.literal_False,   TType.literal_False)
		TType.literal_Hex     : return parse_Literal(SType.literal_Hex,     TType.literal_Hex)
		TType.literal_Octal   : return parse_Literal(SType.literal_Octal,   TType.literal_Octal)
		TType.literal_Binary  : return parse_Literal(SType.literal_Binary,  TType.literal_Binary)
	
	var assertStrTmplt = "Could not match token in parse_expr_Element! : {value} - {type} ; Span: {start} {end} }"
	var assertStr      = assertStrTmplt.format({"value" : Tok.Value, "type" : Tok.Type, "start" : Tok.Start, "end" : Tok.End })
		
	G.check(false, assertStr)
	return null
	
func parse_expr_SMA() -> SNode:
	if Tok.Type == TType.op_SMA:
		var start = Tok.Start
		eat(TType.op_SMA)
		
		var \
		node = Expr_SMA.new()
		node.Span.Start = start
		node.Context = Context.duplicate()
		push_Context(node)
		
		match Tok.Type:
			TType.op_AlignOf  : node.set_Entry(1, parse_Simple(SType.op_AlignOf, TType.op_AlignOf))
			TType.op_OffsetOf : node.set_Entry(1, parse_Simple(SType.op_OffsetOf, TType.op_OffsetOf))
			TType.op_SizeOf   : node.set_Entry(1, parse_Simple(SType.op_SizeOf, TType.op_SizeOf))
			TType.op_PosOf    : node.set_Entry(1, parse_Simple(SType.op_PosOf, TType.op_PosOf))
			
			TType.sym_Ptr : node.set_Entry(1, parse_Simple(SType.op_Ptr, TType.sym_Ptr))
			TType.op_Val  : node.set_Entry(1, parse_Simple(SType.op_Val, TType.op_Val))
			_:
				node.set_Entry(1, parse_expr_Dependent() )
				

		end(node)
		return node

	var element = parse_expr_Element()
		
	if Tok && Tok.Type == TType.op_SMA:
		var start = Tok.Start
		eat(TType.op_SMA)
		
		var \
		node = Expr_SMA.new()
		node.set_Entry(0, element)
		node.Span.Start = start
		node.Context = Context.duplicate()
		push_Context(node)
		
		match Tok.Type:
			TType.op_AlignOf  : node.set_Entry(1, parse_Simple(SType.op_AlignOf, TType.op_AlignOf))
			TType.op_OffsetOf : node.set_Entry(1, parse_Simple(SType.op_OffsetOf, TType.op_OffsetOf))
			TType.op_SizeOf   : node.set_Entry(1, parse_Simple(SType.op_SizeOf, TType.op_SizeOf))
			TType.op_PosOf    : node.set_Entry(1, parse_Simple(SType.op_PosOf, TType.op_PosOf))
			
			TType.sym_Ptr : node.set_Entry(1, parse_Simple(SType.op_Ptr, TType.sym_Ptr))
			TType.op_Val  : node.set_Entry(1, parse_Simple(SType.op_Val, TType.op_Val))
			_:
				node.set_Entry(1, parse_expr_Dependent() )
				

		end(node)
		return node
	
	return element;

func parse_expr_SBCap() -> SNode:
	var left = parse_expr_Cast()
	
	if Tok == null || Tok.Type != TType.cap_SBStart:
		return left
		
	var node = Expr_SBCap.new()
	start(node)
	eat(TType.cap_SBStart)
	
	node.set_Entry(0, left)
	node.set_Entry(1, parse_Expression())
	
	if eat(TType.cap_SBEnd):
		throw("Expecting cap_SBEnd {tok}".format( { "tok" : Tok.to_Str()  } ))
		end(node)
		return node
	
	if Tok.Type == TType.op_SMA:
		node.set_Entry(2, parse_expr_SMA() )
	
	end(node)
	return node

func parse_expr_Cast() -> SNode:
	if Tok.Type == TType.op_Cast:
		var node = SNode.new(SType.op_Cast)
		start(node)
		
		eat(TType.op_Cast)
		node.add_Entry( parse_expr_Capture() )
		
		end(node)
		return node
	
	return parse_expr_SMA()

func op_Callable(node):
	match node.Type:
		SType.expr_SBCap     : return true
		SType.op_Cast        : return true
		SType.sym_Identifier : return true
		_:
			return false

func parse_expr_Dependent() -> SNode:
	var element = parse_expr_SBCap()
	
	if element == null:
		return element

	if op_Callable(element) && Tok.Type == TType.cap_PStart:
		var \
		node = Expr_Dependent.new()
		node.Context = Context.duplicate()
		node.Span.Start = element.Span.End
		push_Context(node)
		
		node.add_Entry( element )
		node.add_Entry( parse_expr_Capture() )
	
		end(node)
		return node
		
	return element
	
func parse_expr_Capture() -> SNode:
	var node = SNode.new(SType.expr_Cap)
	start(node)
	var expression
	
	eat(TType.cap_PStart)
	if Tok.Type != TType.cap_PEnd:
		expression = parse_Expression()
		
	if eat(TType.cap_PEnd):
		throw("Expecting cap_PEnd {tok}".format( { "tok" : Tok.to_Str()  } ))
		end(node)
		return node
	
	if expression:
		node.add_Entry(expression)
		
	end(node)
	return node
	
func op_Unary():
	if Tok == null:
		return null
	
	match Tok.Type:
		TType.op_Subtract : return SType.op_UnaryNeg
		TType.op_LNot     : return SType.op_LNot
		TType.op_BNot     : return SType.op_BNot
		_:
			return null

func parse_expr_Unary() -> SNode:
	var operator = op_Unary()
	
	if operator == null:
		if Tok.Type == TType.cap_PStart:
			return parse_expr_Capture()
		else:
			return parse_expr_Dependent()
		
	var node = Expr_Unary.new(operator)
	start(node)
	
	eat(Tok.Type)
	node.add_Entry( parse_expr_Unary() )
	
	end(node)
	return node

func op_Multiplicative():
	if Tok == null:
		return null
		
	match Tok.Type:
		TType.op_Multiply : return SType.op_Multiply
		TType.op_Divide   : return SType.op_Divide
		TType.op_Modulo   : return SType.op_Modulo
		_:
			return null
			
func parse_expr_Multiplicative() -> SNode:
	return parse_expr_Binary(parse_expr_Unary, op_Multiplicative)
	
func op_Additive():
	if Tok == null:
		return null
	
	match Tok.Type:
		TType.op_Add      : return SType.op_Add
		TType.op_Subtract : return SType.op_Subtract
		_:
			return null
	
func parse_expr_Additive() -> SNode:
	return parse_expr_Binary(parse_expr_Multiplicative, op_Additive)
	
func op_Bitshift():
	if Tok == null:
		return null
		
	match Tok.Type:
		TType.op_BSL : return SType.op_BSL
		TType.op_BSR : return SType.op_BSR
		_:
			return null
	
func parse_expr_Bitshift() -> SNode:
	return parse_expr_Binary(parse_expr_Additive, op_Bitshift)
	
func parse_expr_BitwiseAnd() -> SNode:
	return parse_expr_Binary_tok(parse_expr_Bitshift, TType.op_BAnd, SType.op_BAnd)
	
func parse_expr_BitwiseXOr() -> SNode:
	return parse_expr_Binary_tok(parse_expr_BitwiseAnd, TType.op_BXOr, SType.op_BXOr)

func parse_expr_BitwiseOr() -> SNode:
	return parse_expr_Binary_tok(parse_expr_BitwiseXOr, TType.op_BOr, SType.op_BOr)
	
func op_Relational():
	if Tok == null:
		return null
		
	match Tok.Type:
		TType.op_Greater      : return SType.op_Greater
		TType.op_Lesser       : return SType.op_Lesser
		TType.op_GreaterEqual : return SType.op_GreaterEqual
		TType.op_LesserEqual  : return SType.op_LesserEqual
		_:
			return null
	
func parse_expr_Relational() -> SNode:
	return parse_expr_Binary(parse_expr_BitwiseOr, op_Relational)
	
func op_Equality():
	if Tok == null:
		return null
		
	match Tok.Type:
		TType.op_Equal    : return SType.op_Equal
		TType.op_NotEqual : return SType.op_NotEqual
		_:
			return null

func parse_expr_Equality() -> SNode:
	return parse_expr_Binary(parse_expr_Relational, op_Equality)
	
func parse_expr_LogicalAnd() -> SNode:
	return parse_expr_Binary_tok(parse_expr_Equality, TType.op_LAnd, SType.op_LAnd)
	
func parse_expr_LogicalOr() -> SNode:
	return parse_expr_Binary_tok(parse_expr_LogicalAnd, TType.op_LOr, SType.op_LOr)
	
func op_Assignment():
	if Tok == null:
		return null
	
	match Tok.Type:
		TType.op_Assign     : return SType.op_Assign
		TType.op_A_Add      : return SType.op_A_Add
		TType.op_A_Subtract : return SType.op_A_Subtract
		TType.op_A_Multiply : return SType.op_A_Multiply
		TType.op_A_Divide   : return SType.op_A_Divide
		TType.op_A_Modulo   : return SType.op_A_Modulo
		TType.op_AB_And     : return SType.op_AB_And
		TType.op_AB_Not     : return SType.op_AB_Not
		TType.op_AB_Or      : return SType.op_AB_Or
		TType.op_AB_SL      : return SType.op_AB_SL
		TType.op_AB_SR      : return SType.op_AB_SR
		TType.op_AB_XOr     : return SType.op_AB_XOr
		_:
			return null
	
func parse_expr_Assignment() -> SNode:
	return parse_expr_Binary(parse_expr_LogicalOr, op_Assignment)
	
func parse_expr_Delimited() -> SNode:
	return parse_expr_Binary_tok(parse_expr_Assignment, TType.op_CD, SType.op_CD)
#endregion Expressions

func parse_sym_Array() -> SNode:
	var node = Sym_Array.new()
	start(node)
	
	eat(TType.cap_SBStart)
	if Tok.Type != TType.cap_SBEnd:
		node.add_Entry( parse_Expression() )
	
	if eat(TType.cap_SBEnd):
		throw("Expecting cap_SBEnd {tok}".format( { "tok" : Tok.to_Str()  } ))
		end_span(node)
		return node
	
	node.add_Entry( parse_sym_Type() )
	
	end(node)
	return node
	
func parse_sym_Bytepad() -> SNode:
	var node = Sym_Bytepad.new()
	start(node)
	eat(TType.sym_Bytepad)
	
	if eat(TType.op_Define):
		throw("Expecting op_Define {tok}".format( { "tok" : Tok.to_Str()  } ))
		end_span(node)
		return node
	
	node.add_Entry( parse_expr_Dependent() )
	
	end(node)
	return node
	
func parse_sym_Identifier() -> SNode:
	var node = Sym_Identifier.new()
	start(node)
	
	node.add_TokVal(Tok)
	eat(TType.sym_Identifier)
	
	end(node)
	return node

func parse_sym_Proc() -> SNode:
	var node = Sym_Proc.new()
	start(node)
	eat(TType.sym_Exe)
	
	if Tok.Type == TType.cap_PStart:
		node.set_Entry(0, parse_sec_CaptureArgs() )
	
	if Tok.Type == TType.op_Map:
		node.set_Entry(1, parse_sec_ReturnMap() )
			
	end(node)
	return node
	
func parse_sym_Ptr() -> SNode:
	var node = Sym_Ptr.new()
	start(node)
	eat(TType.sym_Ptr)
	
	match Tok.Type:
		TType.sym_Byte       : node.add_Entry( parse_Simple(SType.sym_Byte, TType.sym_Byte) )
		TType.sym_Word       : node.add_Entry( parse_Simple(SType.sym_Word, TType.sym_Word) )

	if node.num_Entries() == 0:
		node.add_Entry( parse_sym_Type() )
	
	end(node)
	return node

func parse_sym_RO() -> SNode:
	var node = Sym_RO.new()
	start(node)
	eat(TType.sym_RO)

	node.add_Entry( parse_sym_Type() )
	
	end(node)
	return node

func parse_sym_Self(fromExpr : bool = false) -> SNode:
	var node = Sym_Self.new()
	start(node)
	eat(TType.sym_Self)
	
	if ! fromExpr && Tok.Type == TType.op_Define:
		node.set_Entry(0, parse_sec_Type(TType.op_Define) )
	
	end(node)
	return node

func parse_sym_Type(token = null) -> SNode:
	var node = Sym_Type.new()
	start(node)
	
	if token:	
		eat(TType.sym_Type)

	match Tok.Type:
		TType.sym_TT: node.add_Entry( parse_sym_TT_Type() )
		
		TType.sym_Type : node.add_Entry( parse_Simple(SType.sym_TType, TType.sym_Type) )

		TType.sym_gd_Bool   : node.add_Entry( parse_Simple(SType.builtin_Bool, TType.sym_gd_Bool) )
		TType.sym_gd_Int    : node.add_Entry( parse_Simple(SType.builtin_Int,   TType.sym_gd_Int) )
		TType.sym_gd_Float  : node.add_Entry( parse_Simple(SType.builtin_Float,   TType.sym_gd_Float) )
		TType.sym_gd_String : node.add_Entry( parse_Simple(SType.builtin_String,   TType.sym_gd_String) )

		TType.sym_Identifier : node.add_Entry( parse_expr_Dependent() )
		TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
		TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
		TType.sym_RO         : node.add_Entry( parse_sym_RO() )
		TType.cap_SBStart    : node.add_Entry( parse_sym_Array() )
		
	end(node)
	return node

func parse_sym_Inferred(token = null) -> SNode:
	var node = Sym_Infer.new()
	if token:
		node.set_Entry(0, token)
	
	return node

func parse_sym_TT_Type() -> SNode:
	var node = Sym_TT_Type.new()
	start(node)
	eat(TType.sym_TT)
	
	node.add_Entry( parse_sym_Type() )

	end(node)
	return node
	
func parse_op_Break() -> SNode:
	var node = Op_Break.new()
	start(node)
	
	eat(TType.op_Break)
	
	end(node)
	return node

func parse_op_Continue() -> SNode:
	var node = Op_Continue.new()
	start(node)
	
	eat(TType.op_Continue)
	
	end(node)
	return node

func parse_op_Fall() -> SNode:
	var node = Op_Fall.new()
	start(node)
	
	eat(TType.op_Fall)
	
	end(node)
	return node

func parse_op_Goto() -> SNode:
	var node = Op_GoTo.new()
	start(node)
	
	if Tok.Type != TType.sym_Identifier:
		throw("Expecting sym_Identifier {tok}".format( { "tok" : Tok.to_Str()  } ))
		end_span(node)
		return node
		
	node.add_Entry( parse_sym_Identifier() )
	
	end(node)
	return node

func parse_op_Return() -> SNode:
	var node = Op_Return.new()
	start(node)
	eat(TType.op_Return)
	
	if Tok.Type == TType.def_End:
		end(node)
		return node
	
	match Tok.Type:
		_:
			node.set_Entry(0, parse_Expression() )

	end(node)
	return node

func parse_Simple(SType, tType = null) -> SNode:
	var node = SNode.new(SType)
	start(node)
	
	if tType:
		eat(tType)
	
	end(node)
	return node

func parse_Literal(SType, tType) -> SNode:
	var node = Sym_Literal.new(SType)
	start(node)
	
	node.add_TokVal(Tok)
	eat(tType)
	
	end(node)
	return node
	
func parse_TokValue(SType, tType) -> SNode:
	var node = SNode.new(SType)
	start(node)
	
	node.add_TokVal(Tok)
	eat(tType)
	
	end(node)
	return node
	
#region Object
func _init( lexer : Lexer ) -> void:
	Lex = lexer
#endregion Object
