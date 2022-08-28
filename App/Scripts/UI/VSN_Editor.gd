extends Control

const SType := TParser.SType
const STxt  := TParser.STxt
const TType := Lexer.TType
const TypeColor  = GScript.TypeColor


const Mode := {
	Edit = "Edit",
	Nav = "Nav",
}


var CurrentMode := Mode.Edit

var CodeEditor  := STextEditor.new()
var CodeEditor_DefaultSize : Vector2i = Vector2i(500, 200)

func create_CodeEditor():
	add_child(CodeEditor)
	CodeEditor.custom_minimum_size = CodeEditor_DefaultSize


var SectorNodes = []

var CurrentNode : Control


#region OLD
const Spacer_MinSize := Vector2i(0, 6)
const Header_MinSize := Vector2i(700, 0)
const Indent_MinSize := Vector2i(6, 0)
const Indent_HSpacer_MinSize := Vector2i(10, 0)

var LastMajorSector : Control


func process_Text():
	if G.check( G.TxtPipeline.Lex.tokenize(CodeEditor.text) ):
		return 
		
	var ast = G.TxtPipeline.SPars.parse_unit()
	
	if ast == null:
		return
		
	if SectorNodes.size() > 0:
		SectorNodes[0].queue_free()
		SectorNodes.clear()
		
	CodeEditor.set_visible(false)
	
	var sectorNode = VSNode.new(ast.entry(1), null)
	self.add_child(sectorNode)
	
	SectorNodes.append(sectorNode)
	LastMajorSector = sectorNode
	
	return;
	
#	var sectorNode = create_SectorNode()
#
#	SectorNodes.append(sectorNode)
#	LastMajorSector = sectorNode
#
#	var index = 1
#	while index <= ast.num_Entries():
#
#		var entry = ast.entry(index)
#		match entry.type():
#			SType.sec_Exe:
#				process_sec_Exe(entry, sectorNode)
#
#			SType.sec_Identifier:
#				process_sec_Identifier(entry, sectorNode)
#
#		index += 1
		
func process_sec_Exe(ast, container, useHeader = true):
	var header = container
	if container as VBoxContainer:
		header = HBoxContainer.new()
		header.custom_minimum_size = Header_MinSize
		container.add_child(header)
	
	create_Label( STxt[SType.sec_Exe], SType.sec_Exe, header )
	
	var parent = header
	if ast.num_Entries() > 1:
		parent = create_SubSectorNode(container)
				
	var index = 1
	while index <= ast.num_Entries(): 
		
		var entry = ast.entry(index)
		match entry.type():
			SType.literal_String:
				create_Label( entry.entry(index), SType.literal_String, parent )
				
			
		# Its an expression
		var \
		op = HBoxContainer.new()
		op.custom_minimum_size = Header_MinSize
		container.add_child(op)
		
		process_expr(ast, op)
		index += 1
		
func process_sec_Static(ast, container, useHeader = true):
	var header = container
	if container as VBoxContainer:
		header = HBoxContainer.new()
		header.custom_minimum_size = Header_MinSize
		container.add_child(header)
		
	create_Label( STxt[ast.type()], ast.type(), header )
	
	var parent = header
	if ast.num_Entries() > 1:
		parent = create_SubSectorNode(container)
		
	var index = 1
	while index <= ast.num_Entries(): 
		process_sec_StaticEntry(ast.entry(index), parent)
		index += 1
		
func process_sec_TranslationTime(ast, container, useHeader = true):
	var header = container
	if container as VBoxContainer:
		header = HBoxContainer.new()
		header.custom_minimum_size = Header_MinSize
		container.add_child(header)
	
	create_Label( STxt[ast.type()], ast.type(), header )
	
	var parent = header
	if ast.num_Entries() > 1:
		parent = create_SubSectorNode(container)
		
	var   index = 1
	while index <= ast.num_Entries(): 
		
		var entry = ast.entry(index)
		match entry.type():
			SType.sec_Static:
				process_sec_Static(entry, container)
				
		index += 1
		
func process_sec_StaticEntry(ast, container):
	var header = container
	if container as VBoxContainer:
		header = HBoxContainer.new()
		header.custom_minimum_size = Header_MinSize
		container.add_child(header)
		
	create_Label(ast.name(), ast.type(), header)
	create_Label(STxt[TType.op_Define], TType.op_Define, header)
		
	process_sec_Type(ast.typedef(), header)
	return

