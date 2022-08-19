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

	expr     = "Expression",
	expr_cap = "Capture",
	
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
	op_Add      = "Op: Add",
	op_Subtract = "Op: Subtract",
	op_Multiply = "Op: Multiply",
	op_Divide   = "Op: Divide",
	op_Modulo   = "Op: Modulo",
	
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
	sec_Identifier = "Sector: Identifier",
	
	builtin_bool   = "GD: bool",
	builtin_int    = "GD: int",
	builtin_float  = "GD: float",
	builtin_Array  = "GD: Array",
	builtin_Dict   = "GD: Dictionary",
	builtin_string = "GD: String",
	
	sym_Proc       = "Symbol: Procedure",
	sym_Ptr        = "Symbol: Pointer",
	sym_Self       = "Symbol: Self",

	sym_Identifier = "Symbol: Identifier",
}

class ASTNode:
	var Data : Array
	
# Godot Meta
	func get_class():
		return "ASTNode"
# Godot Meta End

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
	
# Serialization ----------------------------------------------------
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
# Serialization END -------------------------------------------------


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
	
	var assertStrTmplt = "Unexpected token: {value}, expected: {type}"
	var assertStr      = assertStrTmplt.format({"value" : currToken.Value, "type" : tokenType})
		
	if G.check(currToken.Type == tokenType, assertStr):
		Tok = null
		return null
	
	Tok = Lex.next_Token()
	
	return currToken

func parse_unit() -> ASTNode:
	Tok = Lex.next_Token()
	
	var \
	node = ASTNode.new()
	node.set_Type(NType.unit)
	
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
				
			TType.sec_Static:
				node.add_Entry( parse_sec_Static() )
				matched = true
								
			TType.sym_TT:
				node.add_Entry( parse_sec_TranslationTime() )
				matched = true
		#endregion LP_Sectors
			
			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )
				matched = true

			# Empty statement
			TType.def_End:
				eat(TType.def_End)
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

func parse_sec_Capture() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Cap)
	node.add_Entry( parse_sec_CaptureArgs() )
	
	if Tok == null:
		return node
	
	if Tok.Type == TType.op_Map:
		node.add_Entry( parse_sec_CaptureReturnMap() )
	
	var result = chk_Tok(TType.def_Start)
	if result == null:
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			match Tok.Type:
				TType.cap_PStart:
					node.add_Entry( parse_sec_Capture() )
#					eat(TType.def_End)
			
			#region LP_Sectors
				TType.sym_Exe:
					node.add_Entry( parse_sec_Exe() )
#					eat(TType.def_End)
				
				TType.sec_If:
					node.add_Entry( parse_sec_Conditional() )
#					eat(TType.def_End)
					
				TType.sec_Static:
					node.add_Entry( parse_sec_Static() )
#					eat(TType.def_End)
				
				TType.sym_TT:
					node.add_Entry( parse_sec_TranslationTime() )
#					eat(TType.def_End)
			#endregion LP_Sectors
					
				TType.sym_Identifier:
					node.add_Entry( parse_sec_Identifier() )
#					eat(TType.def_End)

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
				
			TType.sym_TT:
				node.add_Entry( parse_sec_TranslationTime() )
		#endregion LP_Sectors
			
			TType.sym_Exe:
				node.add_Entry( parse_sec_Exe() )
				
			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )

	return node
	
func parse_sec_CaptureArgs() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_CapArgs)
	
	eat(TType.cap_PStart)
	
	while ! chk_Tok(TType.cap_PEnd):
		var symbol
		match Tok.Type:
			TType.sym_Self:
				symbol = parse_Simple(NType.sym_Self, TType.sym_Self)
				
			TType.sym_Identifier:
				symbol = parse_sym_Identifier()
				
				if Tok.Type != TType.op_CD:
					var type = parse_sec_Type(TType.op_Define)
					
					symbol.add_Entry( type )

		node.add_Entry(symbol)
		
		match chk_Tok(TType.op_CD):
			true: eat(TType.op_CD)
			null: return node
	
	eat(TType.cap_PEnd)
	
	return node
	
func parse_sec_CaptureReturnMap() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_CapRet)
	eat(TType.op_Map)
	
	node.add_Entry( parse_expr_Call() )
				
	return node
	
#region LP_Sectors
func parse_sec_Conditional() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type( NType.sec_Cond )
	eat(TType.sec_If)
	
	node.add_Entry( parse_Expression() )
	
	parse_sec_ConditionalBody(node)
	
	if Tok && Tok.Type == TType.sec_Else:
		parse_sec_ConditionalBody(node)

	return node
	
