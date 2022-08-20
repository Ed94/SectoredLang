class_name SyntaxParser extends Object

# NOTE:
# The parser  model used here may be able to generate an ast that the interpreter at the 
# "GDScript level" of implementation will not be able to support (Or possibly LLVM for that matter).
# So those nodes will not be supported on the demo langauge platform.
 
const NType = \
{
	empty = "Empty Statement",
	unit = "Module Unit",
	
	enum_Element = "Enumeration Element",

	expr       = "Expression",
	expr_Cap   = "Capture",
	expr_SBCap = "Bracketed Capture",
	
	op_Call   = "Op: Call",
	op_CD     = "Op: Comma Delimiter",
	op_Ptr    = "Op: Address Of (Get Pointer)",
	op_SMA    = "Op: Member Resolution",
	
	op_Break  = "Op: Break",
	op_Cast   = "Op: Cast",
	op_Return = "Op: Return",
	
	op_Alloc   = "Op: Allocate",
	op_Dealloc = "Op: Deallocate",
	
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
	
	sec_Allocator  = "Sector: Allocator",
	sec_Cap        = "Sector: Capture",
	sec_CapArgs    = "Capture Sector - Arguments",
	sec_CapRet     = "Capture Sector - Return Map",
	sec_Cond       = "Secotr: Conditional",
	sec_Enum       = "Sector: Enum",
	sec_Exe        = "Sector: Execution",
	sec_Heap       = "Sector: Heap",
	sec_LP         = "Sector: Langauge Platform",
	sec_Loop       = "Sector: Loop",
	sec_LoopCond   = "Loop Sector - Conditional",
	sec_RO         = "Sector: Readonly",
	sec_Stack      = "Sector: Stack",
	sec_Static     = "Sector: Static",
	sec_Struct     = "Sector: Struct",
	sec_Switch     = "Sector: Switch",
	sec_SwitchCase = "Switch Sector - Case",
	sec_TT         = "Sector: Translation Time",
	sec_Type       = "Sector: Type",
	sec_Union      = "Sector: Union",
	sec_Using      = "Sector: Using",
	sec_Identifier = "Sector: Identifier",
	
	builtin_bool   = "GD: bool",
	builtin_int    = "GD: int",
	builtin_float  = "GD: float",
	builtin_Array  = "GD: Array",
	builtin_Dict   = "GD: Dictionary",
	builtin_string = "GD: String",
	
	sym_Array      = "Symbol: Array",
	sym_LP         = "Symbol: Language Platform",
	sym_Proc       = "Symbol: Procedure",
	sym_Ptr        = "Symbol: Pointer",
	sym_Self       = "Symbol: Self",
	sym_TType      = "Symbol: Top Type",
	sym_TT_Type    = "Symbol: Translation Time Type",

	sym_Identifier = "Symbol: Identifier",
}

class ASTNode:
	var Data : Array

# Methods
	func add_Entry( entry ) -> void:
		Data.append( entry )

	func add_TokVal( token ) -> void:
		Data.append( token.Value )

	func entry( id ):
		return Data[id]
		
	func num_Entries() -> int:
		return Data.size() - 1
		
	func string() -> String:
		return entry(1).substr(1, entry(1).length() - 2)
				
	func set_Type( nType ) -> void:
		Data.append( nType )
				
	func type():
		if G.check(Data.size() > 0, "ASTNode " + str(get_instance_id()) + " : Node does not have a type!"):
			return null
		
		return Data[0]
# End Methods
	
#region Serialization
	func array_Serialize(array) -> Array:
		var result = []

		for entry in array :
			if typeof(entry) == TYPE_ARRAY :
				result.append( array_Serialize( entry ) )

			elif typeof(entry) == TYPE_OBJECT :
				if entry.get_class() ==  "Eve":
					result.append(entry)
				else:
					result.append( entry.to_SExpression() )

			else :
				result.append( entry )
				
		return result

	func to_SExpression() -> Array:
		return array_Serialize( self.Data )
#endregion Serialization
	
#region Object
	func get_class():
		return "ASTNode"

	func _init(type =  ""):
		if type != "":
			set_Type(type)
