# Note: Rename to token parser: TParser
# Parses tokens to generate SNodes
# As opposed to the SEditor which may generate them directly
# (Or may be usd by the SEditor to generate nodes from user text input)

class_name TParser extends Object

# NOTE:
# The parser  model used here may be able to generate an ast that the interpreter at the 
# "GDScript level" of implementation will not be able to support (Or possibly LLVM for that matter).
# So those nodes will not be supported on the demo langauge platform.
 
const SAttribute = \
{
	allocator = "Allocator",
	
	builtin = "Builtin",
	literal = "Literal",
	
	expression = "expression",
	operation = "Operation",
	op_Logical = "Op: Logical",
	op_Unary = "Op: Unary",
	
	sector = "Sector",
	symbol = "Symbol",
	exe    = "executable element",
}

const SType = \
{
	empty = "Empty Statement",
	unit = "Module Unit",

	expr_Cap   = "Capture",
	expr_SBCap = "Bracketed Capture",
	
	op_Call   = "Op: Call",
	op_CD     = "Op: Comma Delimiter",
	op_Ptr    = "Op: Address Of (Get Pointer)",
	op_SMA    = "Op: Member Resolution",
	
	op_Break  = "Op: Break",
	op_Cast   = "Op: Cast",
	op_Return = "Op: Return",
	
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
	op_A_Add    = "Op: Assign Add",
	
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
	
	sec_Allocator   = "Sector: Allocator",
	sec_Cap         = "Sector: Capture",
	sec_CapArgs     = "Sector: Capture Arguments",
	sec_RetMap      = "Sector: Return Map",
	sec_Cond        = "Sector: Conditional",
	sec_Enum        = "Sector: Enum",
	sec_EnumElement = "Sector: Enum Element",
	sec_Exe         = "Sector: Execution",
	sec_ExeCond     = "Sector: Execution Conditional",
	sec_ExeSwitch   = "Sector: Execution Switch",
	sec_Heap        = "Sector: Heap",
	sec_LP          = "Sector: Langauge Platform",
	sec_Loop        = "Sector: Loop",
	sec_LoopCond    = "Sector: Loop Conditional",
	sec_RO          = "Sector: Readonly",
	sec_Stack       = "Sector: Stack",
	sec_Static      = "Sector: Static",
	sec_Struct      = "Sector: Struct",
	sec_StructUsing = "Sector: Struct Using",
	sec_Switch      = "Sector: Switch",
	sec_SwitchCase  = "Sector: Switch Case",
	sec_TT          = "Sector: Translation Time",
	sec_Type        = "Sector: Type",
	sec_Union       = "Sector: Union",
	sec_Using       = "Sector: Using",
	sec_Identifier  = "Sector: Identifier",
	
	builtin_bool   = "GD: bool",
	builtin_int    = "GD: int",
	builtin_float  = "GD: float",
	builtin_Array  = "GD: Array",
	builtin_Dict   = "GD: Dictionary",
	builtin_string = "GD: String",
	
	sym_Allocator  = "Symbol: Allocator",
	sym_Array      = "Symbol: Array",
	sym_LP         = "Symbol: Language Platform",
	sym_Proc       = "Symbol: Procedure",
	sym_Ptr        = "Symbol: Pointer",
	sym_Self       = "Symbol: Self",
	sym_Type       = "Symbol: Type",
	sym_TType      = "Symbol: Top Type",
	sym_TT_Type    = "Symbol: Translation Time Type",

	sym_Identifier = "Symbol: Identifier",
}

const STxt = {
	TType.op_Define: ":",

	SType.builtin_bool: "bool",
	SType.builtin_int: "int",
	
	SType.literal_True: "true",
	SType.literal_False: "false",
	
	SType.op_Assign: "=",
	
	SType.op_Add : "+",
	
	SType.sec_Exe : "exe",
	SType.sec_Static : "static",
	SType.sec_TT : "tt",
	SType.sec_Type : "type",
}

class Range2i:
	var Start : Vector2i
	var End   : Vector2i
	
	func _init(start = null, end = null):
		Start = Vector2i() if start == null else start
		End   = Vector2i() if end   == null else end

# Going to rename to SNode or SyntaxNode, this is the nodes generated and managed by the frontend
class SNode extends RefCounted :
	var Type         : String
	var Attributes   : Dictionary
	var Span         : Range2i
	var Parent       : SNode
	var Data         : Array

#region Methods
	func name() -> String:
		return STxt[Type]

	func add_Entry( _entry ) -> void:
		if typeof(_entry) == TYPE_OBJECT:
			_entry.Parent = self
		
		Data.append( _entry )
		
	func insert_Entry( index, _entry ) -> void:
		if typeof(_entry) == TYPE_OBJECT:
			_entry.Parent = self
		
		Data.insert(index, _entry )

	func add_TokVal( token ) -> void:
		Data.append( token.Value )

	func entry( id : int):
		return  Data[id - 1]
		
	func num_Entries() -> int:
		return Data.size()
		
	func string() -> String:
		return entry(1).substr(1, entry(1).length() - 2)
				
	func set_Type( type ) -> void:
		if G.check(type.has(type), "Attempted to set a type thats not in SType."):
			return
		
		Type = type
#endregion Methods

#region Serialization
	func array_Serialize(array) -> Array:
		var result = []

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

class Sec_Allocator extends SNode:
	func name(): 
		return Data[1]

	func entry( id : int ):
		return Data[ id ]

	func num_Entires() -> int:
		return Data.size() - 1

	func _init():
		set_Type( SType.sec_Allocator )
		Attributes[SAttribute.sector] = true
		Attributes[SAttribute.allocator] = true

class Sec_AllocatorOp extends SNode:
	func identifier():
		return Data[0]
		
	func capture():
		return Data[1]
		
	func _init(SType =  ""):
		if SType != "":
			set_Type(SType)
		Attributes[SAttribute.exe] = true