func parse_sec_ConditionalBody(node):
	var result = chk_Tok(TType.def_Start)
	if result == null:
		return null
	
	eat(TType.def_Start)
	
	if result:
		while Tok.Type != TType.def_End:
			match Tok.Type:
				TType.cap_PStart:
					node.add_Entry( parse_sec_Capture() )
#					eat(TType.def_End)
			
			#region LP_Sectors
				TType.sym_Exe:
					node.add_Entry( parse_sec_Exe() )
#					eat(TType.def_End)
				
				TType.sec_If:
					node.add_Entry( parse_sec_Conditional() )
#					eat(TType.def_End)
					
				TType.sec_Static:
					node.add_Entry( parse_sec_Static() )
#					eat(TType.def_End)
				
				TType.sym_TT:
					node.add_Entry( parse_sec_TranslationTime() )
#					eat(TType.def_End)
			#endregion LP_Sectors
					
				TType.sym_Identifier:
					node.add_Entry( parse_sec_Identifier() )
#					eat(TType.def_End)

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
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Enum)
	eat(TType.sym_Enum)
	
	if Tok.Type == TType.cap_PStart:
		node.add_Entry( parse_expr_Capture() )
	
	var result = chk_Tok(TType.def_Start)
	if result == null:
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			if Tok.Type == TType.sym_Identifier:
				node.add_Entry( parse_sec_EnumElement() )
#				eat(TType.def_End)
			else:
				var error = G.Error.new(false, "Failed to match token.")
				G.throw(error)
				return null
		
	else:
		if Tok.Type == TType.sym_Identifier:
			node.add_Entry( parse_sec_EnumElement() )
#			eat(TType.def_End)
		
	return node
	
func parse_sec_EnumElement() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.enum_Element)
	node.add_Entry( parse_expr_Element() )
	
	if Tok.Type == TType.op_Assign:
		eat(TType.op_Assign)
		node.add_Entry( parse_expr_Element() )
		
	return node

func parse_sec_Exe() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Exe)
	eat(TType.sym_Exe)
	
	parse_sec_ExeBody(node)
	
	return node
		
func parse_sec_ExeBody(node):
	var result = chk_Tok(TType.def_Start)
	if result == null:
		return
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var matched = false
			match Tok.Type:
				TType.op_Break:
					node.add_Entry( parse_op_Break() )
#					eat(TType.def_End)
					matched = true
				
				TType.sec_If:
					node.add_Entry( parse_sec_ExeConditional() )
#					eat(TType.def_End)
					matched = true
					
				TType.sec_Loop:
					node.add_Entry( parse_sec_Loop() )
					matched = true
					
				TType.sec_Switch:
					node.add_Entry( parse_sec_Switch() )
					matched = true
					
				TType.op_Return:
					node.add_Entry( parse_op_Return() )
					matched = true
			
			if ! matched:
				var expression = parse_Expression()
			
				if expression != null:
					node.add_Entry( expression )
					
				result = chk_Tok(TType.def_End)
				if result == null || result == true:
					return node
					
#				eat(TType.def_End)

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
					
			TType.sec_Switch:
				node.add_Entry( parse_sec_Switch() )
				matched = true

		if ! matched:
			var expression = parse_Expression()
		
			if expression != null:
				node.add_Entry( expression )

func parse_sec_ExeConditional() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Cond)
	eat(TType.sec_If)
	
	node.add_Entry( parse_Expression() )
	
	var result = chk_Tok(TType.def_Start)
	if result == null:
		return null
		
	var \
	ifBlock = ASTNode.new()
	ifBlock.set_Type(NType.sec_Exe)
	
	parse_sec_ExeBody(ifBlock)
	
	node.add_Entry(ifBlock)

	result = chk_Tok(TType.def_Start)
	if result == null || result == false:
		return node
			
	var \
	elseBlock = ASTNode.new()
	elseBlock.set_Type(NType.sec_Exe)
	
	parse_sec_ExeBody(elseBlock)
	eat(TType.def_End)
	
	node.add_Entry(elseBlock)
	
	return node

func parse_sec_Heap() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type( NType.sec_Heap )
	eat(TType.sec_Heap)
	
	var result = chk_Tok( TType.def_Start )
	if result == null:
		return node
	
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var identifier = parse_sym_Identifier()
			var op         = parse_sec_HeapOp()
			
			node.add_Entry(identifier)
			node.add_Entry(op)
			
			eat( TType.def_End )
		
	else:
		var identifier = parse_sym_Identifier()
		var op         = parse_sec_HeapOp()
			
		node.add_Entry(identifier)
		node.add_Entry(op)
	
	return node
	