#endregion Object



const TType = Lexer.TType
var   Lex   : Lexer
var   Tok

func chk_Tok( tokenType ):
	if G.check(Tok != null, "Tok is null!"):
		return null
		
	return Tok.Type == tokenType

# Gets the next token only if the current token is the specified intended token (tokenType)
func eat( tokenType ):
	var currToken = Tok
	
	if G.check(currToken != null, "Tok was null"):
		return null
	
	var assertStrTmplt = "Unexpected token: {value} , expected: {type}"
	var assertStr      = assertStrTmplt.format({"value" : currToken.Value, "type" : tokenType})
		
	if G.check(currToken.Type == tokenType, assertStr):
		Tok = null
		return null
	
	Tok = Lex.next_Token()
	
	return currToken

func parse_unit() -> ASTNode:
	Tok = Lex.next_Token()
	
	var node = ASTNode.new(NType.unit)
	
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
			
	return node

#region Sectors
	
func parse_sec_Allocator() -> ASTNode:
	var node = ASTNode.new( NType.sec_Allocator )
	eat(TType.sym_Allocator)
	
	node.add_Entry( parse_expr_Call() )
	
	var result = chk_Tok( TType.def_Start )
	if result == null:
		return node
	
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var identifier 

			if Tok.Type == TType.sym_Identifier:
				identifier = parse_expr_Call()

			var op = parse_sec_AllocatorOp()
			
			node.add_Entry(identifier)
			node.add_Entry(op)
		
		eat(TType.def_End)
		
	else:
		var identifier

		if Tok.Type == TType.sym_Identifier:
			identifier = parse_expr_Call()

		var op = parse_sec_AllocatorOp()
			
		node.add_Entry(identifier)
		node.add_Entry(op)
	
	return node
	
func parse_sec_AllocatorOp() -> ASTNode:
	eat(TType.op_Define)
	
	var node = ASTNode.new(Tok.Type)
	
	match Tok.Type:
		TType.op_Alloc:
			eat(TType.op_Alloc)
			
			if Tok.Type == TType.cap_PStart:
				node.add_Entry( parse_expr_Capture() )
			
		TType.op_Resize:
			eat(TType.op_Resize)
			
			if Tok.Type == TType.cap_PStart:
				node.add_Entry( parse_expr_Capture() )
				
		TType.op_Free: eat(TType.op_Free)
		TType.op_Wipe: eat(TType.op_Wipe)
	
	return node

func parse_sec_Capture() -> ASTNode:
	var \
	node = ASTNode.new(NType.sec_Cap)
	node.add_Entry( parse_sec_CaptureArgs() )
	
	if Tok == null:
		return node
	
	if Tok.Type == TType.op_Map:
		node.add_Entry( parse_sec_CaptureReturnMap() )
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
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

	return node
	
func parse_sec_CaptureArgs() -> ASTNode:
	var node = ASTNode.new(NType.sec_CapArgs)
	
	eat(TType.cap_PStart)
	
	while ! chk_Tok(TType.cap_PEnd):
		match Tok.Type:	
			TType.sym_Self:
				var symbol = parse_Simple(NType.sym_Self, TType.sym_Self)
				node.add_Entry( symbol )
				
			TType.sym_Identifier:
				var symbols = []
				while Tok.Type == TType.sym_Identifier:
					symbols.append( parse_sym_Identifier() )
				
				if Tok.Type != TType.op_CD:
					var type = parse_sec_Type(TType.op_Define)
					
					for symbol in symbols:
						symbol.add_Entry( type )
						
				for symbol in symbols:
					node.add_Entry( symbol )

		match chk_Tok(TType.op_CD):
			true: eat(TType.op_CD)
			null: return node
	
	eat(TType.cap_PEnd)
	
	return node
	