class Sec_Capture extends SNode:
	func args():
		return Data[1]
		
	func has_RetMap() -> bool:
		return Data.size() > 1 && Data[2].Type == SType.sec_RetMap
	
	func ret_Map():
		return Data[2]
		
	func entry( id : int ):
		return Data[ id + 1 ]
		
	func num_Entries() -> int:
		return Data.size() - 2
		
	func _init():
		set_Type( SType.sec_Cap )
		Attributes[SAttribute.sector] = true

class Sec_CaptureArgs extends SNode:
	func contains_self() -> bool:
		for _entry in Data:
			if _entry.Type == SType.sym_Self:
				return true
				
		return false
		
	func map():
		return Data[0]
		
	func entry( id : int ):
		return Data[ id ]
		
	func num_Entries() -> int:
		return Data.size() - 1
		
	func _init():
		set_Type( SType.sec_CapArgs )
		Attributes[SAttribute.sector] = true

class Sec_ReturnMap extends SNode:
	func expression():
		return Data[0]
	
	func entry( id ):
		return Data[ id ]
		
	func num_Entries():
		return Data.size() - 1
		
	func _init():
		set_Type( SType.sec_RetMap )
		Attributes[SAttribute.sector] = true

class Sec_Conditional extends SNode:
	func cond():
		return Data[0]
		
	func body():
		return Data[1]
		
	func has_Alt():
		return num_Entries() > 2
		
	func alt():
		return Data[2]
		
	func _init():
		set_Type( SType.sec_Cond )
		Attributes[SAttribute.sector] = true

class Sec_Enum extends SNode:
	func has_capture():
		return Data[0] != null
	
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
		
	func has_Assign():
		return Data.size() > 0
	
	func _init():
		set_Type(SType.sec_EnumElement)
		Attributes[SAttribute.sector] = true

class Sec_Exe extends SNode:
	func _init():
		set_Type(SType.sec_Exe)
		Attributes[SAttribute.sector] = true
	
class Sec_ExeCond extends SNode:
	func cond():
		return Data[0]
		
	func body():
		return Data[1]
		
	func has_Alt():
		return num_Entries() > 2
		
	func alt():
		return Data[2]
		
	func _init():
		set_Type(SType.sec_ExeCond)
		Attributes[SAttribute.sector] = true

class Sec_ExeSwitch extends SNode:
	func cond():
		return Data[0]
		
	func entry( id ):
		return Data[ id ]
		
	func num_Entries():
		return Data.size() - 1
	
	func _init():
		set_Type(SType.sec_ExeSwitch)
		Attributes[SAttribute.sector] = true

class Sec_Heap extends SNode:
	func _init():
		set_Type( SType.sec_Heap )
		Attributes[SAttribute.sector] = true
		Attributes[SAttribute.allocator] = true

class Sec_Loop extends SNode:
	func has_Cond():
		return Data[0] != null
		
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
	func _init():
		set_Type(SType.sec_StructUsing)
		Attributes[SAttribute.sector] = true
		
class Sec_Switch extends SNode:
	func _init():
		set_Type(SType.sec_Switch)
		Attributes[SAttribute.sector] = true

class Sec_TranslationTime extends SNode:
	func _init():
		set_Type(SType.sec_TT)
		Attributes[SAttribute.sector] = true

class Sec_Type extends SNode:
	func assignment():
		return Data[0]
	
	func has_Assignment() -> bool:
		return Data.size() > 1
	
	func _init():
		set_Type( SType.sec_Type )
		Attributes[SAttribute.sector] = true

class Sec_Union extends SNode:
	func _init():
		set_Type( SType.sec_Union )
		Attributes[SAttribute.sector] = true

class Sec_Identifier extends SNode:
	func name() -> String:
		return Data[0]
	
	func entry( id : int ):
		return Data [ id ]
		
	func num_Entries() -> int:
		return Data.size() - 1

	func _init():
		set_Type( SType.sec_Identifier )
		Attributes[SAttribute.sector] = true

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
		
	func has_SMA():
		return Data.size() > 2
		
	func sma():
		return Data[2]
	
	func _init():
		set_Type(SType.expr_SBCap)
		Attributes[SAttribute.expression] = true
		Attributes[SAttribute.operation] = true

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

class Expr_Call extends SNode:
	func identifier():
		return Data[0]
		
	func args():
		return Data[1]
	
	func _init():
		set_Type(SType.op_Call)
		Attributes[SAttribute.expression] = true
		Attributes[SAttribute.operation] = true

class Expr_Unary extends SNode:
	func op():
		return Data[0]
	
	func operand():
		return Data[1]
	
	func _init( type = "" ):
		if type != "":
			set_Type(type)
		Attributes[SAttribute.expression] = true
		Attributes[SAttribute.operation] = true

class Sym_Array extends SNode:
	func _init():
		set_Type(SType.sym_Array)
		Attributes[SAttribute.symbol] = true
	
class Sym_Identifier extends SNode:
	func name() -> String:
		return Data[0]
		
	func has_Typedef() -> bool:
		return Data.size() > 1 && Data[2].Type == SType.sec_Type
	
	func typedef() -> SNode:
		return Data[1]

	func _init():
		set_Type( SType.sym_Identifier )
		Attributes[SAttribute.symbol] = true
	
class Sym_Proc extends SNode:
	func _init():
		set_Type(SType.sym_Proc)
		Attributes[SAttribute.symbol] = true
		
class Sym_TT_Type extends SNode:
	func _init():
		set_Type(SType.sym_TT_Type)
		Attributes[SAttribute.symbol] = true

const TType = Lexer.TType
const TCatVal = Lexer.TCatVal
const TCategory = Lexer.TCategory
var   Lex   : Lexer
var   Tok

func chk_Tok( tokeSType ):
	if G.check(Tok != null, "Tok is null!"):
		return null
		
	return Tok.Type == tokeSType

