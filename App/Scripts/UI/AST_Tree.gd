class_name AST_Tree extends Tree

var TypeColor = GScript.TypeColor
const NType := SyntaxParser.NType
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
		NType.enum_Element:
			item.set_text(Value, ast.Data[1].Data[1])
		
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
			item.set_text(Value, ast.Data[1].Data[1])
			
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
					NType.enum_Element: if index == 1: skip = true
					
					NType.literal_Binary: skip = true
					NType.literal_Char: skip = true
					NType.literal_Decimal: skip = true
					NType.literal_Digit: skip = true
					NType.literal_False: skip = true
					NType.literal_Hex: skip = true
					NType.literal_Octal: skip = true
					NType.literal_String : skip = true
					NType.literal_True: skip = true
					
					NType.op_SMA : if index == 1: skip = true
					
					NType.sec_Allocator: skip = true
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
	
	if parent \
	&& (    parent.AST_Node.type() == NType.op_SMA \
		||  parent.AST_Node.type() == NType.enum_Element \
		||  parent.AST_Node.type() == NType.sec_Allocator
	) \
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
