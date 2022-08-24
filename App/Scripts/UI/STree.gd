# Rename to STree
class_name STree extends Tree

var TypeColor = GScript.TypeColor
const SType := TParser.SType
const Type  := 0
const Value := 1
const Focus := 2

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
		SType.sec_EnumElement:
			item.set_text(Value, ast.Data[1].Data[1])
		
		SType.literal_Binary:
			item.set_text(Value, ast.Data[1])
			
		SType.literal_Char:
			item.set_text(Value, ast.Data[1])
						
		SType.literal_Decimal:
			item.set_text(Value, ast.Data[1])
			
		SType.literal_Digit:
			item.set_text(Value, ast.Data[1])

		SType.literal_False:
			pass
			
		SType.literal_Hex:
			item.set_text(Value, ast.Data[1])
			
		SType.literal_String:
			item.set_text(Value, ast.Data[1])
			
		SType.literal_True:
			pass
			
		SType.op_SMA:
			if ast.Data[1].Data.size() > 1 && typeof(ast.Data[1].Data[1]) == TYPE_STRING :
				item.set_text(Value, ast.Data[1].Data[1])
			
		SType.sec_Allocator:
			item.set_text(Value, ast.Data[1].Data[1])
			
		SType.sec_Cap:
			pass
			
		SType.sec_Cond:
			pass
			
		SType.sec_Enum:
			pass
			
		SType.sec_Exe:
			pass
			
		SType.sec_Heap:
			pass
			
		SType.sec_Struct:
			pass
			
		SType.sec_Switch:
			pass
			
		SType.sec_SwitchCase:
			pass
			
		SType.sec_Type:
			if typeof(ast.Data[1]) == TYPE_STRING: 
				item.set_text(Value, ast.Data[1])
			
		SType.sec_TT:
			pass
		
		SType.sec_Identifier:
			item.set_text(Value, ast.Data[1])
			
		SType.sym_Identifier:
			item.set_text(Value, ast.Data[1])
		
	var index := 1
	while index <= ast.Data.size() - 1:
		match typeof( ast.Data[index] ):
			TYPE_STRING:
				var skip = false
				match ast.type():
					SType.sec_EnumElement: if index == 1: skip = true
					
					SType.literal_Binary: skip = true
					SType.literal_Char: skip = true
					SType.literal_Decimal: skip = true
					SType.literal_Digit: skip = true
					SType.literal_False: skip = true
					SType.literal_Hex: skip = true
					SType.literal_Octal: skip = true
					SType.literal_String : skip = true
					SType.literal_True: skip = true
					
					SType.op_SMA : if index == 1: skip = true
					
					SType.sec_Allocator: skip = true
					SType.sec_Type: skip = true
					SType.sec_Identifier: skip = true
					
					SType.sym_Identifier: skip = true
					
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
	
	if parent \
	&& (    parent.AST_Node.type() == SType.op_SMA \
		||  parent.AST_Node.type() == SType.sec_EnumElement \
		||  parent.AST_Node.type() == SType.sec_Allocator
	) \
	&& ast.type() == SType.sym_Identifier \
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