# Gets the next token only if the current token is the specified intended token (tokeSType)
func eat( tokeSType ):
	var currToken = Tok
	
	if G.check(currToken != null, "Tok was null"):
		return null
	
	var assertStrTmplt = "Unexpected token: {value} , expected: {type}"
	var assertStr      = assertStrTmplt.format({"value" : currToken.Value, "type" : tokeSType})
		
	if G.check(currToken.Type == tokeSType, assertStr):
		Tok = null
		return null

	Tok = Lex.next_Token()

	return currToken

func start(node):
	node.Span.Start = Tok.Start
	
func end(node):
	node.Span.End = Lex.last_Token().End

func parse_unit() -> SNode:
	Tok = Lex.next_Token()
	
	var node = SNode.new(SType.unit)
	start(node)
	
	while Tok != null :
		var matched = false
		match Tok.Type:
			TType.cap_PStart:
				node.add_Entry( parse_sec_Capture() )
				matched = true
			
		#region LP_Sectors
			TType.sec_If:
				node.add_Entry( parse_sec_Conditional() )
				matched = true
				
			TType.sym_Exe:
				node.add_Entry( parse_sec_Exe() )
				matched = true
				
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
		#endregion LP_Sectors
			
			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )
				matched = true

		if !matched:
			var literalNode = parse_expr_Element();
			if literalNode != null:
				node.add_Entry( literalNode )
				eat(TType.def_End)
				matched = true
				
		if !matched:
			var error = G.Error.new(false, "Failed to match token")
			G.throw(error)
			return null
			
	end(node)
	return node

#region Sectors
	
func parse_sec_Allocator() -> SNode:
	var node = Sec_Allocator.new()
	start(node)
	eat(TType.sym_Allocator)
	
	node.add_Entry( parse_expr_Call() )
	
	var result = chk_Tok( TType.def_Start )
	if result == null:
		end(node)
		return node
	
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var identifier 

			if Tok.Type == TType.sym_Identifier:
				identifier = parse_expr_Call()
				
			eat(TType.op_Define)

			var op = parse_sec_AllocatorOp(node, identifier)
			node.add_Entry(op)
		
		eat(TType.def_End)
		
	else:
		var identifier

		if Tok.Type == TType.sym_Identifier:
			identifier = parse_expr_Call()
			
		eat(TType.op_Define)
		
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
			opNode.add_Entry( identifier )
			eat(TType.op_Alloc)
			
			if Tok.Type == TType.cap_PStart:
				opNode.add_Entry( parse_expr_Capture() )
			
		TType.op_Resize:
			opNode.set_Type(SType.op_Resize)
			opNode.add_Entry( identifier )
			eat(TType.op_Resize)
			
			if Tok.Type == TType.cap_PStart:
				opNode.add_Entry( parse_expr_Capture() )
				
		TType.op_Free: 
			opNode.set_Type(SType.op_Free)
			opNode.add_Entry( identifier )
			eat(TType.op_Free)
			
		TType.op_Wipe: 
			opNode.set_Type(SType.op_Wipe)
			eat(TType.op_Wipe)

	end(opNode)
	return opNode

func parse_sec_Capture() -> SNode:
	var node = Sec_Capture.new()
	start(node)
	node.add_Entry( parse_sec_CaptureArgs() )
	
	if Tok == null:
		end(node)
		return node
	
	if Tok.Type == TType.op_Map:
		node.add_Entry( parse_sec_ReturnMap() )
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		end(node)
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			match Tok.Type:
				TType.cap_PStart:
					node.add_Entry( parse_sec_Capture() )
			
			#region LP_Sectors
				TType.sym_Exe:
					node.add_Entry( parse_sec_Exe() )
				
				TType.sec_If:
					node.add_Entry( parse_sec_Conditional() )
					
				TType.sym_RO:
					node.add_Entry( parse_sec_Readonly() )
					
				TType.sec_Static:
					node.add_Entry( parse_sec_Static() )
					
				TType.sec_Switch:
					node.add_Entry( parse_sec_Switch() )
				
				TType.sym_TT:
					node.add_Entry( parse_sec_TranslationTime() )
			#endregion LP_Sectors
					
				TType.sym_Identifier:
					node.add_Entry( parse_sec_Identifier() )

				_:
					var error = G.Error.new(false, "Failed to match token.")
					G.throw(error)
					return null
					
		eat(TType.def_End)
		
	else:
		match Tok.Type:
			TType.cap_PStart:
				node.add_Entry( parse_sec_Capture() )
			
		#region LP_Sectors
			TType.sym_Exe:
				node.add_Entry( parse_sec_Exe() )
				
			TType.sec_If:
				node.add_Entry( parse_sec_Conditional() )
				
			TType.sym_RO:
				node.add_Entry( parse_sec_Readonly() )
			
			TType.sec_Static:
				node.add_Entry( parse_sec_Static() )
				
			TType.sec_Switch:
				node.add_Entry( parse_sec_Switch() )
				
			TType.sym_TT:
				node.add_Entry( parse_sec_TranslationTime() )
		#endregion LP_Sectors
				
			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )

	end(node)
	return node
	
func parse_sec_CaptureArgs() -> SNode:
	var node = Sec_CaptureArgs.new()
	start(node)
	
	eat(TType.cap_PStart)
	
	while ! chk_Tok(TType.cap_PEnd):
		match Tok.Type:	
			TType.sym_Allocator:
				var symbol = parse_Simple(SType.sym_Allocator, TType.sym_Allocator)
				node.add_Entry( symbol )
				
			TType.sym_Self:
				var symbol = parse_Simple(SType.sym_Self, TType.sym_Self)
				node.add_Entry( symbol )
				
			TType.sym_Identifier:
				var symbols = []
				while Tok.Type == TType.sym_Identifier:
					symbols.append( parse_sym_Identifier() )
					
					if Tok.Type == TType.op_CD:
						eat(TType.op_CD)
				
					var type = parse_sec_Type(TType.op_Define)
					
					for symbol in symbols:
						symbol.add_Entry( type )
						
				for symbol in symbols:
					node.add_Entry( symbol )

		match chk_Tok(TType.op_CD):
			true: eat(TType.op_CD)
			null: end(node); return node
	
	eat(TType.cap_PEnd)
	end(node)
	return node