func parse_sec_HeapOp() -> ASTNode:
	eat(TType.op_Define)
	
	var \
	node = ASTNode.new()

	
	return null

func parse_sec_Loop() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Loop)
	eat(TType.sec_Loop)
	
	if Tok.Type == TType.sec_If:
		var \
		nCond = ASTNode.new()
		nCond.set_Type( NType.sec_LoopCond )
		eat(TType.sec_If)
	
		nCond.add_Entry( parse_Expression() )
		node.add_Entry(nCond)
	
	parse_sec_ExeBody(node)
		
	return node
	
func parse_sec_Readonly() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_RO)
	eat(TType.sym_RO)
	
	return node

func parse_sec_Stack() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Stack)
	eat(TType.sec_Stack)
	
	var result = chk_Tok( TType.def_Start )
	if result == null:
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var identifier = parse_sym_Identifier()
			var type       = parse_sec_Type(TType.op_Define)
			
			identifier.add_Entry( type )
			
			node.add_Entry(identifier)
		eat( TType.def_End )
		
	else:
		var identifier = parse_sym_Identifier()
		var type       = parse_sec_Type(TType.op_Define)
		
		identifier.add_Entry( type )
		
		node.add_Entry(identifier)
	
	return node

func parse_sec_Static() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type( NType.sec_Static )
	eat(TType.sec_Static)
	
	var result = chk_Tok( TType.def_Start )
	if result == null:
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var identifier = parse_sym_Identifier()
			var type       = parse_sec_Type(TType.op_Define)
			
			identifier.add_Entry( type )
			
			node.add_Entry(identifier)
		eat( TType.def_End )
		
	else:
		var identifier = parse_sym_Identifier()
		var type       = parse_sec_Type(TType.op_Define)
		
		identifier.add_Entry( type )
		
		node.add_Entry(identifier)
	
	return node
	
func parse_sec_Struct() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Struct)
	eat(TType.sec_Struct)
	
	var result = chk_Tok( TType.def_Start )
	if result == null || result == false:
		return node
		
	eat(TType.def_Start)
	
	while !chk_Tok(TType.def_End):
		var identifier = parse_sym_Identifier()
		var type       = parse_sec_Type(TType.op_Define)
		
		identifier.add_Entry(type)
		node.add_Entry(identifier)
	eat(TType.def_End)
	
	return node

func parse_sec_Switch() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Switch)
	eat(TType.sec_Switch)
	
	node.add_Entry( parse_Expression() )
		
	var result = chk_Tok( TType.def_Start )
	if result == null:
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
	node = ASTNode.new()
	node.set_Type(NType.sec_SwitchCase)
	
	node.add_Entry( parse_Expression() )
	
	parse_sec_ExeBody(node)
	
	return node

func parse_sec_TranslationTime() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_TT)

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
				TType.cap_PStart:
					node.add_Entry( parse_sec_Capture() )
#					eat(TType.def_End)
				
			#region LP_Sectors
				TType.sym_Enum:
					node.add_Entry( parse_sec_Enum() )
#					eat(TType.def_End)
					
				TType.sym_Exe:
					node.add_Entry( parse_sec_Exe() )
#					eat(TType.def_End)
					
				TType.sec_Static:
					node.add_Entry( parse_sec_Static() )
#					eat(TType.def_End)
			#endregion LP_Sectors

				TType.sym_Identifier:
					node.add_Entry( parse_sec_Identifier() )
#					eat(TType.def_End)

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
			TType.sym_Enum:
				node.add_Entry( parse_sec_Enum() )
				
			TType.sym_Exe:
				node.add_Entry( parse_sec_Exe() )
			
			TType.sec_Static:
				node.add_Entry( parse_sec_Static() )
		#endregion LP_Sectors
		
			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )

	return node
#endregion LP_Sectors

func parse_sec_Type(typeTok : String) -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Type)

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
		
			TType.sym_Identifier : node.add_Entry( parse_sym_Identifier() )
			TType.cap_PStart     : node.add_Entry( parse_sym_Proc() )
			TType.sym_Exe        : node.add_Entry( parse_sym_Proc() )
			TType.sym_Ptr        : node.add_Entry( parse_sym_Ptr() )
			TType.cap_SBStart    : node.add_Entry( parse_sym_CapSB() )
	
		if Tok.Type == TType.op_Assign:
			eat(TType.op_Assign)
			
			node.add_Entry( parse_expr_Element() )

	return node
	
