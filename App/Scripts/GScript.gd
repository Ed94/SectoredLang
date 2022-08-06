class_name GScript extends Node

# Glboal Ref to interpreter
var MAS : Interpreter
var AST

signal MAS_EnvUpdated

# Global output buffer
var   Log     : Log
const LogType = Log.EType;


#region Assertions
const allgood = true

class Error :
	var bAssert := false
	var Message : String
	
	func get_class(): 
		return "ErrorClass"
	
	func _init(shouldAssert, msg):
		bAssert = shouldAssert
		Message = msg


func check(obj, message = ""):
	var stack      := get_stack(); stack.remove_at(0)
	var stacktrace := "CallStack: " + JSON.new().stringify(stack, "\t")
	
	if typeof(obj) == TYPE_BOOL:
		if obj == false:
			Log.out(LogType.error, message + "\n" + stacktrace)
			return true
	
	elif obj == null:
		Log.out(LogType.error, "Check: Object is null. Message: " + message + "\n" + stacktrace)
		return true
		
	elif obj.get_class() == "ErrorClass":
		if obj.bAssert:
			assert(false, "ErrorClass assertion") # Ignore error, its a bug with gd 4
			
		Log.out(LogType.error, obj.Message + "\n" + stacktrace)
		return true
		
	return false
	
func throw(error):
	var stack      := get_stack(); stack.remove_at(0)
	var stacktrace := "CallStack: " + JSON.new().stringify(stack, "\t")
	
	if error == null:
		Log.out(LogType.error, "throw: error argument is null!!!" + "\n" + stacktrace)
		
	elif error.get_class() == "ErrorClass":
		if error.bAssert:
			assert(false, "ErrorClass assertion") # Ignore error, its a bug with gd 4
			
		Log.out(LogType.error, error.Message + "\n" + stacktrace)
	
	else:
		Log.out(LogType.error, "throw: error argument is not derived from ErrorClass!" + "\n" + stacktrace)
#endregion Assertions
