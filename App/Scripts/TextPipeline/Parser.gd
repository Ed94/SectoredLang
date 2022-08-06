class_name SyntaxParser extends Object

# NOTE:
# The parser  model used here may be able to generate an ast that the interpreter at the 
# "GDScript level" of implementation will not be able to support (Or possibly LLVM for that matter).
# So those nodes will not be supported on the demo langauge platform.
 
const NType = \
{
	empty = "Empty Statement",
	unit = "Module Unit",
	
	capture = "Capture",
	
	expression = "Expression",
	
	op_Assign = "Op: Assign",
	op_Add    = "Op: Add",
	
	literal_Binary  = "Literal: Binary",
	literal_Octal   = "Litearl: Octal",
	literal_Hex     = "Literal: Hex",
	literal_Decimal = "Literal: Decimal",
	literal_Digit   = "Literal: Digit",
	literal_Char    = "Literal: Char",
	literal_String  = "Literal: String",
	literal_True    = "Literal: True",
	literal_False   = "Literal: False",
	
#	sec_LP = "",

	sec_Exe        = "Sector: Execution",
	sec_Static     = "Sector: Static",
	sec_Type       = "Sector: Type",
	sec_Identifier = "Sector: Identifier",
	
	builtin_bool   = "bool",
	builtin_int    = "int",
	builtin_float  = "float",
	builtin_string = "String",
	
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

func parse( ) -> ASTNode:
	Tok = Lex.next_Token()
	
	var \
	node = ASTNode.new()
	node.set_Type(NType.unit)
	
	while Tok != null :
		var matched = false
		match Tok.Type:
			TType.sym_Identifier:
				node.add_Entry( parse_sec_Identifier() )
				matched = true
				
			TType.sec_Exe:
				node.add_Entry( parse_sec_Exe() )
				matched = true
				
			TType.sec_Static:
				node.add_Entry( parse_sec_Static() )
				matched = true
				
			# Empty statement
			TType.def_End:
				eat(TType.def_End)
				matched = true
				
		if !matched:
			var literalNode = parse_ExprElement();
			if literalNode != null:
				node.add_Entry( literalNode )
				eat(TType.def_End)
				matched = true
				
		if !matched:
			var error = G.Error.new(false, "Failed to match token")
			G.throw(error)
			return null
			
	return node

func parse_sec_Identifier() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Identifier)
	
	var identifier = parse_TokValue(NType.sym_Identifier, TType.sym_Identifier)
	node.add_Entry( identifier )
	
	if Tok == null:
		return node

	# Check for body
	if Tok.Type == TType.def_Start:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:	
			match Tok.Type:
				TType.sec_Type:
					node.add_Entry( parse_sec_Type() )
					eat(TType.def_End)
					
				TType.sec_Static:
					node.add_Entry( parse_sec_Static() )
					eat(TType.def_End)
					
				_:
					var error = G.Error.new(false, "Failed to match token.")
					G.throw(error)
					return null

		eat(TType.def_End)

	else:
		match Tok.Type:
			TType.sec_Type:
				node.add_Entry( parse_sec_Type() )
				eat(TType.def_End)	

	return node

func parse_sec_Exe() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Exe)
	eat(TType.sec_Exe)
	
	var result = chk_Tok(TType.def_Start)
	if result == null:
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var expression = parse_Expression()
			
			if expression != null:
				node.add_Entry( expression )
				eat(TType.def_End)
				
		eat(TType.def_End)
	
	else:
		var expression = parse_Expression()
		
		if expression != null:
			node.add_Entry( expression )
			
		eat(TType.def_End)
	
	return node
	
func parse_sec_Static() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Static)
	eat(TType.sec_Static)
	
	var result = chk_Tok(TType.def_Start)
	if result == null:
		return node
		
	if result:
		eat(TType.def_Start)
		
		while Tok.Type != TType.def_End:
			var \
			identifierNode = ASTNode.new()
			identifierNode.set_Type(NType.sec_Identifier)
			
			var identifier = parse_TokValue(NType.sym_Identifier, TType.sym_Identifier)
			identifierNode.add_Entry( identifier )
			
			var type = parse_sec_Type()
			identifierNode.add_Entry( type )
			
			node.add_Entry(identifierNode)
			eat(TType.def_End)
		
	else:
		var \
		identifierNode = ASTNode.new()
		identifierNode.set_Type(NType.sec_Identifier)
			
		var identifier = parse_TokValue(NType.sym_Identifier, TType.sym_Identifier)
		identifierNode.add_Entry( identifier )
			
		var type = parse_sec_Type()
		identifierNode.add_Entry( type )
			
		node.add_Entry(identifierNode)
	
	return node

