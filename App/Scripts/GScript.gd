class_name GScript extends Node

var MAS         : Interpreter
var TxtPipeline : TextPipeline

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



const TType := Lexer.TType
const SType := TParser.SType
const STxt  := TParser.STxt

const TypeColor := {
	TType.op_Define : Color.AQUA,
	
	SType.unit : Color.TAN,
	
	SType.builtin_Array  : Color.MEDIUM_PURPLE,
	SType.builtin_Dict   : Color.MEDIUM_PURPLE,
	SType.builtin_Bool   : Color.MEDIUM_PURPLE,
	SType.builtin_Float  : Color.MEDIUM_PURPLE,
	SType.builtin_Int    : Color.MEDIUM_PURPLE,
	SType.builtin_String : Color.MEDIUM_PURPLE,
		
	SType.literal_Binary  : Color.SANDY_BROWN,
	SType.literal_Char    : Color.SANDY_BROWN,
	SType.literal_Decimal : Color.SANDY_BROWN,
	SType.literal_Digit   : Color.SANDY_BROWN,
	SType.literal_False   : Color.SANDY_BROWN,
	SType.literal_Hex     : Color.SANDY_BROWN,
	SType.literal_String  : Color.SANDY_BROWN,
	SType.literal_True    : Color.SANDY_BROWN,
	
	SType.op_Call  : Color.BLANCHED_ALMOND,
	SType.op_Cast  : Color.AQUA,
	SType.op_CD    : Color.AQUA,
	SType.op_Break : Color.CHARTREUSE,
		
	SType.op_Alloc  : Color.RED,
	SType.op_Resize : Color.RED,
	SType.op_Free   : Color.RED,
	SType.op_Wipe   : Color.RED,
	
	SType.op_BNot : Color.AQUA,
	SType.op_BAnd : Color.AQUA,
	SType.op_BOr  : Color.AQUA,
	SType.op_BXOr : Color.AQUA,
	SType.op_BSL  : Color.AQUA,
	SType.op_BSR  : Color.AQUA,
	
	SType.op_Equal        : Color.AQUA,
	SType.op_NotEqual     : Color.AQUA,
	SType.op_Greater      : Color.AQUA,
	SType.op_GreaterEqual : Color.AQUA,
	SType.op_Lesser       : Color.AQUA,
	SType.op_LesserEqual  : Color.AQUA,
	
	SType.op_LAnd   : Color.AQUA,
	SType.op_LNot   : Color.AQUA,
	SType.op_LOr    : Color.AQUA,
	SType.op_Ptr    : Color.AQUA,
	SType.op_Return : Color.CHARTREUSE,
	SType.op_SMA    : Color.AQUA,
	
	SType.op_Assign : Color.AQUA,
	SType.op_A_Add  : Color.AQUA,
	
	SType.op_UnaryNeg : Color.AQUA,
	SType.op_Add      : Color.AQUA,
	SType.op_Subtract : Color.AQUA,
	SType.op_Multiply : Color.AQUA,
	SType.op_Divide   : Color.AQUA,
	SType.op_Modulo   : Color.AQUA,
	
	SType.expr_Cap   : Color.CADET_BLUE,
	SType.expr_SBCap : Color.AQUA,

	SType.sec_Allocator  : Color.RED,
	SType.sec_Cap        : Color.LIGHT_GOLDENROD,
	SType.sec_CapArgs    : Color.BLANCHED_ALMOND,
	SType.sec_RetMap     : Color.BLANCHED_ALMOND,
	SType.sec_Cond       : Color.CHARTREUSE,
	SType.sec_Enum       : Color.LIGHT_GOLDENROD,
	SType.sec_Exe        : Color.CHARTREUSE,
	SType.sec_ExeCond    : Color.CHARTREUSE,
	SType.sec_ExeSwitch  : Color.CHARTREUSE,
	SType.sec_External   : Color.GOLD,
	SType.sec_Heap       : Color.RED,
	SType.sec_LP         : Color.LIGHT_GOLDENROD,
	SType.sec_Loop       : Color.CHARTREUSE,
	SType.sec_RO         : Color.LIGHT_GOLDENROD,
	SType.sec_Stack      : Color.RED,
	SType.sec_Static     : Color.RED,
	SType.sec_Struct     : Color.LIGHT_GOLDENROD,
	SType.sec_Switch     : Color.CHARTREUSE,
	SType.sec_SwitchCase : Color.CHARTREUSE,
	SType.sec_TT         : Color.GOLD,
	SType.sec_Type       : Color.LIGHT_GOLDENROD,
	SType.sec_Union      : Color.LIGHT_GOLDENROD,
	SType.sec_Using      : Color.LIGHT_GOLDENROD,
	
	SType.sym_Array   : Color.MEDIUM_PURPLE,
	SType.sym_Proc    : Color.BLANCHED_ALMOND,
	SType.sym_Ptr     : Color.LIGHT_GOLDENROD,
	SType.sym_LP      : Color.GOLDENROD,
	SType.sym_Self    : Color.LIGHT_GOLDENROD,
	SType.sym_Type    : Color.LIGHT_GOLDENROD,
	SType.sym_TT_Type : Color.GOLD,
	SType.sym_TType   : Color.LIGHT_GOLDENROD,
	
	SType.sec_EnumElement : Color.WHITE_SMOKE,
	SType.sec_Identifier  : Color.WHITE,
	SType.sym_Identifier  : Color.WHITE_SMOKE,
}