func parse_sec_Conditional() -> SNode:
	var node = Sec_Conditional.new()
	start(node)
	eat(TType.sec_If)
	
	node.add_Entry( parse_Expression() )
	
	parse_sec_ConditionalBody(node)
	
	if Tok && Tok.Type == TType.sec_Else:
		eat(TType.sec_Else)
		parse_sec_ConditionalBody(node)
		
	end(node)
	return node

func parse_sec_ConditionalBody(node):
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		return null
	
	eat(TType.def_Start)
	
	if result:
		while Tok.Type != TType.def_End:
			match Tok.Type:
				TType.cap_PStart:
					node.add_Entry( parse_sec_Capture() )
			
			#region LP_Sectors
				TType.sym_Exe:
					node.add_Entry( parse_sec_Exe() )
				
				TType.sec_If:
					node.add_Entry( parse_sec_Conditional() )
					
				TType.sym_RO:
					node.add_Entry( parse_sec_Readonly() )
					
				TType.sec_Switch:
					node.add_Entry( parse_sec_Switch() )
					
				TType.sec_Static:
					node.add_Entry( parse_sec_Static() )
				
				TType.sym_TT:
					node.add_Entry( parse_sec_TranslationTime() )
			#endregion LP_Sectors
					
				TType.sym_Identifier:
					node.add_Entry( parse_sec_Identifier() )

				_:
					var error = G.Error.new(false, "Failed to match token.")
					G.throw(error)
					return null
					
		eat(TType.def_End)
		
	else:
		match Tok.Type:
			TType.cap_PStart:
				node.add_Entry( parse_sec_Capture() )
			
		#region LP_Sectors
			TType.sym_Exe:
				node.add_Entry( parse_sec_Exe() )
				
			TType.sec_If:
				node.add_Entry( parse_sec_Conditional() )
				
			TType.sym_RO:
				node.add_Entry( parse_sec_Readonly() )
				
			TType.sec_Static:
				node.add_Entry( parse_sec_Static() )
				
			TType.sym_TT:
				node.add_Entry( parse_sec_TranslationTime() )
		#endregion LP_Sectors
					
			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )

			_:
				var error = G.Error.new(false, "Failed to match token.")
				G.throw(error)
				return null
	
func parse_sec_Enum() -> SNode:
	var node = Sec_Enum.new(); 
	start(node)
	eat(TType.sym_Enum)
	
	if Tok.Type == TType.cap_PStart:
		node.Data[0] = parse_expr_Capture()
	
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
				var error = G.Error.new(false, "Failed to match token.")
				G.throw(error)
				return null
				
		eat(TType.def_End)
		
	else:
		if Tok.Type == TType.sym_Identifier:
			node.add_Entry( parse_sec_EnumElement() )
	
	end(node)
	return node
	
func parse_sec_EnumElement() -> SNode:
	var node = Sec_EnumElement.new()
	start(node)
	node.add_Entry( parse_expr_Element() )
	
	if Tok.Type == TType.op_Assign:
		eat(TType.op_Assign)
		node.add_Entry( parse_expr_Element() )
		
	end(node)
	return node

func parse_sec_Exe() -> SNode:
	var node = SNode.new(SType.sec_Exe)
	node.Attributes[SType.sec_Exe] = true
	start(node)
	eat(TType.sym_Exe)
	
	if Tok.Type == TType.def_End:
		eat(TType.def_End)
		end(node)
		return node
	
	parse_sec_ExeBody(node)
	
	end(node)
	return node
		
func parse_sec_ExeBody(node):
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		return
		
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
				
				TType.sec_If:
					node.add_Entry( parse_sec_ExeConditional() )
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
					
				TType.sec_Stack:
					node.add_Entry( parse_sec_Stack() )
					matched = true
					
				TType.sec_Switch:
					node.add_Entry( parse_sec_ExeSwitch() )
					matched = true
			
			if ! matched:
				var expression = parse_Expression()
			
				if expression != null:
					node.add_Entry( expression )
					
		eat(TType.def_End)
		
	else:
		var matched = false
		match Tok.Type:
			TType.sym_Allocator:
				node.add_Entry( parse_sec_Allocator() )
				matched = true
								
			TType.sec_Heap:
				node.add_Entry( parse_sec_Heap() )
				matched = true	
		
			TType.sec_If:
				node.add_Entry( parse_sec_ExeConditional() )
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

		if ! matched:
			var expression = parse_Expression()
		
			if expression != null:
				node.add_Entry( expression )
				
	return

func parse_sec_ExeConditional() -> SNode:
	var node = Sec_ExeCond.new()
	start(node)
	eat(TType.sec_If)
	
	node.add_Entry( parse_Expression() )
	
	var ifBlock = SNode.new(SType.sec_Exe)
	parse_sec_ExeBody(ifBlock)
	node.add_Entry(ifBlock)
	
	if Tok.Type != TType.sec_Else:
		end(node)
		return node
		
	eat(TType.sec_Else)
		
	var elseBlock = SNode.new(SType.sec_Exe)
	parse_sec_ExeBody(elseBlock)
	node.add_Entry(elseBlock)
	
	end(node)
	return node

func parse_sec_ExeSwitch() -> SNode:
	var node = Sec_ExeSwitch.new()
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
			var \
			scNode = SNode.new(SType.sec_SwitchCase)
			scNode.add_Entry( parse_Expression() )
	
			parse_sec_ExeBody( scNode )
			node.add_Entry( scNode )
			
		eat(TType.def_End)
	
	else:
		var \
		scNode = SNode.new(SType.sec_SwitchCase)
		scNode.add_Entry( parse_Expression() )
	
		parse_sec_ExeBody( scNode )
		node.add_Entry( scNode )
	
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
				identifier = parse_expr_Call()
				
			eat(TType.op_Define)

			var op = parse_sec_AllocatorOp(node, identifier)
			node.add_Entry(op)
			
		eat( TType.def_End )
		
	else:
		var identifier

		if Tok.Type == TType.sym_Identifier:
			identifier = parse_expr_Call()
			
		eat(TType.op_Define)
		
		var op = parse_sec_AllocatorOp(node, identifier)
		node.add_Entry(op)
	
	end(node)
	return node

