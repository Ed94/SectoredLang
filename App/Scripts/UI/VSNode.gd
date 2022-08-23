class_name VSNode extends VBoxContainer

const TType     := Lexer.TType
const NTxt      := SyntaxParser.NTxt
const NType     := SyntaxParser.NType
const TypeColor := GScript.TypeColor

const Spacer_MinSize := Vector2i(0, 6)
const Header_MinSize := Vector2i(700, 0)
const Indent_MinSize := Vector2i(6, 0)

const Indent_HSpacer_MinSize := Vector2i(10, 0)


var Parent     : VSNode
var AST    
var Content    : HBoxContainer
var HB         : HBoxContainer
var VB         : VBoxContainer
var Children   := []


func create_Label(text, type, container = null):
	if container == null: container = Content
	
	var \
	label = Label.new()
	label.text = text
	label.grow_horizontal = 1
	label.add_theme_color_override( "font_color", TypeColor[type] )
	container.add_child(label)

func create_ASTLabel(ast, container = null):
	if ast       == null: ast       = AST
	if container == null: container = Content
	
	var \
	label = Label.new()
	label.text = ast.name() if typeof(ast) == TYPE_OBJECT else NTxt[ast]
	label.name = label.text
	label.grow_horizontal = 1
	label.add_theme_color_override( "font_color", TypeColor[ast.type()]  if typeof(ast) == TYPE_OBJECT else TypeColor[ast] )
	container.add_child(label)

func create_Body():
	HB = HBoxContainer.new()
	HB.custom_minimum_size = Header_MinSize
	HB.name = "HB"
	self.add_child(HB)
					
	var \
	indent = Panel.new()
	indent.custom_minimum_size = Indent_MinSize
	# Coloring this might be complicated...
	indent.name = "indent"
	HB.add_child(indent)
					
	var \
	hspacer = HSplitContainer.new()
	hspacer.custom_minimum_size = Indent_HSpacer_MinSize
	hspacer.name = "hspacer"
	HB.add_child(hspacer)
					
	VB = VBoxContainer.new()
	VB.custom_minimum_size = Header_MinSize
	VB.name = "VB"
	HB.add_child(VB)

func generate():
	Content = HBoxContainer.new()
	Content.name = "Content"
	self.add_child(Content)
	
	match AST.type():
		NType.sec_Exe:
			process_sec_Exe(AST, Content)

		NType.sec_Identifier:
			process_sec_Identifier(AST, Content)
			
		NType.sec_TT:
			process_sec_TranslationTime(AST, Content)
			
		NType.sym_Identifier:
			process_sym_Identifier(AST, Content)

	process_expr(AST, Content)
	
	for child in Children:
		VB.add_child(child)
		
	var nodeName = ""
	
	for label in Content.get_children():
		nodeName += label.text + " "
	
	name = nodeName
	return
	
func process_sec_Exe(ast, container):
	create_ASTLabel( ast, container )
	
	if ast.num_Entries() == 1:
		var entry = ast.entry(1)
		match entry.type():
			_:
				process_expr(ast, container)
				pass
		return
				
	create_Body()
				
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
				
	create_Body()
				
	var index = 1
	while index <= ast.num_Entries(): 
		Children.append( VSNode.new(ast.entry(index), self) )
		index += 1
		
	return
		
func process_sec_TranslationTime(ast, container):
	create_ASTLabel( ast, container )
	
	if ast.num_Entries() == 1:
		var entry = ast.entry(1)
		match entry.type():
			NType.sec_Static:
				process_sec_Static(entry, container)
		return
	
	create_Body()
		
	var   index = 1
	while index <= ast.num_Entries(): 
		Children.append( VSNode.new(ast.entry(index), self) )
		index += 1
		
	return

func process_sec_Type(ast, container):
	create_ASTLabel(ast.entry(1), container )
	
	if ast.has_Assignment():
		create_Label( NTxt[NType.op_Assign], NType.op_Assign, container )
		process_expr(ast.assignment(), container)

func process_sec_Identifier(ast, container):
	create_ASTLabel( ast, container )
	
	if ast.num_Entries() == 1:
		var entry = ast.entry(1)
		match entry.type():
			NType.sec_TT:
				process_sec_TranslationTime(entry, container)
		return
	
	create_Body()
				
	var   index = 1
	while index <= ast.num_Entries(): 
		Children.append( VSNode.new(ast.entry(index), self) )
		index += 1
	
	return
	
func process_sym_Identifier(ast, container):
	create_ASTLabel(ast, container)
	create_Label( NTxt[TType.op_Define], TType.op_Define, container )
	
	if ast.has_Typedef():
		process_sec_Type(ast.typedef(), container)
	
func process_expr(ast, container):
	match ast.type():
		NType.literal_Binary  : process_literal(ast, container)
		NType.literal_Char    : process_literal(ast, container)
		NType.literal_Decimal : process_literal(ast, container)
		NType.literal_Digit   : process_literal(ast, container)
		NType.literal_String  : process_literal(ast, container)
		NType.literal_True    : process_literal(ast, container)
		NType.literal_False   : process_literal(ast, container)
					
		NType.op_Add:
			process_op_Binary(ast, container)
		NType.op_Subtract:
			process_op_Binary(ast, container)
		NType.op_Multiply:
			process_op_Binary(ast, container)

	return
	
func process_op_Binary(ast, container):
	var left  = ast.entry(1)
	var right = ast.entry(2)
	
	process_expr(left,  container)
	create_Label(ast,   container )
	process_expr(right, container)
	
func process_literal(ast, container):
	if ast.type() == NType.literal_True: 
		create_Label( NTxt[NType.literal_True],  ast.type(), container )
		return
		
	elif ast.type() == NType.literal_False:
		create_Label( NTxt[NType.literal_False], ast.type(), container )
		return
			
	create_Label( ast.entry(1), ast.type(), container )
	return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _init(ast, parent):
	Parent = parent
	AST    = ast

	generate()