func parse_sec_CaptureReturnMap() -> ASTNode:
	var \
	node = ASTNode.new(NType.sec_CapRet)
	eat(TType.op_Map)
	
	match Tok.Type:
		TType.sym_gd_Bool   : node.add_Entry(NType.builtin_bool);   eat(TType.sym_gd_Bool)
		TType.sym_gd_Int    : node.add_Entry(NType.builtin_int);    eat(TType.sym_gd_Int)
		TType.sym_gd_Float  : node.add_Entry(NType.builtin_float);  eat(TType.sym_gd_Float)
		TType.sym_gd_String : node.add_Entry(NType.builtin_string); eat(TType.sym_gd_String)
		
		TType.sym_Identifier : node.add_Entry( parse_sym_Identifier() )
		TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
		TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
		TType.cap_SBStart    : node.add_Entry( parse_sym_CapSB() )
		TType.cap_PStart     : node.add_Entry( parse_Expression() )
		
	var result = chk_Tok( TType.def_Start )
	if result == null:
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
					
	return node

func parse_sec_Conditional() -> ASTNode:
	var node = ASTNode.new( NType.sec_Cond )
	eat(TType.sec_If)
	
	node.add_Entry( parse_Expression() )
	
	parse_sec_ConditionalBody(node)
	
	if Tok && Tok.Type == TType.sec_Else:
		parse_sec_ConditionalBody(node)

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
	
func parse_sec_Enum() -> ASTNode:
	var node = ASTNode.new(NType.sec_Enum)
	eat(TType.sym_Enum)
	
	if Tok.Type == TType.cap_PStart:
		node.add_Entry( parse_expr_Capture() )
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
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
		
	return node
	
func parse_sec_EnumElement() -> ASTNode:
	var \
	node = ASTNode.new(NType.enum_Element)
	node.add_Entry( parse_expr_Element() )
	
	if Tok.Type == TType.op_Assign:
		eat(TType.op_Assign)
		node.add_Entry( parse_expr_Element() )
		
	return node

func parse_sec_Exe() -> ASTNode:
	var \
	node = ASTNode.new(NType.sec_Exe)
	eat(TType.sym_Exe)
	
	if Tok.Type == TType.def_End:
		eat(TType.def_End)
		return node
	
	parse_sec_ExeBody(node)
	
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

func parse_sec_ExeConditional() -> ASTNode:
	var node = ASTNode.new(NType.sec_Cond)
	eat(TType.sec_If)
	
	node.add_Entry( parse_Expression() )
	
	var ifBlock = ASTNode.new(NType.sec_Exe)
	parse_sec_ExeBody(ifBlock)
	node.add_Entry(ifBlock)
	
	if Tok.Type != TType.sec_Else:
		return node
		
	eat(TType.sec_Else)
		
	var elseBlock = ASTNode.new(NType.sec_Exe)
	parse_sec_ExeBody(elseBlock)
	node.add_Entry(elseBlock)
	
	return node

func parse_sec_ExeSwitch() -> ASTNode:
	var node = ASTNode.new(NType.sec_Switch)
	eat(TType.sec_Switch)
	
	node.add_Entry( parse_Expression() )
	
	var result = chk_Tok( TType.def_Start )
	if  result == null:
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var \
			scNode = ASTNode.new(NType.sec_SwitchCase)
			scNode.add_Entry( parse_Expression() )
	
			parse_sec_ExeBody( scNode )
			node.add_Entry( scNode )
			
		eat(TType.def_End)
	
	else:
		var \
		scNode = ASTNode.new(NType.sec_SwitchCase)
		scNode.add_Entry( parse_Expression() )
	
		parse_sec_ExeBody( scNode )
		node.add_Entry( scNode )
	
	return node

func parse_sec_Heap() -> ASTNode:
	var node = ASTNode.new( NType.sec_Heap )
	eat(TType.sec_Heap)
	
	var result = chk_Tok( TType.def_Start )
	if  result == null:
		return node
	
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var identifier = parse_sym_Identifier()
			var op         = parse_sec_AllocatorOp()
			
			node.add_Entry(identifier)
			node.add_Entry(op)
			
		eat( TType.def_End )
		
	else:
		var identifier = parse_sym_Identifier()
		var op         = parse_sec_AllocatorOp()
			
		node.add_Entry(identifier)
		node.add_Entry(op)
	
	return node