func parse_sec_Loop() -> SNode:
	var node = Sec_Loop.new()
	start(node)
	eat(TType.sec_Loop)
	
	if Tok.Type == TType.sec_If:
		var nCond = SNode.new( SType.sec_LoopCond )
		eat(TType.sec_If)
	
		nCond.add_Entry( parse_Expression() )
		node. add_Entry( nCond )
	
	parse_sec_ExeBody(node)
		
	end(node)
	return node
	
func parse_sec_Readonly() -> SNode:
	var node = SNode.new(SType.sec_RO)
	node.Attributes[SAttribute.sector] = true
	start(node)
	eat(TType.sym_RO)
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
		end(node)
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			match Tok.Type:
				TType.cap_PStart:
					node.add_Entry( parse_sec_Capture() )
					
			#region LP_Sectors
				TType.sec_If:
					node.add_Entry( parse_sec_Conditional() )
					
				TType.sec_Static:
					node.add_Entry( parse_sec_Static() )
			#endregion LP_Sectors
					
				TType.sym_Identifier:
					node.add_Entry( parse_sec_Identifier() )

				_:
					var error = G.Error.new(false, "Failed to match token.")
					G.throw(error)
					return null
					
		eat(TType.def_End)
		
	else:
		match Tok.Type:
			TType.cap_PStart:
				node.add_Entry( parse_sec_Capture() )
			
		#region LP_Sectors
			TType.sym_Exe:
				node.add_Entry( parse_sec_Exe() )
				
			TType.sec_If:
				node.add_Entry( parse_sec_Conditional() )
			
			TType.sec_Static:
				node.add_Entry( parse_sec_Static() )
		#endregion LP_Sectors

			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )

	end(node)
	return node
	
func parse_sec_ReturnMap() -> SNode:
	var node = Sec_ReturnMap.new()
	start(node)
	eat(TType.op_Map)
	
	match Tok.Type:
		TType.sym_gd_Bool   : node.add_Entry(SType.builtin_bool);   eat(TType.sym_gd_Bool)
		TType.sym_gd_Int    : node.add_Entry(SType.builtin_int);    eat(TType.sym_gd_Int)
		TType.sym_gd_Float  : node.add_Entry(SType.builtin_float);  eat(TType.sym_gd_Float)
		TType.sym_gd_String : node.add_Entry(SType.builtin_string); eat(TType.sym_gd_String)
		
		TType.sym_Identifier : node.add_Entry( parse_sym_Identifier() )
		TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
		TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
		TType.cap_SBStart    : node.add_Entry( parse_sym_Array() )
		TType.cap_PStart     : node.add_Entry( parse_Expression() )
		
	var result = chk_Tok( TType.def_Start )
	if result == null:
		end(node)
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			match Tok.Type:
				TType.cap_PStart:
					node.add_Entry( parse_sec_Capture() )

			#region LP_Sectors
				TType.sym_Exe:
					node.add_Entry( parse_sec_Exe() )
	
				TType.sec_Static:
					node.add_Entry( parse_sec_Static() )

				TType.sec_Switch:
					node.add_Entry( parse_sec_Switch() )
					
				TType.sym_TT:
					node.add_Entry( parse_sec_TranslationTime() )
			#endregion LP_Sectors

				TType.sym_Identifier:
					node.add_Entry( parse_sec_Identifier() )
	else:
		match Tok.Type:
			TType.cap_PStart:
				node.add_Entry( parse_sec_Capture() )

		#region LP_Sectors
			TType.sym_Exe:
				node.add_Entry( parse_sec_Exe() )
	
			TType.sec_Static:
				node.add_Entry( parse_sec_Static() )

			TType.sec_Switch:
				node.add_Entry( parse_sec_Switch() )
					
			TType.sym_TT:
				node.add_Entry( parse_sec_TranslationTime() )
		#endregion LP_Sectors

			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )
	
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
			
		eat( TType.def_End )
		
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
			
		eat( TType.def_End )
		
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
		var identifier = parse_sym_Identifier()
		var type       = parse_sec_Type(TType.op_Define)
		
		identifier.add_Entry( type )
		node.      add_Entry( identifier )
		
	eat(TType.def_End)
	
	end(node)
	return node
	
func parse_sec_StructUsing() -> SNode:
	return null

func parse_sec_Switch() -> SNode:
	var node = SNode.new(SType.sec_Switch)
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
			
		eat(TType.def_End)
	
	else:
		node.add_Entry( parse_sec_SwitchCase() )
	
	end(node)
	return node
	
func parse_sec_SwitchCase() -> SNode:
	var node = SNode.new(SType.sec_SwitchCase)
	start(node)
	node.add_Entry( parse_Expression() )
	
	var result = chk_Tok( TType.def_Start )
	if result == null:
		end(node)
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			match Tok.Type:
				TType.cap_PStart:
					node.add_Entry( parse_sec_Capture() )
						
			#region LP_Sectors
				TType.sec_If:
					node.add_Entry( parse_sec_Conditional() )
							
				TType.sym_Exe:
					node.add_Entry( parse_sec_Exe() )
							
				TType.sym_RO:
					node.add_Entry( parse_sec_Readonly() )
							
				TType.sec_Static:
					node.add_Entry( parse_sec_Static() )
							
				TType.sec_Switch:
					node.add_Entry( parse_sec_Switch() )
											
				TType.sym_TT:
					node.add_Entry( parse_sec_TranslationTime() )
				#endregion LP_Sectors
			
				TType.sym_Identifier:
					node.add_Entry( parse_sec_Identifier() )
						
		eat(TType.def_End)
		
	else:
		match Tok.Type:
			TType.cap_PStart:
				node.add_Entry( parse_sec_Capture() )
						
		#region LP_Sectors
			TType.sec_If:
				node.add_Entry( parse_sec_Conditional() )
							
			TType.sym_Exe:
				node.add_Entry( parse_sec_Exe() )
							
			TType.sym_RO:
				node.add_Entry( parse_sec_Readonly() )
							
			TType.sec_Static:
				node.add_Entry( parse_sec_Static() )
							
			TType.sec_Switch:
				node.add_Entry( parse_sec_Switch() )
											
			TType.sym_TT:
				node.add_Entry( parse_sec_TranslationTime() )
			#endregion LP_Sectors
			
			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )
	
	end(node)
	return node

