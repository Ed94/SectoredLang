# Rename to STree
class_name STree extends Tree

var TypeColor     = GScript.TypeColor

const SType      := TParser.SType
const SAttribute := TParser.SAttribute
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
	
	item.set_custom_color(Type, TypeColor[ ast.Type ])
	item.set_custom_color(Value, TypeColor[ ast.Type ])
	
	item.set_text(Type, ast.Type)
	
	match ast.Type:
		SType.sec_EnumElement:
			item.set_text(Value, ast.name().name())
		
		SType.literal_Binary:
			item.set_text(Value, ast.value())
			
		SType.literal_Char:
			item.set_text(Value, ast.value())
						
		SType.literal_Decimal:
			item.set_text(Value, ast.value())
			
		SType.literal_Digit:
			item.set_text(Value, ast.value())

		SType.literal_False:
			pass
			
		SType.literal_Hex:
			item.set_text(Value, ast.value())
			
		SType.literal_String:
			item.set_text(Value, ast.value())
			
		SType.literal_True:
			pass
			
		SType.op_SMA:
			pass
			
		SType.sec_Allocator:
			item.set_text(Value, ast.name().name())
			
		SType.sec_Cap:
			generate(ast.args(), node)
			
			if ast.ret_Map():
				generate(ast.ret_Map(), node)
			
		SType.sec_Cond:
			pass
			
		SType.sec_Enum:
			if ast.capture():
				generate(ast.capture(), node)
			
		SType.sec_Exe:
			pass

		SType.sec_Loop:
			if ast.cond():
				generate(ast.cond(), node)

		SType.sec_RetMap:
			if ast.expression():
				generate(ast.expression(), node)
					
		SType.sec_Struct:
			pass
			
		SType.sec_Switch:
			generate(ast.cond(), node)
			
		SType.sec_SwitchCase:
			generate(ast.case(), node)
			
		SType.sec_Type:
			pass

		SType.sec_Identifier:
			item.set_text(Value, ast.name())
			
			if ast.ret_Map():
				generate(ast.ret_Map(), node)
			
		SType.sym_Identifier:
			item.set_text(Value, ast.name())
		
	var index := 1
	while index <= ast.Data.size() - 1:
		match typeof( ast.Data[index] ):
			TYPE_STRING:
				var skip = false
				match ast.Type:
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
					
					SType.sec_Allocator: skip = true
					SType.sec_Identifier: if index == 1: skip = true
					
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
	&& (    parent.AST_Node.Type == SType.sec_EnumElement \
		||  parent.AST_Node.Type == SType.sec_Allocator
	) \
	&& ast.Type == SType.sym_Identifier \
	&& parent.AST_Node.Data[1] == ast:
		return
	
	var node = create_NodeItem(ast, parent)

	if ! parent:
		Root = node
		set_hide_root(true)

	var   index := 1
	while index <= ast.num_Entries():
		generate( ast.entry(index), node )
		index += 1

	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	columns = 3
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
