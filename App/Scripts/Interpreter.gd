class_name Interpreter extends RefCounted

const LogType := Log.EType
const NType   := SyntaxParser.NType
#const ASTNode := SyntaxParser.ASTNode


var AST    : SyntaxParser.ASTNode
var Env    : MasEnv
var Parent : Interpreter



func eva(ast):	
	G.Log.out(LogType.log, "Interpreting...")
	
	var evaResult = null
	
	match ast.type():
		NType.unit:
			if ast.num_Entries() == 0:
				continue
			
			var index = 1
			while index < ast.num_Entries(): 	 		
				eva( ast.entry(index) )
				index += 1
		
			var result = eva( ast.entry(index) )
			if result:
				if typeof(result) == TYPE_OBJECT && result.get_class() == "ASTNode":
					JSON.new().stringify(result.to_SExpression())
					
				evaResult = str(result)
				
		NType.sec_Exe:
			if Parent == null:
				# Execute immediately
				var index = 1
				while index < ast.num_Entries():
					eva( ast.entry(index) )
				
				evaResult = eva( ast.entry(index) )
				
		# TODO:
		NType.sec_Static:
			var index = 1
			while index < ast.num_Entires():
				pass
				
#				eva( ast.entry(index) )
					
				
		NType.sec_Identifier:
			# sec -> sym node
			var symbol = ast.entry(1).entry(1)
			
			if !Env.has(symbol):
				Env.define(symbol)
			
			match ast.entry(2).type():
				NType.sec_Type:
					var astType = ast.entry(2).entry(1)
					var typedef = [ astType.type() ]
					
					if astType.num_Entries() >= 1:
						typedef.append( astType.entry(1).entry(1) )
					
					Env.assign_Type(symbol, typedef)
					
				# TODO:
#				NType.sec_Static:
#					var index = 1
#					while index < ast.num_Entires():
#
#						var varSymbol = ast.entry(2).entry(1).entry(1)
#						var typedef = [ ast.entry(2).entry(2), ast.entry(2).entry(2) ]
#
#						Env.assign_Static(symbol, )
		
		# Operations
		NType.op_Assign :
			var symbol = ast.entry(1).entry(1)
			var value = eva( ast.entry(2) )
			
			Env.assign_Type(symbol, value)
		
		NType.op_Add : 	
			var astType = ast.entry(1).type()
			var typedef = [ astType ]
			
			typedef.append( eva( ast.entry(1)) + eva( ast.entry(2)) )
			
			evaResult = typedef[1]
		
		# Evaluating Literal
		NType.literal_String : evaResult = ast.to_string()
		NType.literal_Digit  : evaResult = ast.entry(1).to_int()
		NType.literal_Decimal: evaResult = float( ast.entry(1) )
		NType.literal_Char   : evaResult = String( ast.entry(1) )
		NType.literal_False  : evaResult = false
		NType.literal_True   : evaResult = true
		NType.literal_Binary : evaResult = int( ast.entry(1) )
		NType.literal_Hex    : evaResult = int( ast.entry(1) )
		NType.literal_Octal  : evaResult = int( ast.entry(1) )
		
		
	if Parent == null:
		G.MAS_EnvUpdated.emit()
	
	if evaResult == null:
		return null
		
	return evaResult



func _init(parent : Interpreter) -> void:
	Parent = parent
	
	Env = MasEnv.new(parent.Env if parent else null)
	return