func process_sec_Type(ast, container):
	var header = container
	if container as VBoxContainer:
		header = HBoxContainer.new()
		header.custom_minimum_size = Header_MinSize
		container.add_child(header)
	
	match ast.entry(1):
		SType.builtin_Bool:
			create_Label( STxt[SType.builtin_Bool], SType.builtin_Bool, header )
	
	if ast.has_Assignment():
		create_Label( STxt[SType.op_Assign], SType.op_Assign, header )
		process_expr(ast.assignment(), header)

func process_sec_Identifier(ast, container, useHeader = true):
	var header = container
	if container as VBoxContainer:
		header = HBoxContainer.new()
		header.custom_minimum_size = Header_MinSize
		container.add_child(header)
	
	create_Label( ast.name(), ast.type(), header )
	
	var parent = header
	if ast.num_Entries() > 1:
		parent = create_SubSectorNode(container)
				
	var   index = 1
	while index <= ast.num_Entries(): 
		
		var entry = ast.entry(index)
		match entry.type():
			SType.sec_TT:
				process_sec_TranslationTime(entry, parent)
					
		index += 1
	
	return 
	
func process_expr(ast, container):
	match ast.type():
		SType.literal_Binary  : process_literal(ast, container)
		SType.literal_Char    : process_literal(ast, container)
		SType.literal_Decimal : process_literal(ast, container)
		SType.literal_Digit   : process_literal(ast, container)
		SType.literal_String  : process_literal(ast, container)
		SType.literal_True    : process_literal(ast, container)
		SType.literal_False   : process_literal(ast, container)
					
		SType.op_Add:
			process_op_Binary(ast, container)
		SType.op_Subtract:
			process_op_Binary(ast, container)
		SType.op_Multiply:
			process_op_Binary(ast, container)

	return
	
func process_op_Binary(ast, container):
	var left  = ast.entry(1)
	var right = ast.entry(2)
	
	process_expr(left, container)
	create_Label( STxt[ast.type()], ast.type(), container )
	process_expr(right, container)
	
func process_literal(ast, container):
	if ast.type() == SType.literal_True: 
		create_Label( STxt[SType.literal_True],  ast.type(), container )
		return
		
	elif ast.type() == SType.literal_False:
		create_Label( STxt[SType.literal_False], ast.type(), container )
		return
			
	create_Label( ast.entry(1), ast.type(), container )
	return


func create_SectorNode():
	var sectorVBox = VBoxContainer.new()
	self.add_child(sectorVBox)
	
	var \
	spacer = VSplitContainer.new()
	spacer.custom_minimum_size = Spacer_MinSize
	sectorVBox.add_child(spacer)
	
	return sectorVBox
		
func create_SubSectorNode(parent):
	var \
	body = HBoxContainer.new()
	body.custom_minimum_size = Header_MinSize
	LastMajorSector.add_child(body)
					
	var \
	indent = Panel.new()
	indent.custom_minimum_size = Indent_MinSize
	# Coloring this might be complicated...
	body.add_child(indent)
					
	var \
	hspacer = HSplitContainer.new()
	hspacer.custom_minimum_size = Indent_HSpacer_MinSize
	body.add_child(hspacer)
					
	var \
	vbody = VBoxContainer.new()
	vbody.custom_minimum_size = Header_MinSize
	body.add_child(vbody)
	
	LastMajorSector = body
					
	return vbody
				
func create_Label(text : String, type : String, container):
	var \
	label = Label.new()
	label.text = text
	label.grow_horizontal = 1
	label.add_theme_color_override( "font_color", TypeColor[type] )
	container.add_child(label)
#endregon OLD
	

#region Node

func _unhandled_input(event: InputEvent) -> void:
	match CurrentMode:
		Mode.Edit:
			if event.is_action_pressed("SEditor_Mode_Nav"):
				process_Text()
				CurrentMode = Mode.Nav
		Mode.Nav:
			if event.is_action_pressed("SEditor_Mode_Edit"):
				for sector in SectorNodes:
					var control = sector as Control
					control.set_visible(false)
					CodeEditor.set_visible(true)
					CurrentMode = Mode.Edit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_CodeEditor()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	pass

#endregion Node