func parse_sec_Identifier() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Identifier)

	if G.check(Tok.Type == TType.sym_Identifier, "Next token should have been an identifier symbol"):
		return node
		
	node.add_TokVal(Tok)
	eat(TType.sym_Identifier)
	
	if Tok == null:
		return node
		
	# Check for body
	if Tok.Type == TType.def_Start:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			match Tok.Type:
				TType.cap_PStart:
					node.add_Entry( parse_sec_Capture() )
#					eat(TType.def_End)
				
			#region LP_Sectors
				TType.sym_Enum:
					node.add_Entry( parse_sec_Enum() )
#					eat(TType.def_End)
					
				TType.sym_Exe:
					node.add_Entry( parse_sec_Exe() )
#					eat(TType.def_End)
					
				TType.sec_Static:
					node.add_Entry( parse_sec_Static() )
#					eat(TType.def_End)
					
				TType.sec_Struct:
					node.add_Entry( parse_sec_Struct() )
#					eat(TType.def_End)
					
				TType.sym_TT:
					node.add_Entry( parse_sec_TranslationTime() )
#					eat(TType.def_End)
			#endregion LP_Sectors

				TType.sym_Identifier:
					node.add_Entry( parse_sec_Identifier() )
#					eat(TType.def_End)
					
				TType.sym_Type:
					node.add_Entry( parse_sec_Type(TType.sym_Type) )
#					eat(TType.def_End)
					
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
			TType.sym_Enum:
				node.add_Entry( parse_sec_Enum() )
				
			TType.sym_Exe:
				node.add_Entry( parse_sec_Exe() )
				
			TType.sec_Struct:
				node.add_Entry( parse_sec_Struct() )
			
			TType.sec_Static:
				node.add_Entry( parse_sec_Static() )
				
			TType.sym_TT:
				node.add_Entry( parse_sec_TranslationTime() )
		#endregion LP_Sectors
		
			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )
							
			TType.sym_Type:
				node.add_Entry( parse_sec_Type(TType.sym_Type) )

	return node

#region Expressions
func parse_Expression() -> ASTNode:
	return parse_expr_Delimited()
	
func parse_expr_Binary_tok(elementFn : Callable, tType : String, nType) -> ASTNode:
	var left = elementFn.call()
	
	# If there is no assign its just an element.
	if Tok.Type != tType:
		return left
		
	var \
	node = ASTNode.new()
	node.set_Type(nType)
	eat(tType)
	
	var right = elementFn.call()

	node.add_Entry(left)
	node.add_Entry(right)
	
	return node
	
func parse_expr_Binary(elementFn : Callable, op_CheckFn : Callable) -> ASTNode:
	var left = elementFn.call()
	
	var result = op_CheckFn.call()
	while result:
		var \
		node = ASTNode.new()
		node.set_Type(result)
		eat(Tok.Type)
	
		var right = elementFn.call()
	
		node.add_Entry(left)
		node.add_Entry(right)
		
		left   = node
		result = op_CheckFn.call()
	
	return left

# Sorted by precedence (First is highest)
	
func parse_expr_Element() -> ASTNode:
	var matched = false
	match Tok.Type:
		TType.sym_Identifier:
			return parse_sym_Identifier()
			
		TType.sym_gd_Bool   : return parse_Simple(NType.builtin_bool, TType.sym_gd_Bool);
		TType.sym_gd_Int    : return parse_Simple(NType.builtin_int, TType.sym_gd_Int);
		TType.sym_gd_Float  : return parse_Simple(NType.builtin_float, TType.sym_gd_Float);
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
		
	return null

func parse_expr_Cast() -> ASTNode:
	if Tok.Type == TType.op_Cast:
		eat(TType.op_Cast)
		
		var node = ASTNode.new()
		node.set_Type(NType.op_Cast)
		node.add_Entry( parse_expr_Capture() )
		
		return node
	
	return parse_expr_Element()

func op_Callable(node):
	match node.type():
		NType.op_Cast        : return true
		TType.sym_Identifier : return true
		_:
			return false

func parse_expr_Call() -> ASTNode:
	var element = parse_expr_Cast()

	if op_Callable(element) && Tok.Type == TType.cap_PStart:
		var \
		node = ASTNode.new()
		node.set_Type(NType.op_Call)
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
	node = ASTNode.new()
	node.set_Type(NType.expr_cap)
	node.add_Entry(expression)
		
	return node
	
