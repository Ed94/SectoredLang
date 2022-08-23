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
const NType := SyntaxParser.NType
const NTxt  := SyntaxParser.NTxt

const TypeColor := {
	TType.op_Define : Color.AQUA,
	
	NType.unit : Color.TAN,
	
	NType.builtin_Array  : Color.MEDIUM_PURPLE,
	NType.builtin_Dict   : Color.MEDIUM_PURPLE,
	NType.builtin_bool   : Color.MEDIUM_PURPLE,
	NType.builtin_float  : Color.MEDIUM_PURPLE,
	NType.builtin_int    : Color.MEDIUM_PURPLE,
	NType.builtin_string : Color.MEDIUM_PURPLE,
		
	NType.literal_Binary  : Color.SANDY_BROWN,
	NType.literal_Char    : Color.SANDY_BROWN,
	NType.literal_Decimal : Color.SANDY_BROWN,
	NType.literal_Digit   : Color.SANDY_BROWN,
	NType.literal_False   : Color.SANDY_BROWN,
	NType.literal_Hex     : Color.SANDY_BROWN,
	NType.literal_String  : Color.SANDY_BROWN,
	NType.literal_True    : Color.SANDY_BROWN,
	
	NType.op_Call  : Color.BLANCHED_ALMOND,
	NType.op_Cast  : Color.AQUA,
	NType.op_CD    : Color.AQUA,
	NType.op_Break : Color.CHARTREUSE,
		
	NType.op_Alloc  : Color.RED,
	NType.op_Resize : Color.RED,
	NType.op_Free   : Color.RED,
	NType.op_Wipe   : Color.RED,
	
	NType.op_BNot : Color.AQUA,
	NType.op_BAnd : Color.AQUA,
	NType.op_BOr  : Color.AQUA,
	NType.op_BXOr : Color.AQUA,
	NType.op_BSL  : Color.AQUA,
	NType.op_BSR  : Color.AQUA,
	
	NType.op_Equal        : Color.AQUA,
	NType.op_NotEqual     : Color.AQUA,
	NType.op_Greater      : Color.AQUA,
	NType.op_GreaterEqual : Color.AQUA,
	NType.op_Lesser       : Color.AQUA,
	NType.op_LesserEqual  : Color.AQUA,
	
	NType.op_LAnd   : Color.AQUA,
	NType.op_LNot   : Color.AQUA,
	NType.op_LOr    : Color.AQUA,
	NType.op_Ptr    : Color.AQUA,
	NType.op_Return : Color.CHARTREUSE,
	NType.op_SMA    : Color.AQUA,
	
	NType.op_Assign : Color.AQUA,
	NType.op_A_Add  : Color.AQUA,
	
	NType.op_UnaryNeg : Color.AQUA,
	NType.op_Add      : Color.AQUA,
	NType.op_Subtract : Color.AQUA,
	NType.op_Multiply : Color.AQUA,
	NType.op_Divide   : Color.AQUA,
	NType.op_Modulo   : Color.AQUA,
	
	NType.expr_Cap   : Color.CADET_BLUE,
	NType.expr_SBCap : Color.AQUA,

	NType.sec_Allocator  : Color.RED,
	NType.sec_Cap        : Color.LIGHT_GOLDENROD,
	NType.sec_CapArgs    : Color.BLANCHED_ALMOND,
	NType.sec_CapRet     : Color.BLANCHED_ALMOND,
	NType.sec_Cond       : Color.CHARTREUSE,
	NType.sec_Enum       : Color.LIGHT_GOLDENROD,
	NType.sec_Exe        : Color.CHARTREUSE,
	NType.sec_Heap       : Color.RED,
	NType.sec_LP         : Color.LIGHT_GOLDENROD,
	NType.sec_Loop       : Color.CHARTREUSE,
	NType.sec_LoopCond   : Color.CHARTREUSE,
	NType.sec_RO         : Color.LIGHT_GOLDENROD,
	NType.sec_Stack      : Color.RED,
	NType.sec_Static     : Color.RED,
	NType.sec_Struct     : Color.LIGHT_GOLDENROD,
	NType.sec_Switch     : Color.CHARTREUSE,
	NType.sec_SwitchCase : Color.CHARTREUSE,
	NType.sec_TT         : Color.GOLD,
	NType.sec_Type       : Color.LIGHT_GOLDENROD,
	NType.sec_Union      : Color.LIGHT_GOLDENROD,
	NType.sec_Using      : Color.LIGHT_GOLDENROD,
	
	NType.sym_Array   : Color.MEDIUM_PURPLE,
	NType.sym_Proc    : Color.BLANCHED_ALMOND,
	NType.sym_Ptr     : Color.LIGHT_GOLDENROD,
	NType.sym_LP      : Color.GOLDENROD,
	NType.sym_Self    : Color.LIGHT_GOLDENROD,
	NType.sym_TT_Type : Color.GOLD,
	NType.sym_TType   : Color.LIGHT_GOLDENROD,
	
	NType.enum_Element   : Color.WHITE_SMOKE,
	NType.sec_Identifier : Color.WHITE,
	NType.sym_Identifier : Color.WHITE_SMOKE,
}
