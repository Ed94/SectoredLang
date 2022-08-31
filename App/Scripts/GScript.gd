class_name GScript extends Node

var Persistent : PersistentType
var Pipeline   : Pipeline

signal PersistentReady
signal PipelineReady


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

const CExec   := Color8(135, 205, 97)
const CMemory := Color8(227, 66, 70)
const COp     := Color8(36, 194, 254)
const CType   := Color8(255, 233, 124)


const TypeColor := {
	TType.op_Define : COp,
	TType.sec_Else  : COp,
	
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
	
	"op" : COp,
	SType.op_Dependent : Color.BLANCHED_ALMOND,
	SType.op_Cast      : COp,
	SType.op_CD        : COp,
	SType.op_Break     : CExec,
	SType.op_Continue  : CExec,
	SType.op_GoTo      : CExec,
	SType.op_Fall      : CExec,
	
	SType.op_AlignOf  : COp,
	SType.op_OffsetOf : COp,
	SType.op_PosOf    : COp,
	SType.op_SizeOf   : COp,

	SType.op_Alloc  : CMemory,
	SType.op_Resize : CMemory,
	SType.op_Free   : CMemory,
	SType.op_Wipe   : CMemory,
	
	SType.op_AB_Not : COp,
	SType.op_AB_And : COp,
	SType.op_AB_Or  : COp,
	SType.op_AB_XOr : COp,
	SType.op_AB_SL  : COp,
	SType.op_AB_SR  : COp,
	
	SType.op_BNot : COp,
	SType.op_BAnd : COp,
	SType.op_BOr  : COp,
	SType.op_BXOr : COp,
	SType.op_BSL  : COp,
	SType.op_BSR  : COp,
	
	SType.op_Equal        : COp,
	SType.op_NotEqual     : COp,
	SType.op_Greater      : COp,
	SType.op_GreaterEqual : COp,
	SType.op_Lesser       : COp,
	SType.op_LesserEqual  : COp,
	
	SType.op_LAnd   : COp,
	SType.op_LNot   : COp,
	SType.op_LOr    : COp,
	SType.op_Ptr    : COp,
	SType.op_Val    : COp,
	SType.op_Return : CExec,
	SType.op_SMA    : COp,
	
	SType.op_Assign : COp,
	SType.op_A_Add  : COp,
	
	SType.op_UnaryNeg : COp,
	SType.op_Add      : COp,
	SType.op_Subtract : COp,
	SType.op_Multiply : COp,
	SType.op_Divide   : COp,
	SType.op_Modulo   : COp,
	
	SType.expr_Cap   : Color.CADET_BLUE,
	SType.expr_SBCap : COp,

	SType.sec_Alias      : Color.GOLD,
	SType.sec_Allocator  : CMemory,
	SType.sec_Cap        : Color.TEAL,
	SType.sec_CapArgs    : Color.BLANCHED_ALMOND,
	SType.sec_Cond       : CExec,
	SType.sec_CondBody   : CExec,
	SType.sec_Enum       : CType,
	SType.sec_Exe        : CExec,
	SType.sec_External   : Color.GOLD,
	SType.sec_Heap       : CMemory,
	SType.sec_Label      : CExec,
	SType.sec_Layer      : Color.GOLD,
	SType.sec_Layout     : CType,
	SType.sec_Loop       : CExec,
	SType.sec_RO         : CType,
	SType.sec_RetMap     : Color.BLANCHED_ALMOND,
	SType.sec_Stack      : CMemory,
	SType.sec_Static     : CMemory,
	SType.sec_Struct     : CType,
	SType.sec_Switch     : CExec,
	SType.sec_SwitchCase : CExec,
	SType.sec_Trait      : Color.GOLD,
	SType.sec_TT         : Color.GOLD,
	SType.sec_Type       : CType,
	SType.sec_Union      : CType,
	SType.sec_Using      : CType,
	SType.sec_Virtual    : Color.GOLD,
	
	SType.sym_Allocator : CMemory,
	SType.sym_Array     : Color.MEDIUM_PURPLE,
	SType.sym_Proc      : Color.BLANCHED_ALMOND,
	SType.sym_Ptr       : CType,
	SType.sym_LP        : Color.GOLDENROD,
	SType.sym_Null      : Color.SANDY_BROWN,
	SType.sym_RO        : CType,
	SType.sym_Self      : CType,
	SType.sym_Type      : CType,
	SType.sym_TT_Type   : Color.GOLD,
	SType.sym_TType     : CType,
	
	SType.sec_EnumElement : Color.WHITE_SMOKE,
	SType.sec_Identifier  : Color.WHITE,
	SType.sym_Identifier  : Color.WHITE_SMOKE,
}
