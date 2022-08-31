class_name Interpreter extends RefCounted

const LogType := Log.EType
const SType   := TParser.SType


#var AST    : SyntaxParser.ASTNode
var Env    : MasEnv
var Parent : Interpreter


func resolve_Symbol(ast):
	var index = 2;
	if ast.num_Entries() >= 2:
		var resolved = [ ast.entry(1) ]
		
		while index <= ast.num_Entries():
			if ast.entry(index).Type == SType.op_SMA:
				resolved.append( ast.entry(index) )
			index += 1
			
		return resolved
	
	return [ ast ]

func eva(ast):	
	G.Log.out(LogType.log, "Interpreting...")
	
	var evaResult = null
	
	if ast == null:
		return evaResult

	match ast.Type:
		SType.unit:
			if ast.num_Entries() == 0:
				continue
			
			var index = 1
			while index < ast.num_Entries(): 	 		
				eva( ast.entry(index) )
				index += 1
		
			var result = eva( ast.entry(index) )
			if result:
				if typeof(result) == TYPE_OBJECT \
				&& result.has_method("typename") \
				&& result.typename() == "ASTNode":
					JSON.new().stringify(result.to_SExpression())
					
				evaResult = str(result)
				
		SType.sec_Allocator:
			pass
		
		SType.sec_Cap:
			var index  = 1
			var args   = ast.entry(index); index += 1
			var retMap = null
			var body   = null
			
			if ast.entry(index).Type == SType.sec_RetMap:
				retMap = ast.entry(index); index += 1
				
			body = ast.entry(index)
			
			if Parent == null:
				pass
	
		SType.sec_Exe:
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
				
		SType.sec_Stack:
			eva_Stack(ast)

		SType.sec_Static:
			eva_Static(ast)
				
		SType.sec_Identifier:
			var symbol = ast.entry(1)
			var interp
			
			if !Env.has(symbol):
				interp = Interpreter.new(self)
				Env.define(symbol, interp.Env)
				
			else:
				interp = Env.lookup(symbol).Interp
				
			interp.eva_Identifier(ast)
			
		#region Operations
		SType.op_Assign :
			eva_op_Assign(ast)
			
		SType.op_LNot:
			var result = [
				ast.entry(1).Type,
				! eva(ast.entry(1))
			]
			
			evaResult = result[1]
			
		SType.op_BNot:
			var result = [
				ast.entry(1).Type,
				~ eva(ast.entry(1))
			]
			
			evaResult = result[1]
			
		SType.op_Multiply:
			var astType = ast.entry(1).Type
			var result = [ astType ]
			
			result.append( eva( ast.entry(1)) * eva( ast.entry(2)) )
			
			evaResult = result[1]
			
		SType.op_Divide:
			var astType = ast.entry(1).Type
			var result = [ astType ]
			
			result.append( eva( ast.entry(1)) / eva( ast.entry(2)) )
			
			evaResult = result[1]
			
		SType.op_Modulo:			
			var astType = ast.entry(1).Type
			var result = [ astType ]
			
			if astType == SType.builtin_Int || SType.literal_Digit:
				result.append( eva( ast.entry(1)) % eva( ast.entry(2)) )
			elif astType == SType.builtin_Float || SType.literal_Decimal:
				result.append( fmod( 
					eva( ast.entry(1)), eva( ast.entry(2))
				)) 
			
			evaResult = result[1]
		
		SType.op_Add : 	
			var astType = ast.entry(1).Type
			var result = [ astType ]
			
			result.append( eva( ast.entry(1)) + eva( ast.entry(2)) )
			
			evaResult = result[1]
			
		SType.op_Subtract:
			var astType = ast.entry(1).Type
			var result = [ astType ]
			
			result.append( eva( ast.entry(1)) - eva( ast.entry(2)) )
			
			evaResult = result[1]
			
		SType.op_BSL:
			var result = [
				ast.entry(1).Type,
				eva(ast.entry(1)) << eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		SType.op_BSR:
			var result = [
				ast.entry(1).Type,
				eva(ast.entry(1)) >> eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		SType.op_BAnd:
			var result = [
				ast.entry(1).Type,
				eva(ast.entry(1)) & eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		SType.op_BXOr:
			var result = [
				ast.entry(1).Type,
				eva(ast.entry(1)) ^ eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		SType.op_BOr:
			var result = [
				ast.entry(1).Type,
				eva(ast.entry(1)) | eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		SType.op_Greater:
			var result = [
				SType.builtin_Bool,
				eva(ast.entry(1)) > eva(ast.entry(2))
			]
			
			evaResult = result[1]
						
		SType.op_GreaterEqual:
			var result = [
				SType.builtin_Bool,
				eva(ast.entry(1)) >= eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		SType.op_Lesser:
			var result = [
				SType.builtin_Bool,
				eva(ast.entry(1)) < eva(ast.entry(2))
			]
			
			evaResult = result[1]
		
		SType.op_LesserEqual:
			var result = [
				SType.builtin_Bool,
				eva(ast.entry(1)) <= eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		SType.op_Equal:
			var result = [
				SType.builtin_Bool,
				eva(ast.entry(1)) == eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		SType.op_NotEqual:
			var result = [
				SType.builtin_Bool,
				eva(ast.entry(1)) != eva(ast.entry(2))
			]
			
			evaResult = result[1]
			
		SType.op_LAnd:
			var result = [
				SType.builtin_Bool,
				eva(ast.entry(1) && eva(ast.entry(2)))
			]
			
			evaResult = result[1]
			
		SType.op_LOr:
			var result = [ 
				SType.builtin_Bool, 
				eva(ast.entry(1)) || eva(ast.entry(2)) 
			]
			
			evaResult = result[1]
		
		SType.op_CD:
			eva( ast.entry(1) )
			
			evaResult = eva( ast.entry(2) )
		#endregion Operations
	
		SType.sym_Identifier: 
			evaResult = Env.lookup( resolve_Symbol(ast) )
		
		# Evaluating Literal
		SType.literal_String : evaResult = ast.string()
		SType.literal_Digit  : evaResult = [ SType.builtin_Int, ast.entry(1).to_int() ]
		SType.literal_Decimal: evaResult = float( ast.entry(1) )
		SType.literal_Char   : evaResult = String( ast.entry(1) )
		SType.literal_False  : evaResult = false
		SType.literal_True   : evaResult = true
		SType.literal_Binary : evaResult = int( ast.entry(1) )
		SType.literal_Hex    : evaResult = int( ast.entry(1) )
		SType.literal_Octal  : evaResult = int( ast.entry(1) )
		
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
		match current.Type:
			SType.sec_Type:
				var astType = current.entry(1)
				var typedef = [ astType ]
					
				if current.num_Entries() > 1:
					var value = eva( current.entry(2) )
					
					typedef.append( current )
					
				Env.assign_Type(typedef)
					
			# TODO:
			SType.sec_Static:		
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
	match ast.entry(2).Type:
		SType.literal_Digit   : rvalue.append(SType.builtin_Int)
		SType.literal_Decimal : rvalue.append(SType.builtin_Float)
		SType.literal_String  : rvalue.append(SType.builtin_String)
		SType.literal_Char    : rvalue.append(SType.builtin_String) 
		SType.literal_True    : rvalue.append(SType.builtin_Bool)
		SType.literal_False   : rvalue.append(SType.builtin_Bool)
		SType.literal_Binary  : rvalue.append(SType.builtin_Int) 
		SType.literal_Octal   : rvalue.append(SType.builtin_Int) 
		SType.literal_Hex     : rvalue.append(SType.builtin_Int) 
			
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