func parse_sec_Loop() -> ASTNode:
	var node = ASTNode.new(NType.sec_Loop)
	eat(TType.sec_Loop)
	
	if Tok.Type == TType.sec_If:
		var nCond = ASTNode.new( NType.sec_LoopCond )
		eat(TType.sec_If)
	
		nCond.add_Entry( parse_Expression() )
		node. add_Entry( nCond )
	
	parse_sec_ExeBody(node)
		
	return node
	
func parse_sec_Readonly() -> ASTNode:
	var node = ASTNode.new(NType.sec_RO)
	eat(TType.sym_RO)
	
	var result = chk_Tok(TType.def_Start)
	if  result == null:
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

	return node

func parse_sec_Stack() -> ASTNode:
	var node = ASTNode.new(NType.sec_Stack)
	eat(TType.sec_Stack)
	
	var result = chk_Tok( TType.def_Start )
	if  result == null:
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
	
	return node

func parse_sec_Static() -> ASTNode:
	var node = ASTNode.new( NType.sec_Static )
	eat(TType.sec_Static)
	
	var result = chk_Tok( TType.def_Start )
	if  result == null:
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
	
	return node
	
func parse_sec_Struct() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Struct)
	eat(TType.sec_Struct)
	
	var result = chk_Tok( TType.def_Start )
	if  result == null || result == false:
		return node
		
	eat(TType.def_Start)
	
	while !chk_Tok(TType.def_End):
		var identifier = parse_sym_Identifier()
		var type       = parse_sec_Type(TType.op_Define)
		
		identifier.add_Entry( type )
		node.      add_Entry( identifier )
		
	eat(TType.def_End)
	
	return node

func parse_sec_Switch() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Switch)
	eat(TType.sec_Switch)
	
	node.add_Entry( parse_Expression() )
		
	var result = chk_Tok( TType.def_Start )
	if  result == null:
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			node.add_Entry( parse_sec_SwitchCase() )
			
		eat(TType.def_End)
	
	else:
		node.add_Entry( parse_sec_SwitchCase() )
	
	return node
	
func parse_sec_SwitchCase() -> ASTNode:
	var \
	node = ASTNode.new(NType.sec_SwitchCase)
	node.add_Entry( parse_Expression() )
	
	var result = chk_Tok( TType.def_Start )
	if result == null:
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
	
	return node

func parse_sec_TranslationTime() -> ASTNode:
	var node = ASTNode.new(NType.sec_TT)

	if G.check(Tok.Type == TType.sym_TT, "Next token should have been a translation time symbol"):
		return node
		
	node.add_TokVal(Tok)
	eat(TType.sym_TT)
	
	if Tok == null:
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

	return node

func parse_sec_Type(typeTok : String) -> ASTNode:
	var node = ASTNode.new(NType.sec_Type)

	if typeTok == TType.op_Define && Tok.Type == TType.op_A_Infer:
		pass
	else:
		eat(Tok.Type)

	if Tok == null:
		return node
	
	if Tok.Type == TType.op_A_Infer:
		eat(TType.op_A_Infer)
		
		match Tok.Type:
			TType.literal_Digit   : node.add_Entry(NType.builtin_int)
			TType.literal_Decimal : node.add_Entry(NType.builtin_float)
			TType.literal_String  : node.add_Entry(NType.builtin_string)
			TType.literal_Char    : node.add_Entry(NType.builtin_string)
			TType.literal_True    : node.add_Entry(NType.builtin_bool)
			TType.literal_False   : node.add_Entry(NType.builtin_bool)
			TType.literal_Binary  : node.add_Entry(NType.builtin_int)
			TType.literal_Octal   : node.add_Entry(NType.builtin_int)
			TType.literal_Hex     : node.add_Entry(NType.builtin_int)

		node.add_Entry( parse_expr_Element() )

	else:
		match Tok.Type:
			TType.sym_gd_Bool   : node.add_Entry(NType.builtin_bool);   eat(TType.sym_gd_Bool)
			TType.sym_gd_Int    : node.add_Entry(NType.builtin_int);    eat(TType.sym_gd_Int)
			TType.sym_gd_Float  : node.add_Entry(NType.builtin_float);  eat(TType.sym_gd_Float)
			TType.sym_gd_String : node.add_Entry(NType.builtin_string); eat(TType.sym_gd_String)
		
			TType.sym_Identifier : node.add_Entry( parse_expr_Call() )
			TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
			TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
			TType.cap_SBStart    : node.add_Entry( parse_sym_CapSB() )
			TType.sym_TT         : node.add_Entry( parse_sym_TT_Type() )

		if Tok && Tok.Type == TType.op_Assign:
			eat(TType.op_Assign)
			
			node.add_Entry( parse_Expression() )

	return node