func parse_sec_Type() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sec_Type)
	eat(TType.sec_Type)
	
	var typeNode = ASTNode.new()
	
	if Tok == null:
		return node
	
	if Tok.Type == TType.op_A_Infer:
		eat(TType.op_A_Infer)
		
		match Tok.Type:
			TType.literal_Digit   : typeNode.set_Type(NType.builtin_int) 
			TType.literal_Decimal : typeNode.set_Type(NType.builtin_float)
			TType.literal_String  : typeNode.set_Type(NType.builtin_string)
			TType.literal_Char    : typeNode.set_Type(NType.builtin_string) 
			TType.literal_True    : typeNode.set_Type(NType.builtin_bool)
			TType.literal_False   : typeNode.set_Type(NType.builtin_bool)
			TType.literal_Binary  : typeNode.set_Type(NType.builtin_int) 
			TType.literal_Octal   : typeNode.set_Type(NType.builtin_int) 
			TType.literal_Hex     : typeNode.set_Type(NType.builtin_int) 

		typeNode.add_Entry( parse_ExprElement() )

	else:
		match Tok.Type:
			TType.sym_Bool   : typeNode.set_Type(NType.builtin_bool)
			TType.sym_Int    : typeNode.set_Type(NType.builtin_int)
			TType.sym_Float  : typeNode.set_Type(NType.builtin_float)
			TType.sym_String : typeNode.set_Type(NType.builtin_string)
		
			TType.sym_Identifier : typeNode.set_Type(NType.sym_Identifier)
		
		eat(typeNode.type())
	
		if Tok.Type == TType.op_Assign:
			eat(TType.op_Assign)
			
			typeNode.add_Entry( parse_ExprElement() )
			
	node.add_Entry( typeNode )
	
	return node
	
func parse_BinaryExpression(elementFn : Callable, opTok : String, nodeType : String) -> ASTNode:
	var left = elementFn.call()
	
	if Tok.Type != opTok:
		return left
	
	var \
	node = ASTNode.new()
	node.set_Type(nodeType)
	eat(opTok)
	
	var right = elementFn.call()
	
	node.add_Entry(left)
	node.add_Entry(right)
	
	return node
	
func parse_Expression() -> ASTNode:
	return parse_AssignmentExpression()

func parse_AssignmentExpression() -> ASTNode:
	var left = parse_ExprElement()
	
	# If there is no assign its just an element.
	if Tok.Type != TType.op_Assign:
		return left
		
	var \
	node = ASTNode.new()
	node.set_Type(NType.op_Assign)
	eat(TType.op_Assign)
	
	var right = parse_BinaryExpression(parse_ExprElement, TType.op_Add, NType.op_Add)
	
	# TODO:
#	node.add_Entry( parse_ElementType() )
	
	node.add_Entry(left)
	node.add_Entry(right)
	
	return node

func parse_ExprElement() -> ASTNode:
	var matched = false
	match Tok.Type:
		TType.sym_Identifier:
			return parse_TokValue(NType.sym_Identifier, TType.sym_Identifier)
		
		# Literal detection needs to be moved to its own block...
		TType.literal_String:
			return parse_Literal(NType.literal_String, TType.literal_String)
			
		TType.literal_Digit:
			return parse_Literal(NType.literal_Digit, TType.literal_Digit)

		TType.literal_Decimal:
			return parse_Literal(NType.literal_Decimal, TType.literal_Decimal)
			
		TType.literal_Char:
			return parse_Literal(NType.literal_Char, TType.literal_Char)
			
		TType.literal_True:
			return parse_Literal(NType.literal_True, TType.literal_True)
		
		TType.literal_False:
			return parse_Literal(NType.literal_False, TType.literal_False)
			
		TType.literal_Hex:
			return parse_Literal(NType.literal_Hex, TType.literal_Hex)

		TType.literal_Octal:
			return parse_Literal(NType.literal_Octal, TType.literal_Octal)

		TType.literal_Binary:
			return parse_Literal(NType.literal_Binary, TType.literal_Binary)
		
	return null

func parse_sym_Identifier() -> ASTNode:
	var \
	node = ASTNode.new()
	node.set_Type(NType.sym_Identifier)
	node.add_TokVal(Tok)
	
	eat(TType.sym_Identifier)
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