func parse_sec_TranslationTime() -> SNode:
	var node = SNode.new(SType.sec_TT)
	start(node)
	eat(TType.sym_TT)

#	if G.check(Tok.Type == TType.sym_TT, "Next token should have been a translation time symbol"):
#		return node
#
#	node.add_TokVal(Tok)
	
	if Tok == null:
		end(node)
		return node
		
	# Check for body
	if Tok.Type == TType.def_Start:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			match Tok.Type:
			#region LP_Sectors	
				TType.sec_Static:
					node.add_Entry( parse_sec_Static() )
			#endregion LP_Sectors
				_:
					var error = G.Error.new(false, "Failed to match token.")
					G.throw(error)
					return null
					
		eat(TType.def_End)

	else:
		match Tok.Type:
		#region LP_Sectors
			TType.sec_Static:
				node.add_Entry( parse_sec_Static() )
		#endregion LP_Sectors

	end(node)
	return node

func parse_sec_Type(typeTok : String) -> SNode:
	var node = Sec_Type.new()
	start(node)

	if typeTok == TType.op_Define && Tok.Type == TType.op_A_Infer:
		pass
	else:
		eat(Tok.Type)

	if Tok == null:
		end(node)
		return node
	
	if Tok.Type == TType.op_A_Infer:
		eat(TType.op_A_Infer)
		
		match Tok.Type:
			TType.literal_Digit   : node.add_Entry(SType.builtin_int)
			TType.literal_Decimal : node.add_Entry(SType.builtin_float)
			TType.literal_String  : node.add_Entry(SType.builtin_string)
			TType.literal_Char    : node.add_Entry(SType.builtin_string)
			TType.literal_True    : node.add_Entry(SType.builtin_bool)
			TType.literal_False   : node.add_Entry(SType.builtin_bool)
			TType.literal_Binary  : node.add_Entry(SType.builtin_int)
			TType.literal_Octal   : node.add_Entry(SType.builtin_int)
			TType.literal_Hex     : node.add_Entry(SType.builtin_int)

		node.add_Entry( parse_expr_Element() )

	else:
		match Tok.Type:
			TType.sym_gd_Bool   : node.add_Entry(SType.builtin_bool);   eat(TType.sym_gd_Bool)
			TType.sym_gd_Int    : node.add_Entry(SType.builtin_int);    eat(TType.sym_gd_Int)
			TType.sym_gd_Float  : node.add_Entry(SType.builtin_float);  eat(TType.sym_gd_Float)
			TType.sym_gd_String : node.add_Entry(SType.builtin_string); eat(TType.sym_gd_String)
		
			TType.sym_Identifier : node.add_Entry( parse_expr_Call() )
			TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
			TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
			TType.cap_SBStart    : node.add_Entry( parse_sym_Array() )
			TType.sym_TT         : node.add_Entry( parse_sym_TT_Type() )

		if Tok && Tok.Type == TType.op_Assign:
			eat(TType.op_Assign)
			
			node.add_Entry( parse_Expression() )

	end(node)
	return node

func parse_sec_Union() -> SNode:
	var node = SNode.new(SType.sec_Union)
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
		
	eat(TType.def_End)
	
	end(node)
	return node

func parse_sec_Using() -> SNode:
	var node = SNode.new(SType.sec_Using)
	start(node)
	eat(TType.sec_Using)
	
	end(node)
	return node

func parse_sec_Identifier() -> SNode:
	var node = Sec_Identifier.new()
	start(node)

	if G.check(Tok.Type == TType.sym_Identifier, "Next token should have been an identifier symbol"):
		end(node)
		return node
		
	node.add_TokVal(Tok)
	eat(TType.sym_Identifier)
	
	if Tok == null || Tok.Type == TType.def_End:
		eat(TType.def_End)
		end(node)
		return node
		
	# Check for body
	if Tok.Type == TType.def_Start:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			match Tok.Type:
				TType.cap_PStart:
					node.add_Entry( parse_sec_Capture() )
					
				TType.op_Map:
					node.add_Entry( parse_sec_ReturnMap() )
				
			#region LP_Sectors
				TType.sym_Enum:
					node.add_Entry( parse_sec_Enum() )
					
				TType.sym_Exe:
					node.add_Entry( parse_sec_Exe() )
					
				TType.sym_RO:
					node.add_Entry( parse_sec_Readonly() )
					
				TType.sec_Static:
					node.add_Entry( parse_sec_Static() )
					
				TType.sec_Struct:
					node.add_Entry( parse_sec_Struct() )
				
				TType.sec_Switch:
					node.add_Entry( parse_sec_Switch() )
					
				TType.sym_TT:
					node.add_Entry( parse_sec_TranslationTime() )
			#endregion LP_Sectors

				TType.sym_Identifier:
					node.add_Entry( parse_sec_Identifier() )
					
				TType.sym_Type:
					node.add_Entry( parse_sec_Type(TType.sym_Type) )
				
				TType.sec_Union:
					node.add_Entry( parse_sec_Union() )
					
				_:
					var error = G.Error.new(false, "Failed to match token.")
					G.throw(error)
					return null
					
		eat(TType.def_End)

	else:
		match Tok.Type:
			TType.cap_PStart:
				node.add_Entry( parse_sec_Capture() )
				
			TType.op_Map:
				node.add_Entry( parse_sec_ReturnMap() )
				
		#region LP_Sectors
			TType.sym_Enum:
				node.add_Entry( parse_sec_Enum() )
				
			TType.sym_Exe:
				node.add_Entry( parse_sec_Exe() )
				
			TType.sym_RO:
				node.add_Entry( parse_sec_Readonly() )
				
			TType.sec_Struct:
				node.add_Entry( parse_sec_Struct() )
			
			TType.sec_Static:
				node.add_Entry( parse_sec_Static() )
			
			TType.sec_Switch:
				node.add_Entry( parse_sec_Switch() )
				
			TType.sym_TT:
				node.add_Entry( parse_sec_TranslationTime() )
		#endregion LP_Sectors
		
			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )
							
			TType.sym_Type:
				node.add_Entry( parse_sec_Type(TType.sym_Type) )
			
			TType.sec_Union:
				node.add_Entry( parse_sec_Union() )

	end(node)
	return node