func parse_sec_Union() -> ASTNode:
	var node = ASTNode.new(NType.sec_Union)
	eat(TType.sec_Union)
	
	if Tok.Type == TType.cap_PStart:
		eat(TType.cap_PStart)
		node.add_Entry( parse_sym_Identifier() )
		eat(TType.cap_PEnd)
	
	var result = chk_Tok( TType.def_Start )
	if  result == null || result == false:
		return node
		
	eat(TType.def_Start)
	
	while !chk_Tok(TType.def_End):
		var identifier = parse_sym_Identifier()
		var type       = parse_sec_Type(TType.op_Define)
		
		identifier.add_Entry( type )
		node.      add_Entry( identifier )
		
	eat(TType.def_End)
	
	return node

func parse_sec_Using() -> ASTNode:
	var node = ASTNode.new(NType.sec_Using)
	eat(TType.sec_Using)
	
	return node

func parse_sec_Identifier() -> ASTNode:
	var node = ASTNode.new( NType.sec_Identifier )

	if G.check(Tok.Type == TType.sym_Identifier, "Next token should have been an identifier symbol"):
		return node
		
	node.add_TokVal(Tok)
	eat(TType.sym_Identifier)
	
	if Tok == null || Tok.Type == TType.def_End:
		eat(TType.def_End)
		return node
		
	# Check for body
	if Tok.Type == TType.def_Start:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			match Tok.Type:
				TType.cap_PStart:
					node.add_Entry( parse_sec_Capture() )
					
				TType.op_Map:
					node.add_Entry( parse_sec_CaptureReturnMap() )
				
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
				node.add_Entry( parse_sec_CaptureReturnMap() )
				
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

	return node
#endregion Sectors

#region Expressions
func parse_Expression() -> ASTNode:
	return parse_expr_Delimited()
	
func parse_expr_Binary_tok(elementFn : Callable, tType : String, nType) -> ASTNode:
	var left = elementFn.call()
	
	# If there is no assign its just an element.
	if Tok == null || Tok.Type != tType:
		return left
		
	eat(tType)
	
	var right = parse_Expression()
	
	var \
	node = ASTNode.new(nType)
	node.add_Entry(left)
	node.add_Entry(right)
	
	return node
	
func parse_expr_Binary(elementFn : Callable, op_CheckFn : Callable) -> ASTNode:
	var left = elementFn.call()

	var   result = op_CheckFn.call()
	while result:
		eat(Tok.Type)
	
		var right = parse_Expression()
		
		var \
		node = ASTNode.new(result)
		node.add_Entry(left)
		node.add_Entry(right)
		
		left   = node
		result = op_CheckFn.call()
	
	return left

# Sorted by precedence (First is highest)
	
