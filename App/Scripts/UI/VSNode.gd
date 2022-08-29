class_name VSNode extends VBoxContainer

const TType     := Lexer.TType
const STxt      := TParser.STxt
const SType     := TParser.SType
const TypeColor := GScript.TypeColor

const VContentPad_MinSize := Vector2i(0, 0)
const Spacer_MinSize      := Vector2i(0, 6)
const Header_MinSize      := Vector2i(300, 0)
const Indent_MinSize       := Vector2i(6, 0)

const Indent_HSpacer_MinSize := Vector2i(20, 0)


var Parent     : VSNode
var AST    
var VContentPad : VSplitContainer
var Content     : HBoxContainer
var HB          : HBoxContainer
var VIndent     : Panel
var Indent      : HSplitContainer
var VB          : VBoxContainer
var Stack       := []
var Children    := []
var Fmt_NLines  := []


#region Visuals
func create_Label(text, type, container = null):
	if container == null: container = Content
	
	var \
	label = Label.new()
	label.text = text
	label.grow_horizontal = 1
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override( "font_color", TypeColor[type] )
	container.add_child(label)

func create_ASTLabel(ast, container = null):
	if ast       == null: ast       = AST
	if container == null: container = Content
	
	var \
	label = Label.new()
	label.text = ast.name() if typeof(ast) == TYPE_OBJECT else STxt[ast]
	label.name = label.text
	label.grow_horizontal = 1
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override( "font_color", TypeColor[ast.Type]  if typeof(ast) == TYPE_OBJECT else TypeColor[ast] )
	container.add_child(label)

func create_Body(ast):
	HB = HBoxContainer.new()
	HB.custom_minimum_size = Header_MinSize
	HB.name = "HB"
	self.add_child(HB)
					
	VIndent = Panel.new()
	VIndent.custom_minimum_size = Indent_MinSize
	VIndent.name = "VIndent"
	
	var new_stylebox := VIndent.get_theme_stylebox("panel").duplicate() as StyleBoxFlat
		
	new_stylebox.border_width_top = 2
	new_stylebox.border_width_bottom = 2
	new_stylebox.border_width_left = 2
	new_stylebox.border_width_right = 2
	new_stylebox.border_color = TypeColor[ast.Type]	
	
	VIndent.add_theme_stylebox_override("panel", new_stylebox)
		
	HB.add_child(VIndent)
					
	Indent = HSplitContainer.new()
	Indent.custom_minimum_size = Indent_HSpacer_MinSize
	Indent.name = "Indent"
	HB.add_child(Indent)
					
	VB = VBoxContainer.new()
	VB.custom_minimum_size = Header_MinSize
	VB.name = "VB"
	
	HB.add_child(VB)
	
func set_Indent(value : int):
	if Children.size():
		Indent.custom_minimum_size = Vector2(value, 0)
	
		for child in Children:
			child.set_Indent(value)
#endregion Visuals

#region Generation
func generate():
	Content = HBoxContainer.new()
	Content.name = "Content"
	self.add_child(Content)
	
	match AST.Type:
		SType.sec_Alias:
			process_sec_Alias(AST, Content)
			
		SType.sec_Allocator:
			process_sec_Allocator(AST, Content)
			
		SType.sec_Cap:
			process_sec_Capture(AST, Content)
		
		SType.sec_Exe:
			process_sec_Exe(AST, Content)

		SType.sec_Identifier:
			process_sec_Identifier(AST, Content)
			
		SType.sec_RO:
			process_sec_RO(AST, Content)
			
		SType.sec_TT:
			process_sec_TranslationTime(AST, Content)

		_:
			process_expr(AST, Content)
	
	
	if Children.size() > 0:
		for child in Children:
			VB.add_child(child)

	var nodeName = ""
	
	for label in Content.get_children():
		nodeName += label.text + " "
	
	name = nodeName
	return
	
func process_sec_Generic(ast, container):
	create_ASTLabel( ast, container )
	
	if ast.num_Entries() == 1:
		var entry = ast.entry(1)
		match entry.Type:
			SType.sec_Static:
				process_sec_Static(entry, container)
			
			SType.sec_TT:
				process_sec_TranslationTime(entry, container)

			_:
				process_expr(entry, container)
		return
				
	create_Body(ast)
				
	var index = 1
	while index <= ast.num_Entries(): 
		Children.append( VSNode.new(ast.entry(index), self) )
		index += 1
		
	return
	
func process_sec_Alias(ast, container):
	create_ASTLabel( ast, container )
	
	if ast.num_Entires() > 1:
		create_Body(ast)
				
	var index = 1
	while index <= ast.num_Entries(): 
		
		
		index += 1
		
	return
	
func process_sec_Allocator(ast, container):
	return
	
func process_sec_Capture(ast, container):
	return
	
func process_sec_Exe(ast, container):
	create_ASTLabel( ast, container )
	
	if ast.num_Entries() == 1:
		var entry = ast.entry(1)
		match entry.Type:
			SType.sec_Loop:
				process_sec_Loop(entry, container)
			
			_:
				process_expr(entry, container)
		return
				
	create_Body(ast)
				
	var index = 1
	while index <= ast.num_Entries(): 
		Children.append( VSNode.new(ast.entry(index), self) )
		index += 1
		
	return
	
