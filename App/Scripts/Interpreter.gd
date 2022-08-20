class_name Interpreter extends RefCounted

const LogType := Log.EType
const NType   := SyntaxParser.NType
#const ASTNode := SyntaxParser.ASTNode


#var AST    : SyntaxParser.ASTNode
var Env    : MasEnv
var Parent : Interpreter


func resolve_Symbol(ast):
	var index = 2;
	if ast.num_Entries() >= 2:
		var resolved = [ ast.entry(1) ]
		
		while index <= ast.num_Entries():
			if ast.entry(index).type() == NType.op_SMA:
				resolved.append( ast.entry(index) )
			index += 1
			
		return resolved
	
	return [ ast ]

func eva(ast):	
	G.Log.out(LogType.log, "Interpreting...")
	
	var evaResult = null
	
	if ast == null:
		return evaResult
	
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
		
		NType.sec_Cap:
			var index  = 1
			var args   = ast.entry(index); index += 1
			var retMap = null
			var body   = null
			
			if ast.entry(index).type() == NType.sec_CapRet:
				retMap = ast.entry(index); index += 1
				
			body = ast.entry(index)
			
			if Parent == null:
				pass

	#region LP_Sectors
		NType.sec_Exe:
			if Parent == null:
				var interp = Interpreter.new(self)
				
				# Execute immediately
				var index = 1
				while index < ast.num_Entries():
					interp.eva( ast.entry(index) )
					index += 1
				
				evaResult = interp.eva( ast.entry(index) )
			else:
				# This will be an named executable bound by a context
				Env.assign_Exe(ast)
				
		NType.sec_Stack:
			eva_Stack(ast)

		NType.sec_Static:
			eva_Static(ast)
	#endregion LP_Sectors
				
		NType.sec_Identifier:
			var symbol = ast.entry(1)
			var interp
			
			if !Env.has(symbol):
				interp = Interpreter.new(self)
				Env.define(symbol, interp.Env)
				
			else:
				interp = Env.lookup(symbol).Interp
				
			interp.eva_Identifier(ast)
			
		#region Operations
		NType.op_Assign :
			eva_op_Assign(ast)
			
		NType.op_LNot:
			var result = [
				ast.entry(1).type(),
				! eva(ast.entry(1))
			]
			
			evaResult = result[1]
			
		NType.op_BNot:
			var result = [
				ast.entry(1).type(),
				~ eva(ast.entry(1))
			]
			
			evaResult = result[1]
			
		NType.op_Multiply:
			var astType = ast.entry(1).type()
			var result = [ astType ]
			
			result.append( eva( ast.entry(1)) * eva( ast.entry(2)) )
			
			evaResult = result[1]
			
		NType.op_Divide:
			var astType = ast.entry(1).type()
			var result = [ astType ]
			
			result.append( eva( ast.entry(1)) / eva( ast.entry(2)) )
			
			evaResult = result[1]
			
		NType.op_Modulo:			
			var astType = ast.entry(1).type()
			var result = [ astType ]
			
			if astType == NType.builtin_int || NType.literal_Digit:
				result.append( eva( ast.entry(1)) % eva( ast.entry(2)) )
			elif astType == NType.builtin_float || NType.literal_Decimal:
				result.append( fmod( 
					eva( ast.entry(1)), eva( ast.entry(2))
				)) 
			
			evaResult = result[1]
		
		NType.op_Add : 	
			var astType = ast.entry(1).type()
			var result = [ astType ]
			
			result.append( eva( ast.entry(1)) + eva( ast.entry(2)) )
			
			evaResult = result[1]
			
		NType.op_Subtract:
			var astType = ast.entry(1).type()
			var result = [ astType ]
			
			result.append( eva( ast.entry(1)) - eva( ast.entry(2)) )
			
			evaResult = result[1]
			
		NType.op_BSL:
			var result = [
				ast.entry(1).type(),
				eva(ast.entry(1)) << eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		NType.op_BSR:
			var result = [
				ast.entry(1).type(),
				eva(ast.entry(1)) >> eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		NType.op_BAnd:
			var result = [
				ast.entry(1).type(),
				eva(ast.entry(1)) & eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		NType.op_BXOr:
			var result = [
				ast.entry(1).type(),
				eva(ast.entry(1)) ^ eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		NType.op_BOr:
			var result = [
				ast.entry(1).type(),
				eva(ast.entry(1)) | eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		NType.op_Greater:
			var result = [
				NType.builtin_bool,
				eva(ast.entry(1)) > eva(ast.entry(2))
			]
			
			evaResult = result[1]
						
		NType.op_GreaterEqual:
			var result = [
				NType.builtin_bool,
				eva(ast.entry(1)) >= eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		NType.op_Lesser:
			var result = [
				NType.builtin_bool,
				eva(ast.entry(1)) < eva(ast.entry(2))
			]
			
			evaResult = result[1]
		
		NType.op_LesserEqual:
			var result = [
				NType.builtin_bool,
				eva(ast.entry(1)) <= eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		NType.op_Equal:
			var result = [
				NType.builtin_bool,
				eva(ast.entry(1)) == eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		NType.op_NotEqual:
			var result = [
				NType.builtin_bool,
				eva(ast.entry(1)) != eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		NType.op_LAnd:
			var result = [
				NType.builtin_bool,
				eva(ast.entry(1) && eva(ast.entry(2)))
			]
			
			evaResult = result[1]
			
		NType.op_LOr:
			var result = [ 
				NType.builtin_bool, 
				eva(ast.entry(1)) || eva(ast.entry(2)) 
			]
			
			evaResult = result[1]
		
		NType.op_CD:
			eva( ast.entry(1) )
			
			evaResult = eva( ast.entry(2) )
		#endregion Operations
	
		NType.sym_Identifier: 
			evaResult = Env.lookup( resolve_Symbol(ast) )
		
		# Evaluating Literal
		NType.literal_String : evaResult = ast.string()
		NType.literal_Digit  : evaResult = [ NType.builtin_int, ast.entry(1).to_int() ]
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
	
func eva_Identifier(ast):
	var index = 1;
	while index < ast.num_Entries():
		index += 1;
		var current = ast.entry(index)
		match current.type():
			NType.sec_Type:
				var astType = current.entry(1)
				var typedef = [ astType ]
					
				if current.num_Entries() > 1:
					var value = eva( current.entry(2) )
					
					typedef.append( current )
					
				Env.assign_Type(typedef)
					
			# TODO:
			NType.sec_Static:		
				eva_Static(current)

func eva_Stack(ast):
	var index = 1
	var count = ast.num_Entries()
	
	while index <= ast.num_Entries():
		var current = ast.entry(index)
		var symbol  = current.entry(1)
		var type    = [ current.entry(2).entry(1) ]
				
		if current.entry(2).num_Entries() > 1:
			type.append( eva(current.entry(2).entry(2) ) )
			
		Env.assign_Stack(symbol, type)
		index += 1

func eva_Static(ast):
	var index = 1
	var count = ast.num_Entries()
	
	while index <= ast.num_Entries():
		var current = ast.entry(index)
		var symbol  = current.entry(1)
		var type    = [ current.entry(2).entry(1) ]
				
		if current.entry(2).num_Entries() > 1:
			type.append( eva(current.entry(2).entry(2) ) )
			
		Env.assign_Static(symbol, type)
		index += 1
			
func eva_op_Assign(ast):
	var lvalue = resolve_Symbol( ast.entry(1) )
			
	var rvalue = []
	match ast.entry(2).type():
		NType.literal_Digit   : rvalue.append(NType.builtin_int)
		NType.literal_Decimal : rvalue.append(NType.builtin_float)
		NType.literal_String  : rvalue.append(NType.builtin_string)
		NType.literal_Char    : rvalue.append(NType.builtin_string) 
		NType.literal_True    : rvalue.append(NType.builtin_bool)
		NType.literal_False   : rvalue.append(NType.builtin_bool)
		NType.literal_Binary  : rvalue.append(NType.builtin_int) 
		NType.literal_Octal   : rvalue.append(NType.builtin_int) 
		NType.literal_Hex     : rvalue.append(NType.builtin_int) 
			
	if rvalue.size():
		rvalue.append( eva( ast.entry(2)) )
	else:
		rvalue = eva( ast.entry(2) )
				
	Env.assign(lvalue, rvalue)

#region Object
func _init(parent : Interpreter) -> void:
	Parent = parent
	
	Env = MasEnv.new(Parent.Env if Parent else null, self)
	return
#endregion Object