func parse_expr_Element() -> ASTNode:
	var matched = false
	match Tok.Type:
		TType.sym_Ptr : return parse_Simple(NType.op_Ptr, TType.sym_Ptr)
		TType.sym_LP  : return parse_Simple(NType.sym_LP, TType.sym_LP)
			
		TType.sym_Identifier:
			return parse_sym_Identifier()
			
		TType.sym_gd_Bool   : return parse_Simple(NType.builtin_bool,   TType.sym_gd_Bool);
		TType.sym_gd_Int    : return parse_Simple(NType.builtin_int,    TType.sym_gd_Int);
		TType.sym_gd_Float  : return parse_Simple(NType.builtin_float,  TType.sym_gd_Float);
		TType.sym_gd_String : return parse_Simple(NType.builtin_string, TType.sym_gd_String);
		
		# Literal detection needs to be moved to its own block...
		TType.literal_String  : return parse_Literal(NType.literal_String,  TType.literal_String)
		TType.literal_Digit   : return parse_Literal(NType.literal_Digit,   TType.literal_Digit)
		TType.literal_Decimal : return parse_Literal(NType.literal_Decimal, TType.literal_Decimal)
		TType.literal_Char    : return parse_Literal(NType.literal_Char,    TType.literal_Char)
		TType.literal_True    : return parse_Literal(NType.literal_True,    TType.literal_True)
		TType.literal_False   : return parse_Literal(NType.literal_False,   TType.literal_False)
		TType.literal_Hex     : return parse_Literal(NType.literal_Hex,     TType.literal_Hex)
		TType.literal_Octal   : return parse_Literal(NType.literal_Octal,   TType.literal_Octal)
		TType.literal_Binary  : return parse_Literal(NType.literal_Binary,  TType.literal_Binary)
	
	var assertStrTmplt = "Could not match token in parse_expr_Element! : {value} - {type} }"
	var assertStr      = assertStrTmplt.format({"value" : Tok.Value, "type" : Tok.Type})
		
	G.check(false, assertStr)
	return null
	
func parse_expr_SMA() -> ASTNode:
	if Tok.Type == TType.op_SMA:
		eat(TType.op_SMA)
		
		var \
		node = ASTNode.new(NType.op_SMA)
		node.add_Entry( parse_expr_Call() )
		return node

	var element = parse_expr_Element()
		
	if Tok && Tok.Type == TType.op_SMA:
		eat(TType.op_SMA)
		
		var \
		node = ASTNode.new(NType.op_SMA)
		node.add_Entry(element)
		node.add_Entry( parse_expr_Call() )
		return node
	
	return element;

func parse_expr_SBCap() -> ASTNode:
	var left = parse_expr_Cast()
	
	if Tok == null || Tok.Type != TType.cap_SBStart:
		return left
		
	eat(TType.cap_SBStart)
	
	var \
	node = ASTNode.new(NType.expr_SBCap)
	node.add_Entry(left)
	node.add_Entry(parse_Expression())
	
	eat(TType.cap_SBEnd)
	
	if Tok.Type == TType.op_SMA:
		node.add_Entry( parse_expr_SMA() )
	
	return node

func parse_expr_Cast() -> ASTNode:
	if Tok.Type == TType.op_Cast:
		eat(TType.op_Cast)
		
		var \
		node = ASTNode.new(NType.op_Cast)
		node.add_Entry( parse_expr_Capture() )
		
		return node
	
	return parse_expr_SMA()

func op_Callable(node):
	match node.type():
		NType.expr_SBCap     : return true
		NType.op_Cast        : return true
		NType.sym_Identifier : return true
		_:
			return false

func parse_expr_Call() -> ASTNode:
	var element = parse_expr_SBCap()

	if op_Callable(element) && Tok.Type == TType.cap_PStart:
		var \
		node = ASTNode.new(NType.op_Call)
		node.add_Entry(
		[
			element,
			parse_expr_Capture()
		])
	
		return node
		
	return element
	
func parse_expr_Capture() -> ASTNode:
	eat(TType.cap_PStart)
	
	var expression = parse_Expression()
	
	eat(TType.cap_PEnd)
	
	var \
	node = ASTNode.new(NType.expr_Cap)
	node.add_Entry(expression)
	return node
	
func op_Unary():
	if Tok == null:
		return null
	
	match Tok.Type:
		TType.sym_Ptr     : return NType.sym_Ptr
		TType.op_Subtract : return NType.op_UnaryNeg
		TType.op_LNot     : return NType.op_LNot
		TType.op_BNot     : return NType.op_BNot
		_:
			return null

func parse_expr_Unary() -> ASTNode:
	var operator = op_Unary()
	
	if operator == null:
		if Tok.Type == TType.cap_PStart:
			return parse_expr_Capture()
		else:
			return parse_expr_Call()
		
	var \
	node = ASTNode.new(operator)
	eat(Tok.Type)
	node.add_Entry( parse_expr_Unary() )
	
	return node

