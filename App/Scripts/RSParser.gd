# Not sure about this yet...
# Node Parser
# Parses SNodes to resolve more concrete symbols from the program model.
# These are the nodes provided to the backend.

class_name RSParser extends Object

const SType  = TParser.SType
var   SNode  = TParser.SNode

const RSType := {
	unit = "Unit",
	
	type_alias  = "Type: Alias",
	type_enum   = "Type: Enum",
	type_struct = "Type: Struct",
	type_union  = "Type: Union",
	
	type_layout = "Type: Layout",
	
	constant  = "Constant",
	
	static_var = "Static Variable",
	static_ro  = "Static Readonly",
	
	procedure = "Procedure",
	
	exe        = "Execution",
	exe_cond   = "Execution: Conditional",
	exe_loop   = "Execution: Iterator",
	exe_switch = "Execution: Switch",
	exe_break  = "Exeuction: Break",
	exe_cont   = "Execution: Continue",
	exe_fall   = "Execution: Fall",
	exe_goto   = "Exeuction: Jump",
	exe_return = "Execution: Return",
	
	op = "Op",
	op_cast = "Op: Cast",
	
	stack_var = "Stack Variable",
	stack_ro  = "Stack Readonly",
}

class SRange : 
	var Start
	var End

class RSNode extends RefCounted:
	var Type    : String
	var Context : Array
	var Data    : Array
	
class TAlias extends RSNode:
	func typedef():
		return Data[0]
	
	func _init():
		Type = RSType.exe
		
class TEnum extends RSNode:
	func member( id ):
		return Data[id]
		
	func _init():
		Type = RSType.type_enum
	
class Procedure extends RSNode:
	func captures():
		return Data[0]
		
	func execution():
		return Data[1]
	
	func _init():
		Type = RSType.exe
		
		
