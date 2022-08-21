class_name AST_Tree extends Tree

const NType := SyntaxParser.NType
const Type  := 0
const Value := 1
const Focus := 2

const TypeColor = {
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
	
	NType.op_Call : Color.BLANCHED_ALMOND,
	NType.op_Cast : Color.AQUA,
	NType.op_CD : Color.AQUA,
	NType.op_Break : Color.CHARTREUSE,
		
	NType.op_Alloc : Color.RED,
	NType.op_Resize : Color.RED,
	NType.op_Free : Color.RED,
	NType.op_Wipe : Color.RED,
	
	NType.op_BNot : Color.AQUA,
	NType.op_BAnd : Color.AQUA,
	NType.op_BOr : Color.AQUA,
	NType.op_BXOr : Color.AQUA,
	NType.op_BSL : Color.AQUA,
	NType.op_BSR : Color.AQUA,
	
	NType.op_Equal : Color.AQUA,
	NType.op_NotEqual : Color.AQUA,
	NType.op_Greater : Color.AQUA,
	NType.op_GreaterEqual : Color.AQUA,
	NType.op_Lesser : Color.AQUA,
	NType.op_LesserEqual : Color.AQUA,
	
	NType.op_LAnd : Color.AQUA,
	NType.op_LNot : Color.AQUA,
	NType.op_LOr : Color.AQUA,
	NType.op_Ptr : Color.AQUA,
	NType.op_Return : Color.CHARTREUSE,
	NType.op_SMA : Color.AQUA,
	
	NType.op_Assign : Color.AQUA,
	NType.op_A_Add : Color.AQUA,
	
	NType.op_UnaryNeg : Color.AQUA,
	NType.op_Add : Color.AQUA,
	NType.op_Subtract : Color.AQUA,
	NType.op_Multiply : Color.AQUA,
	NType.op_Divide : Color.AQUA,
	NType.op_Modulo : Color.AQUA,
	
	NType.expr : Color.CADET_BLUE,
	NType.expr_Cap : Color.CADET_BLUE,
	NType.expr_SBCap : Color.AQUA,

	NType.sec_Allocator : Color.RED,
	NType.sec_Cap : Color.LIGHT_GOLDENROD,
	NType.sec_CapArgs: Color.BLANCHED_ALMOND,
	NType.sec_CapRet: Color.BLANCHED_ALMOND,
	NType.sec_Cond : Color.CHARTREUSE,
	NType.sec_Enum : Color.LIGHT_GOLDENROD,
	NType.sec_Exe : Color.CHARTREUSE,
	NType.sec_Heap : Color.RED,
	NType.sec_LP : Color.LIGHT_GOLDENROD,
	NType.sec_Loop : Color.CHARTREUSE,
	NType.sec_LoopCond : Color.CHARTREUSE,
	NType.sec_RO : Color.LIGHT_GOLDENROD,
	NType.sec_Stack : Color.RED,
	NType.sec_Static : Color.RED,
	NType.sec_Struct : Color.LIGHT_GOLDENROD,
	NType.sec_Switch : Color.CHARTREUSE,
	NType.sec_SwitchCase : Color.CHARTREUSE,
	NType.sec_TT : Color.GOLD,
	NType.sec_Type : Color.LIGHT_GOLDENROD,
	NType.sec_Union : Color.LIGHT_GOLDENROD,
	NType.sec_Using : Color.LIGHT_GOLDENROD,
	
	NType.sym_Array : Color.MEDIUM_PURPLE,
	NType.sym_Proc : Color.BLANCHED_ALMOND,
	NType.sym_Ptr : Color.LIGHT_GOLDENROD,
	NType.sym_LP : Color.GOLDENROD,
	NType.sym_Self : Color.LIGHT_GOLDENROD,
	NType.sym_TT_Type : Color.GOLD,
	NType.sym_TType : Color.LIGHT_GOLDENROD,
	
	NType.enum_Element : Color.WHITE_SMOKE,
	NType.sec_Identifier : Color.TOMATO,
	NType.sym_Identifier : Color.WHITE_SMOKE,
}

class TNode extends RefCounted:
	var Item     : TreeItem
	var AST_Node

	func _init(astNode, item, parent):
		Item     = item
		AST_Node = astNode

var Root

func populate(node):
	var item = node.Item
	var ast = node.AST_Node
	
	item.set_custom_color(Type, TypeColor[ ast.type() ])
	item.set_custom_color(Value, TypeColor[ ast.type() ])
	
	item.set_text(Type, ast.type())
	
	match ast.type():
		NType.literal_Binary:
			item.set_text(Value, ast.Data[1])
			
		NType.literal_Char:
			item.set_text(Value, ast.Data[1])
						
		NType.literal_Decimal:
			item.set_text(Value, ast.Data[1])
			
		NType.literal_Digit:
			item.set_text(Value, ast.Data[1])

		NType.literal_False:
			pass
			
		NType.literal_Hex:
			item.set_text(Value, ast.Data[1])
			
		NType.literal_String:
			item.set_text(Value, ast.Data[1])
			
		NType.literal_True:
			pass
			
		NType.op_SMA:
			if ast.Data[1].Data.size() > 1 && typeof(ast.Data[1].Data[1]) == TYPE_STRING :
				item.set_text(Value, ast.Data[1].Data[1])
			
		NType.sec_Allocator:
			pass
			
		NType.sec_Cap:
			pass
			
		NType.sec_Cond:
			pass
			
		NType.sec_Enum:
			pass
			
		NType.sec_Exe:
			pass
			
		NType.sec_Heap:
			pass
			
		NType.sec_Struct:
			pass
			
		NType.sec_Switch:
			pass
			
		NType.sec_SwitchCase:
			pass
			
		NType.sec_Type:
			if typeof(ast.Data[1]) == TYPE_STRING: 
				item.set_text(Value, ast.Data[1])
			
		NType.sec_TT:
			pass
		
		NType.sec_Identifier:
			item.set_text(Value, ast.Data[1])
			
		NType.sym_Identifier:
			item.set_text(Value, ast.Data[1])
		
	var index := 1
	while index <= ast.Data.size() - 1:
		match typeof( ast.Data[index] ):
			TYPE_STRING:
				var skip = false
				match ast.type():
					NType.literal_True: skip = true
					NType.literal_False: skip = true
					NType.op_SMA : if index == 1: skip = true
					NType.sec_Type: skip = true
					NType.sec_Identifier: skip = true
					NType.sym_Identifier: skip = true
					
				if skip : continue
										
				create_item( item ).set_text(0, ast.Data[index])
				
		index += 1
		
	return


func create_NodeItem(astNode, parent = null):
	var nodeItem
	if parent:
		nodeItem = TNode.new(astNode, create_item(parent.Item), self)
	else:
		nodeItem = TNode.new(astNode, create_item(), self)
		
	populate(nodeItem)
		
	return nodeItem
	
	
func generate(ast, parent = null):
	if typeof(ast) != TYPE_OBJECT:
		return
	
	if parent && parent.AST_Node.type() == NType.op_SMA \
	&& ast.type() == NType.sym_Identifier \
	&& parent.AST_Node.Data[1] == ast:
		return
	
	var node = create_NodeItem(ast, parent)
		
	if ! parent:
		Root = node
		set_hide_root(true)
	
	var   index := 1
	while index <= ast.Data.size() - 1:
		generate( ast.Data[index], node )
		index += 1

	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	columns = 3
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