func op_Multiplicative():
	if Tok == null:
		return null
		
	match Tok.Type:
		TType.op_Multiply : return NType.op_Multiply
		TType.op_Divide   : return NType.op_Divide
		TType.op_Modulo   : return NType.op_Modulo
		_:
			return null
			
func parse_expr_Multiplicative() -> ASTNode:
	return parse_expr_Binary(parse_expr_Unary, op_Multiplicative)
	
func op_Additive():
	if Tok == null:
		return null
	
	match Tok.Type:
		TType.op_Add      : return NType.op_Add
		TType.op_Subtract : return NType.op_Subtract
		_:
			return null
	
func parse_expr_Additive() -> ASTNode:
	return parse_expr_Binary(parse_expr_Multiplicative, op_Additive)
	
func op_Bitshift():
	if Tok == null:
		return null
		
	match Tok.Type:
		TType.op_BSL : return NType.op_BSL
		TType.op_BSR : return NType.op_BSR
		_:
			return null
	
func parse_expr_Bitshift() -> ASTNode:
	return parse_expr_Binary(parse_expr_Additive, op_Bitshift)
	
func parse_expr_BitwiseAnd() -> ASTNode:
	return parse_expr_Binary_tok(parse_expr_Bitshift, TType.op_BAnd, NType.op_BAnd)
	
func parse_expr_BitwiseXOr() -> ASTNode:
	return parse_expr_Binary_tok(parse_expr_BitwiseAnd, TType.op_BXOr, NType.op_BXOr)

func parse_expr_BitwiseOr() -> ASTNode:
	return parse_expr_Binary_tok(parse_expr_BitwiseXOr, TType.op_BOr, NType.op_BOr)
	
func op_Relational():
	if Tok == null:
		return null
		
	match Tok.Type:
		TType.op_Greater      : return NType.op_Greater
		TType.op_Lesser       : return NType.op_Lesser
		TType.op_GreaterEqual : return NType.op_GreaterEqual
		TType.op_LesserEqual  : return NType.op_LesserEqual
		_:
			return null
	
func parse_expr_Relational() -> ASTNode:
	return parse_expr_Binary(parse_expr_BitwiseOr, op_Relational)
	
func op_Equality():
	if Tok == null:
		return null
		
	match Tok.Type:
		TType.op_Equal    : return NType.op_Equal
		TType.op_NotEqual : return NType.op_NotEqual
		_:
			return null

func parse_expr_Equality() -> ASTNode:
	return parse_expr_Binary(parse_expr_Relational, op_Equality)
	
func parse_expr_LogicalAnd() -> ASTNode:
	return parse_expr_Binary_tok(parse_expr_Equality, TType.op_LAnd, NType.op_LAnd)
	
func parse_expr_LogicalOr() -> ASTNode:
	return parse_expr_Binary_tok(parse_expr_LogicalAnd, TType.op_LOr, NType.op_LOr)
	
func op_Assignment():
	if Tok == null:
		return null
	
	match Tok.Type:
		TType.op_Assign : return NType.op_Assign
		TType.op_A_Add  : return NType.op_A_Add
		_:
			return null
	
func parse_expr_Assignment() -> ASTNode:
	return parse_expr_Binary(parse_expr_LogicalOr, op_Assignment)
	
func parse_expr_Delimited() -> ASTNode:
	return parse_expr_Binary_tok(parse_expr_Assignment, TType.op_CD, NType.op_CD)
#endregion Expressions

func parse_sym_CapSB() -> ASTNode:
	var \
	node = ASTNode.new(NType.sym_Array)
	
	eat(TType.cap_SBStart)
	node.add_Entry( parse_Expression() )
	eat(TType.cap_SBEnd)
	
	match Tok.Type:
		TType.sym_Type : node.add_Entry(NType.sym_TType); eat(TType.sym_Type)
		
		TType.sym_gd_Bool   : node.add_Entry(NType.builtin_bool);   eat(TType.sym_gd_Bool)
		TType.sym_gd_Int    : node.add_Entry(NType.builtin_int);    eat(TType.sym_gd_Int)
		TType.sym_gd_Float  : node.add_Entry(NType.builtin_float);  eat(TType.sym_gd_Float)
		TType.sym_gd_String : node.add_Entry(NType.builtin_string); eat(TType.sym_gd_String)
		
		TType.sym_Identifier : node.add_Entry( parse_expr_Call() )
		TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
		TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
		TType.cap_SBStart    : node.add_Entry( parse_sym_CapSB() )
	
	return node