func op_Unary():
	match Tok.Type:
		TType.op_LNot : return NType.op_LNot
		TType.op_BNot : return NType.op_BNot
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
	node = ASTNode.new()
	node.set_Type(operator)
	node.add_Entry( parse_expr_Unary() )
	eat(operator)
	
	return node

func op_Multiplicative():
	match Tok.Type:
		TType.op_Multiply : return NType.op_Multiply
		TType.op_Divide   : return NType.op_Divide
		TType.op_Modulo   : return NType.op_Modulo
		_:
			return null;
			
func parse_expr_Multiplicative() -> ASTNode:
	return parse_expr_Binary(parse_expr_Unary, op_Multiplicative)
	
func op_Additive():
	match Tok.Type:
		TType.op_Add      : return NType.op_Add
		TType.op_Subtract : return NType.op_Subtract
		_:
			return null
	
func parse_expr_Additive() -> ASTNode:
	return parse_expr_Binary(parse_expr_Multiplicative, op_Additive)
	
func op_Bitshift():
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
	
func parse_expr_Assignment() -> ASTNode:
	return parse_expr_Binary_tok(parse_expr_LogicalOr, TType.op_Assign, NType.op_Assign)
	
func parse_expr_Delimited() -> ASTNode:
	return parse_expr_Binary_tok(parse_expr_Assignment, TType.op_CD, NType.op_CD)
#endregion Expressions

func parse_sym_CapSB() -> ASTNode:
	return null

func parse_sym_Proc() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sym_Proc)
	
	if Tok.Type == TType.cap_PStart:
		node.add_Entry( parse_sec_CaptureArgs() )
	
	if Tok.Type == TType.op_Map:
		node.add_Entry( parse_sec_CaptureReturnMap() )
		
	eat(TType.sym_Exe)
		
	return node

func parse_sym_Identifier() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sym_Identifier)
	node.add_TokVal(Tok)
	
	eat(TType.sym_Identifier)
	
	while Tok.Type == TType.op_SMA:
		parse_op_SMA(node)
		
	if Tok.Type == TType.cap_PStart:
		node.add_Entry( parse_expr_Capture() )
	
	return node
	
func parse_sym_Ptr() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sym_Ptr)
	eat(TType.sym_Ptr)
	
	match Tok.Type:
		TType.sym_gd_Bool   : node.add_Entry(NType.builtin_bool);   eat(TType.sym_gd_Bool)
		TType.sym_gd_Int    : node.add_Entry(NType.builtin_int);    eat(TType.sym_gd_Int)
		TType.sym_gd_Float  : node.add_Entry(NType.builtin_float);  eat(TType.sym_gd_Float)
		TType.sym_gd_String : node.add_Entry(NType.builtin_string); eat(TType.sym_gd_String)
		
		TType.sym_Identifier : node.add_Entry(NType.sym_Identifier); eat(TType.sym_Identifier)
		TType.sym_Exe        : node.add_Entry(NType.sym_Proc);       eat(TType.sym_Exe)
	
	return node
	
func parse_op_Break() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.op_Break)
	eat(TType.op_Break)
	
	return node
	
func parse_op_SMA(node : ASTNode):
	eat(TType.op_SMA)
	
	var \
	nodeSMA = ASTNode.new()
	nodeSMA.set_Type(NType.op_SMA)
	
	match Tok.Type:
		TType.sym_Ptr:
			nodeSMA.add_Entry( parse_Simple(NType.op_Ptr, TType.sym_Ptr) )
			node.add_Entry( nodeSMA )
			return
	
	nodeSMA.add_TokVal(Tok)
		
	eat(TType.sym_Identifier)
		
	if Tok.Type == TType.cap_PStart:
		nodeSMA.add_Entry( parse_expr_Capture() )

	node.add_Entry( nodeSMA)

func parse_op_Return() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.op_Return)
	eat(TType.op_Return)
	
	match Tok.Type:
		_:
			node.add_Entry( parse_Expression() )

	return node

func parse_Simple(nType, tType) -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(nType)

	eat(tType)
	return node

func parse_Literal(nType, tType) -> ASTNode:
	var\
	node = ASTNode.new()
	node.set_Type(nType)
	node.add_TokVal(Tok)
	
	eat(tType)
	return node
	
func parse_TokValue(nType, tType) -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(nType)
	node.add_TokVal(Tok)
	
	eat(tType)
	return node
	
# Object
func _init( lexer : Lexer ) -> void:
	Lex = lexer
# Object END