#endregion Sectors

#region Expressions
func parse_Expression() -> SNode:
	return parse_expr_Delimited()
	
func parse_expr_Binary_tok(elementFn : Callable, tType : String, SType) -> SNode:
	var left = elementFn.call()
	
	# If there is no assign its just an element.
#	if Tok == null || Tok.Type != tType:
#		return left
#
#	eat(tType)
#
#	var right = parse_Expression()
#
#	var \
#	node = SNode.new(SType)
#	node.add_Entry(left)
#	node.add_Entry(right)
	
	var   result = Tok != null && Tok.Type == tType
	while result:
		eat(Tok.Type)
	
		var right = parse_Expression()
		
		var \
		node = SNode.new(result)
		node.add_Entry(left)
		node.add_Entry(right)
		
		node.Span.Start = left.Span.Start
		node.Span.End   = right.Span.End
		
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
		
		node.Span.Start = left.Span.Start
		node.Span.End   = right.Span.End
		
		left   = node
		result = op.call()
	
	return left

# Sorted by precedence (First is highest)
	
func parse_expr_Element() -> SNode:
	var matched = false
	match Tok.Type:
		TType.op_Alloc  : return parse_Simple(SType.op_Alloc,  TType.op_Alloc)
		TType.op_Resize : return parse_Simple(SType.op_Resize, TType.op_Resize)
		TType.op_Free   : return parse_Simple(SType.op_Free,   TType.op_Free)
		TType.op_Wipe   : return parse_Simple(SType.op_Wipe,   TType.op_Wipe)
		
		TType.sym_Ptr : return parse_Simple(SType.op_Ptr, TType.sym_Ptr)
		TType.sym_LP  : return parse_Simple(SType.sym_LP, TType.sym_LP)
			
		TType.sym_Identifier:
			return parse_sym_Identifier()
			
		TType.sym_gd_Bool   : return parse_Simple(SType.builtin_bool,   TType.sym_gd_Bool);
		TType.sym_gd_Int    : return parse_Simple(SType.builtin_int,    TType.sym_gd_Int);
		TType.sym_gd_Float  : return parse_Simple(SType.builtin_float,  TType.sym_gd_Float);
		TType.sym_gd_String : return parse_Simple(SType.builtin_string, TType.sym_gd_String);
		
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
	
	var assertStrTmplt = "Could not match token in parse_expr_Element! : {value} - {type} }"
	var assertStr      = assertStrTmplt.format({"value" : Tok.Value, "type" : Tok.Type})
		
	G.check(false, assertStr)
	return null
	
func parse_expr_SMA() -> SNode:
	if Tok.Type == TType.op_SMA:
		var start = Tok.Start
		eat(TType.op_SMA)
		
		var \
		node = SNode.new(SType.op_SMA)
		node.add_Entry( parse_expr_Call() )
		node.Span.Start = start
		end(node)
		return node

	var element = parse_expr_Element()
		
	if Tok && Tok.Type == TType.op_SMA:
		var start = Tok.Start
		eat(TType.op_SMA)
		
		var \
		node = SNode.new(SType.op_SMA)
		node.add_Entry(element)
		node.add_Entry( parse_expr_Call() )
		node.Span.Start = start
		end(node)
		return node
	
	return element;

func parse_expr_SBCap() -> SNode:
	var left = parse_expr_Cast()
	
	if Tok == null || Tok.Type != TType.cap_SBStart:
		return left
		
	var node = SNode.new(SType.expr_SBCap)
	start(node)
	eat(TType.cap_SBStart)
	
	node.add_Entry(left)
	node.add_Entry(parse_Expression())
	eat(TType.cap_SBEnd)
	
	if Tok.Type == TType.op_SMA:
		node.add_Entry( parse_expr_SMA() )
	
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

func parse_expr_CastCapture() -> SNode:
	return null

func op_Callable(node):
	match node.type():
		SType.expr_SBCap     : return true
		SType.op_Cast        : return true
		SType.sym_Identifier : return true
		_:
			return false

func parse_expr_Call() -> SNode:
	var element = parse_expr_SBCap()

	if op_Callable(element) && Tok.Type == TType.cap_PStart:
		var \
		node = SNode.new(SType.op_Call)
		node.add_Entry( element )
		node.add_Entry( parse_expr_Capture() )
		node.Span.Start = element.Start
	
		end(node)
		return node
		
	return element
	
func parse_expr_Capture() -> SNode:
	var node = SNode.new(SType.expr_Cap)
	start(node)
	
	eat(TType.cap_PStart)
	var expression = parse_Expression()
	eat(TType.cap_PEnd)
	
	node.add_Entry(expression)
	end(node)
	return node
	
func op_Unary():
	if Tok == null:
		return null
	
	match Tok.Type:
		TType.sym_Ptr     : return SType.sym_Ptr
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
			return parse_expr_Call()
		
	var node = SNode.new(operator)
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
		TType.op_Assign : return SType.op_Assign
		TType.op_A_Add  : return SType.op_A_Add
		_:
			return null
	