func parse_sym_Identifier() -> ASTNode:
	var \
	node = ASTNode.new(NType.sym_Identifier)
	node.add_TokVal(Tok)
	
	eat(TType.sym_Identifier)

	return node

func parse_sym_Proc() -> ASTNode:
	var node = ASTNode.new(NType.sym_Proc)
	eat(TType.sym_Exe)
	
	if Tok.Type == TType.cap_PStart:
		node.add_Entry( parse_sec_CaptureArgs() )
	
	if Tok.Type == TType.op_Map:
		node.add_Entry( parse_sec_CaptureReturnMap() )
			
	return node
	
func parse_sym_Ptr() -> ASTNode:
	var node = ASTNode.new(NType.sym_Ptr)
	eat(TType.sym_Ptr)
	
	match Tok.Type:
		TType.sym_gd_Bool   : node.add_Entry(NType.builtin_bool);   eat(TType.sym_gd_Bool)
		TType.sym_gd_Int    : node.add_Entry(NType.builtin_int);    eat(TType.sym_gd_Int)
		TType.sym_gd_Float  : node.add_Entry(NType.builtin_float);  eat(TType.sym_gd_Float)
		TType.sym_gd_String : node.add_Entry(NType.builtin_string); eat(TType.sym_gd_String)
		
		TType.sym_Identifier : node.add_Entry( parse_expr_Call() )
		TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
		TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
		TType.cap_SBStart    : node.add_Entry( parse_sym_CapSB() )
#		TType.sym_Type       : node.add_Entry( parse_Simple(NType.sym_TType, TType.sym_Type) )
	
	return node

func parse_sym_TT_Type() -> ASTNode:
	var node = ASTNode.new(NType.sym_TT_Type)
	eat(TType.sym_TT)
	
	match Tok.Type:
		TType.sym_Type : node.add_Entry(NType.sym_TType); eat(TType.sym_Type)
		
		TType.sym_gd_Bool   : node.add_Entry(NType.builtin_bool);   eat(TType.sym_gd_Bool)
		TType.sym_gd_Int    : node.add_Entry(NType.builtin_int);    eat(TType.sym_gd_Int)
		TType.sym_gd_Float  : node.add_Entry(NType.builtin_float);  eat(TType.sym_gd_Float)
		TType.sym_gd_String : node.add_Entry(NType.builtin_string); eat(TType.sym_gd_String)
		
		TType.sym_Identifier : node.add_Entry( parse_expr_Call() )
		TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
		TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
		TType.cap_SBStart    : node.add_Entry( parse_sym_CapSB() )

	return node
	
func parse_op_Break() -> ASTNode:
	var node = ASTNode.new(NType.op_Break)
	eat(TType.op_Break)
	
	return node

func parse_op_Return() -> ASTNode:
	var node = ASTNode.new(NType.op_Return)
	eat(TType.op_Return)
	
	if Tok.Type == TType.def_End:
		return node
	
	match Tok.Type:
		_:
			node.add_Entry( parse_Expression() )

	return node

func parse_Simple(nType, tType) -> ASTNode:
	eat(tType)
	var    node = ASTNode.new(nType)
	return node

func parse_Literal(nType, tType) -> ASTNode:
	var \
	node = ASTNode.new(nType)
	node.add_TokVal(Tok)
	
	eat(tType)
	return node
	
func parse_TokValue(nType, tType) -> ASTNode:
	var \
	node = ASTNode.new(nType)
	node.add_TokVal(Tok)
	
	eat(tType)
	return node
	
#region Object
func _init( lexer : Lexer ) -> void:
	Lex = lexer
#endregion Object