func process_sec_Loop(ast, container):
	create_ASTLabel( ast, container )
	
	if ast.cond():
		create_Label( STxt[SType.sec_Cond], SType.sec_Cond, container )
		process_expr( ast.cond(), container)
	
#	if ast.num_Entries() == 1:
#		var entry = ast.entry(1)
#		match entry.Type:
#			SType.sec
			
	create_Body(ast)
		
	var index = 1
	while index <= ast.num_Entries(): 
		Children.append( VSNode.new(ast.entry(index), self) )
		index += 1
		
	return
		
func process_sec_Static(ast, container):
	create_ASTLabel( ast, container )
	
	if ast.num_Entries() == 1:
		process_sym_Identifier( ast.entry(1), container)
		return
				
	create_Body(ast)
				
	var index = 1
	while index <= ast.num_Entries(): 
		Children.append( VSNode.new(ast.entry(index), self) )
		index += 1
		
	return
		
func process_sec_TranslationTime(ast, container):
	create_ASTLabel( ast, container )
	
	if ast.num_Entries() == 1:
		var entry = ast.entry(1)
		match entry.Type:
			SType.sec_Static:
				process_sec_Static(entry, container)
		return
	
	create_Body(ast)
		
	var   index = 1
	while index <= ast.num_Entries(): 
		Children.append( VSNode.new(ast.entry(index), self) )
		index += 1
		
	return

func process_sec_Type(ast, container):
	create_ASTLabel( ast, container )
	
	if ast.assignment():
		create_Label( STxt[SType.op_Assign], SType.op_Assign, container )
		process_expr(ast.assignment(), container)

func process_sec_Identifier(ast, container):
	create_ASTLabel( ast, container )
	
	if ast.num_Entries() == 1:
		var entry = ast.entry(1)
		match entry.Type:
			SType.sec_Exe:
				process_sec_Exe(entry, container)
			
			SType.sec_RO:
				process_sec_RO(entry, container)
			
			SType.sec_Static:
				process_sec_Static(entry, container)
			
			SType.sec_TT:
				process_sec_TranslationTime(entry, container)
		return
	
	create_Body(ast)
				
	var   index = 1
	while index <= ast.num_Entries(): 
		if ast.entry(index):
			Children.append( VSNode.new(ast.entry(index), self) )
		index += 1
	
	return
	
func process_sec_RO(ast, container):
	create_ASTLabel( ast, container )
	
	if ast.num_Entries() == 1:
		var entry = ast.entry(1)
		match entry.Type:
			SType.sec_Static:
				process_sec_Static( entry, container)
				
		return 
		
	create_Body(ast)
	
	var   index = 1
	while index <= ast.num_Entires():
		Children.append( VSNode.new(ast.entry(index), self) )
		index += 1
	
	return
	
func process_sym_Identifier(ast, container):
	create_ASTLabel( ast, container )

	if ast.has_Typedef():
		create_Label( STxt[TType.op_Define], TType.op_Define, container )
		process_sec_Type(ast.typedef(), container)
	
func process_expr(ast, container):
	match ast.Type:
		SType.literal_Binary  : process_literal(ast, container)
		SType.literal_Char    : process_literal(ast, container)
		SType.literal_Decimal : process_literal(ast, container)
		SType.literal_Digit   : process_literal(ast, container)
		SType.literal_String  : process_literal(ast, container)
		SType.literal_True    : process_literal(ast, container)
		SType.literal_False   : process_literal(ast, container)
		
		SType.sym_Identifier : process_sym_Identifier(ast, container)
		
		SType.op_SMA:
			process_op_SMA(ast, container)
		
		SType.op_Equal:
			process_op_Binary(ast, container)
			
		SType.op_NotEqual:
			process_op_Binary(ast, container)
			
		SType.op_Assign:
			process_op_Binary(ast, container)
		
		SType.op_Add:
			process_op_Binary(ast, container)
		SType.op_Subtract:
			process_op_Binary(ast, container)
		SType.op_Multiply:
			process_op_Binary(ast, container)
		SType.op_Divide:
			process_op_Binary(ast, container)

	return
	
func process_op_Binary(ast, container):
	var left  = ast.entry(1)
	var right = ast.entry(2)
	
	process_expr(left,  container)
	create_ASTLabel(ast,   container )
	process_expr(right, container)
	
func process_op_SMA(ast, container):
	process_expr(ast.name(), container)
	create_Label( STxt[SType.op_SMA], SType.op_SMA, container)
	process_expr(ast.member(), container)
	
func process_literal(ast, container):
	if ast.Type == SType.literal_True: 
		create_Label( STxt[SType.literal_True],  ast.Type, container )
		return
		
	elif ast.Type == SType.literal_False:
		create_Label( STxt[SType.literal_False], ast.Type, container )
		return
			
	create_Label( ast.entry(1), ast.Type, container )
	return
#endregion Generation


#func get_Child(node):
	



func get_class():
	return "VSNode"


#region Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_anchors_preset(Control.PRESET_CENTER)
	anchor_top = 0.00
	anchor_right = 0.65
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _init(ast, parent, generateImmediately = true):
	Parent = parent
	AST    = ast
	
	if generateImmediately:
		generate()
	
#endregion Node