func parse_expr_Assignment() -> SNode:
	return parse_expr_Binary(parse_expr_LogicalOr, op_Assignment())
	
func parse_expr_Delimited() -> SNode:
	return parse_expr_Binary_tok(parse_expr_Assignment, TType.op_CD, SType.op_CD)
#endregion Expressions

func parse_sym_Array() -> SNode:
	var node = SNode.new(SType.sym_Array)
	start(node)
	
	eat(TType.cap_SBStart)
	node.add_Entry( parse_Expression() )
	eat(TType.cap_SBEnd)
	
	match Tok.Type:
		TType.sym_Type : node.add_Entry(SType.sym_TType); eat(TType.sym_Type)
		
		TType.sym_gd_Bool   : node.add_Entry(SType.builtin_bool);   eat(TType.sym_gd_Bool)
		TType.sym_gd_Int    : node.add_Entry(SType.builtin_int);    eat(TType.sym_gd_Int)
		TType.sym_gd_Float  : node.add_Entry(SType.builtin_float);  eat(TType.sym_gd_Float)
		TType.sym_gd_String : node.add_Entry(SType.builtin_string); eat(TType.sym_gd_String)
		
		TType.sym_Identifier : node.add_Entry( parse_expr_Call() )
		TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
		TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
		TType.cap_SBStart    : node.add_Entry( parse_sym_Array() )
	
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
	var node = SNode.new(SType.sym_Proc)
	start(node)
	eat(TType.sym_Exe)
	
	if Tok.Type == TType.cap_PStart:
		node.add_Entry( parse_sec_CaptureArgs() )
	
	if Tok.Type == TType.op_Map:
		node.add_Entry( parse_sec_ReturnMap() )
			
	end(node)
	return node
	
func parse_sym_Ptr() -> SNode:
	var node = SNode.new(SType.sym_Ptr)
	start(node)
	eat(TType.sym_Ptr)
	
	match Tok.Type:
		TType.sym_gd_Bool   : node.add_Entry(SType.builtin_bool);   eat(TType.sym_gd_Bool)
		TType.sym_gd_Int    : node.add_Entry(SType.builtin_int);    eat(TType.sym_gd_Int)
		TType.sym_gd_Float  : node.add_Entry(SType.builtin_float);  eat(TType.sym_gd_Float)
		TType.sym_gd_String : node.add_Entry(SType.builtin_string); eat(TType.sym_gd_String)
		
		TType.sym_Identifier : node.add_Entry( parse_expr_Call() )
		TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
		TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
		TType.cap_SBStart    : node.add_Entry( parse_sym_Array() )
#		TType.sym_Type       : node.add_Entry( parse_Simple(SType.sym_TType, TType.sym_Type) )
	
	end(node)
	return node

func parse_sym_Type(token = null) -> SNode:
	var node = SNode.new(SType.sym_Type)
	start(node)
	
	if token:	
		eat(TType.sym_Type)

	match Tok.Type:
		TType.sym_Type : node.add_Entry(SType.sym_TType); eat(TType.sym_Type)

		TType.sym_gd_Bool   : node.add_Entry(SType.builtin_bool);   eat(TType.sym_gd_Bool)
		TType.sym_gd_Int    : node.add_Entry(SType.builtin_int);    eat(TType.sym_gd_Int)
		TType.sym_gd_Float  : node.add_Entry(SType.builtin_float);  eat(TType.sym_gd_Float)
		TType.sym_gd_String : node.add_Entry(SType.builtin_string); eat(TType.sym_gd_String)

		TType.sym_Identifier : node.add_Entry( parse_expr_Call() )
		TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
		TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
		TType.cap_SBStart    : node.add_Entry( parse_sym_Array() )
		
	end(node)
	return node

func parse_sym_TT_Type() -> SNode:
	var node = SNode.new(SType.sym_TT_Type)
	start(node)
	eat(TType.sym_TT)
	
	match Tok.Type:
		TType.sym_Type : node.add_Entry(SType.sym_TType); eat(TType.sym_Type)
		
		TType.sym_gd_Bool   : node.add_Entry(SType.builtin_bool);   eat(TType.sym_gd_Bool)
		TType.sym_gd_Int    : node.add_Entry(SType.builtin_int);    eat(TType.sym_gd_Int)
		TType.sym_gd_Float  : node.add_Entry(SType.builtin_float);  eat(TType.sym_gd_Float)
		TType.sym_gd_String : node.add_Entry(SType.builtin_string); eat(TType.sym_gd_String)
		
		TType.sym_Identifier : node.add_Entry( parse_expr_Call() )
		TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
		TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
		TType.cap_SBStart    : node.add_Entry( parse_sym_Array() )

	end(node)
	return node
	
func parse_op_Break() -> SNode:
	var node = SNode.new(SType.op_Break)
	start(node)
	
	eat(TType.op_Break)
	
	end(node)
	return node

func parse_op_Return() -> SNode:
	var node = SNode.new(SType.op_Return)
	start(node)
	eat(TType.op_Return)
	
	if Tok.Type == TType.def_End:
		return node
	
	match Tok.Type:
		_:
			node.add_Entry( parse_Expression() )

	end(node)
	return node

func parse_Simple(SType, tType) -> SNode:
	var node = SNode.new(SType)
	start(node)
	eat(tType)
	end(node)
	return node

func parse_Literal(SType, tType) -> SNode:
	var node = SNode.new(SType)
	start(node)
	
	node.add_TokVal(Tok)
	eat(tType)
	
	end(node)
	return node
	
func parse_TokValue(SType, tType) -> SNode:
	var node = SNode.new(SType)
	start(node)
	
	node.add_TokVal(Tok)
	eat(tType
	)
	end(node)
	return node
	
#region Object
func _init( lexer : Lexer ) -> void:
	Lex = lexer
#endregion Object
