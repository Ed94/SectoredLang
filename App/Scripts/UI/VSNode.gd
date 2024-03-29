class_name VSNode extends VBoxContainer

const TType      := Lexer.TType
const STxt       := TParser.STxt
const SType      := TParser.SType
const SAttribute := TParser.SAttribute
const TypeColor  := GScript.TypeColor

const VContentPad_MinSize := Vector2i(0, 0)
const Spacer_MinSize      := Vector2i(0, 6)
const Header_MinSize      := Vector2i(300, 0)
const Indent_MinSize      := Vector2i(6, 0)

const Indent_HSpacer_MinSize := Vector2i(20, 0)


var Parent     : VSNode
var AST    
var VLinePad    : VSplitContainer
var Content     : HBoxContainer
var HB          : HBoxContainer
var VIndent     : Panel
var Indent      : HSplitContainer
var VB          : VBoxContainer
var Stack       := []
var Children    := []
var Fmt_NLines  := []
#var VSTxtBlock  : VSTextBlock


#region Visuals
func create_Label(text, type) -> Label:
	var \
	label = Label.new()
	label.text = text
	label.grow_horizontal = 1
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override( "font_color", TypeColor[type] )
	Content.add_child(label)
	return label

func create_ASTLabel(ast) -> Label:
	if ast == null: ast = AST
		
	var \
	label = Label.new()
	label.text = ast.name() if typeof(ast) == TYPE_OBJECT else STxt[ast]
	label.name = label.text
	label.grow_horizontal = 1
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override( "font_color", TypeColor[ast.Type]  if typeof(ast) == TYPE_OBJECT else TypeColor[ast] )
	Content.add_child(label)
	Stack.append(ast)
	return label
	
#func add_ASTText(ast):
#	if ast == null : ast = AST
#	if VSTxtBlock == null:
#		VSTxtBlock = VSTextBlock.new()
#		VSTxtBlock.name = "VSTxtBlock"
##		VSTxtBlock.grow_horizontal = 1
#		VSTxtBlock.set_parent(Content)
#
#	var text = ast.name() if typeof(ast) == TYPE_OBJECT else STxt[ast]
#	VSTxtBlock.add_Text(text + " ", TypeColor[ast.Type])
#	Stack.append(ast)
#	return

func create_Body(ast):
	HB = HBoxContainer.new()
	HB.custom_minimum_size = Header_MinSize
	HB.name = "HB"
	self.add_child(HB)
					
	VIndent = Panel.new()
	VIndent.custom_minimum_size = Indent_MinSize
	VIndent.name = "VIndent"
	
	var \
	new_stylebox := VIndent.get_theme_stylebox("panel").duplicate() as StyleBoxFlat	
	new_stylebox.border_width_top    = 2
	new_stylebox.border_width_bottom = 2
	new_stylebox.border_width_left   = 2
	new_stylebox.border_width_right  = 2
	new_stylebox.border_color        = TypeColor[ast.Type]	
	
	VIndent.add_theme_stylebox_override("panel", new_stylebox)
		
	HB.add_child(VIndent)
					
	Indent = HSplitContainer.new()
	Indent.custom_minimum_size = Indent_HSpacer_MinSize
	Indent.name = "Indent"
	HB.add_child(Indent)
					
	VB = VBoxContainer.new()
	VB.custom_minimum_size = Header_MinSize
	VB.name = "VB"
	VB.alignment = BoxContainer.ALIGNMENT_BEGIN
	
	HB.add_child(VB)
	
	if get_index() != 0:
		VLinePad = VSplitContainer.new()
		VLinePad.name = "VLinePad"
		self.add_child(VLinePad)
		VLinePad.custom_minimum_size = Vector2i(0, 10)
	
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
	Content.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	self.add_child(Content)
	
	var matched = false
	if Parent:
		var pEnum
		for index in range(Parent.Stack.size() - 1, 0, -1):
			match Parent.Stack[index].Type:
				SType.sec_Alias:
					process_sec_AliasChild(AST)
					matched = true
					
				SType.sec_Enum:
					process_sec_EnumChild(AST)
					matched = true

	process_Stack(AST, true)
	
	if Children.size() > 0:
		for child in Children:
			VB.add_child(child)

	var nodeName = ""
	
	for label in Content.get_children():
		if label.get_class() == "Label":
			nodeName += label.text + " "
		else:
			nodeName += label.get_child(0).text + " "
	
	name = nodeName
	return
	
func process_Stack(ast, fromGenerate = false) -> bool:
	var entry

	if fromGenerate:
		entry = ast
	elif ast.num_Entries() == 1:
		entry = ast.entry(1)
	else:
		return false

	match entry.Type:
		SType.sec_Alias:
			process_sec_Alias(entry)
			
		SType.sec_Allocator:
			process_sec_Allocator(entry)
			
		SType.op_Alloc:
			process_sec_AllocatorOp(entry)
			
		SType.op_Resize:
			process_sec_AllocatorOp(entry)
			
		SType.op_Free:
			process_sec_AllocatorOp(entry)
			
		SType.op_Wipe:
			process_sec_AllocatorOp(entry)

		SType.sec_Cap:
			process_sec_Capture(entry)
			
		SType.sec_Cond:
			process_sec_Cond(entry)
			
		SType.sec_Enum:
			process_sec_Enum(entry)
		
		SType.sec_Exe:
			process_sec_Exe(entry)
			
		SType.sec_External:
			process_sec_External(entry)
			
		SType.sec_Heap:
			process_sec_Heap(entry)
			
		SType.sec_Identifier:
			process_sec_Identifier(entry)
			
		SType.sec_Inline:
			process_sec_Inline(entry)
			
		SType.sec_Interface:
			process_sec_Interface(entry)
			
		SType.sec_Loop:
			process_sec_Loop(entry)
			
		SType.sec_RO:
			process_sec_RO(entry)
		
		SType.sec_Static:
			process_sec_Static(entry)
			
		SType.sec_Struct:
			process_sec_Struct(entry)
			
		SType.sec_Switch:
			process_sec_Switch(entry)
			
		SType.sec_SwitchCase:
			process_sec_SwitchCase(entry)
			
		SType.sec_Type:
			process_sec_Type(entry)
		
		SType.sec_TT:
			process_sec_TranslationTime(entry)

		SType.op_Return: 
			process_op_Return(entry)
		
		_:
			process_Expr(entry)
				
	return true
	
func process_Body(ast):
	create_Body(ast)
	
	var index = 1
	while index <= ast.num_Entries(): 
		Children.append( VSNode.new(ast.entry(index), self) )
		index += 1
		
	return
	
func process_sec_Alias(ast):
	create_ASTLabel( ast )
	
	if ast.num_Entries() > 1:
		process_Body(ast)
		return
	return
		
func process_sec_AliasChild(ast):
	return
	
func process_sec_Allocator(ast):
	return
	
func process_sec_AllocatorOp(ast):
	if ast.identifier():
		process_Expr(ast.identifier())
	
	create_ASTLabel(ast)
	
	if ast.custom():
		process_Expr(ast.custom())
	
	if ast.capture():
		process_Expr(ast.capture())

	return
	
func process_sec_Capture(ast):
	process_sec_CaptureArgs(ast.args())
	
	if ast.ret_Map():
		process_sec_RetMap(ast.ret_Map())
		
	if process_Stack(ast):
		return
		
	process_Body(ast)
	return
	
func process_sec_CaptureArgs(ast):
	create_Label("(", "op")
	
	for index in range(1, ast.num_Entries() + 1):
		var entry = ast.entry(index)
		match entry.Type:
			SType.sym_Self:
				process_sym_Self(entry)
			_:
				process_sym_Identifier(entry)
	
	create_Label(")", "op")
	return
	
func process_sec_Cond(ast):
	create_ASTLabel(ast)
	
	if ast.cond():
		process_Expr(ast.cond())
		
	if ast.body():
		process_Body(ast.body())
	
	if ast.alt():
		create_Label(STxt[TType.sec_Else], TType.sec_Else)
		process_Body(ast)
		
	return
	
func process_sec_Enum(ast):
	create_ASTLabel(ast)
	
	if ast.capture():
		process_expr_Capture(ast.capture())
		
	process_Body(ast)
	return
	
func process_sec_EnumChild(ast):
	create_ASTLabel(ast.name())
	
	if ast.assignment():
		process_Expr( ast.assignment() )
	
	return
	
func process_sec_Exe(ast):
	create_ASTLabel( ast )
	
	if process_Stack(ast):
		return
				
	process_Body(ast)
	return
	
func process_sec_External(ast):
	create_ASTLabel(ast)
	
	if process_Stack(ast):
		return
		
	process_Body(ast)
	return
	
func process_sec_Heap(ast):
	create_ASTLabel(ast)
	
	if process_Stack(ast):
		return
	
	process_Body(ast)
	
	return
	
func process_sec_Identifier(ast):
	create_ASTLabel( ast )
	
	if ast.ret_Map():
		process_sec_RetMap(ast.ret_Map())
	
	if process_Stack(ast):
		return
		
	process_Body(ast)
	return

func process_sec_Inline(ast):
	create_ASTLabel( ast )
	
	if process_Stack(ast):
		return
		
	process_Body(ast)
	return
	
func process_sec_Interface(ast):
	create_ASTLabel(ast)
	
	process_sym_Identifier(ast.identifier())
	
	if process_Stack(ast):
		return
		
	process_Body(ast)
	return
	
func process_sec_Label(ast):
	create_ASTLabel(ast)
	
	
	
func process_sec_Loop(ast):
	create_ASTLabel( ast )
	
	if ast.cond():
		create_Label( STxt[SType.sec_Cond], SType.sec_Cond )
		Stack.append(ast)
		process_Expr( ast.cond())
	
	process_Body(ast)
	return
	
func process_sec_RetMap(ast):
	create_ASTLabel(ast)
	
	process_Expr(ast.expression())
	return
		
func process_sec_RO(ast):
	create_ASTLabel( ast )
	
	if ast.num_Entries() == 1:
		var entry = ast.entry(1)
		match entry.Type:
			SType.sec_Static:
				process_sec_Static( entry )
		return 
		
	process_Body(ast)
	
func process_sec_Static(ast):
	create_ASTLabel( ast )
	
	if ast.num_Entries() == 1:
		process_sym_Identifier( ast.entry(1))
		return

	process_Body(ast)
	return
		
func process_sec_Struct(ast):
	create_ASTLabel(ast)
	
	process_Body(ast)
	return
	
func process_sec_Switch(ast):
	create_ASTLabel(ast)
	
	if ast.Attributes[SAttribute.exe]:
		process_expr_Capture(ast.cond())
	else:
		process_sec_Capture(ast.cond())
		
	if process_Stack(ast):
		return
		
	process_Body(ast)
	return
	
func process_sec_SwitchCase(ast):
	process_Expr(ast.case())
	
	if process_Stack(ast):
		return
	
	process_Body(ast)
	
	return

func process_sec_TranslationTime(ast):
	create_ASTLabel( ast )
	
	if ast.num_Entries() == 1:
		var entry = ast.entry(1)
		match entry.Type:
			SType.sec_Static:
				process_sec_Static(entry)
		return
	
	process_Body(ast)
	return

func process_sec_Type(ast):
	if ast.typedef().Type == SType.sym_Infer:
		process_sym_Inferred(ast)
		return
	
	if ast.parent().Type == SType.sec_Identifier:
		create_Label( STxt[SType.sym_Type], SType.sym_Type )
	else:
		create_Label( STxt[TType.op_Define], TType.op_Define )
	
	match ast.typedef().Type:
		SType.sym_Identifier:
			process_sym_Identifier(ast.typedef())
		
		SType.sym_Type:
			process_sym_Type(ast.typedef())
		
		SType.sym_TT_Type:
			process_sym_TT_Type(ast.typedef())

	if ast.assignment():
		create_Label( STxt[SType.op_Assign], SType.op_Assign )
		Stack.append(ast)
		process_Expr(ast.assignment())
		
	return

func process_sym_Identifier(ast):
	create_ASTLabel( ast )

	if ast.has_Typedef():
		Stack.append(ast)
		process_sec_Type(ast.typedef() )
		
	return
		
func process_sym_Inferred(ast):
	create_ASTLabel(ast.typedef())
	
	if ast.assignment():
		Stack.append(ast)
		process_Expr(ast.assignment())
		
	return
	
func process_sym_LP(ast):
	create_ASTLabel(ast)
	return
	
func process_sym_Proc(ast):
	create_ASTLabel(ast)
	
	if ast.capture():
		process_expr_Capture(ast.capture())
		
	if ast.ret_Map():
		process_sec_RetMap(ast.ret_Map())
		
	return
	
func process_sym_Ptr(ast):
	create_ASTLabel(ast)
	
	match ast.Type:
		SType.sym_Byte:
			create_ASTLabel(ast.typedef())
		
		SType.sym_Word:
			create_ASTLabel(ast.typedef())
			
		_:
			process_sym_Type(ast.typedef())
		
func process_sym_Self(ast):
	create_ASTLabel(ast)
	return
		
func process_sym_Type(ast):
	var val = ast.value()
	match ast.value().Type:
		SType.sym_Identifier:
			process_sym_Identifier(ast.value())
			
		SType.sym_Proc:
			process_sym_Proc(ast.value())
			
		SType.sym_Ptr:
			process_sym_Ptr(ast.value())
			
		SType.op_SMA:
			process_op_SMA(ast.value())
		
		SType.sym_Type:
			process_sym_Type(ast.value())
		
		SType.sym_TT_Type:
			process_sym_TT_Type(ast.value())
		_:
			create_ASTLabel(ast.value())
			
	return
	
func process_sym_TT_Type(ast):
	create_ASTLabel(ast)
	process_sym_Type(ast.entry(1))
	return
	
func process_Expr(ast):
	var astval = ast.Type
	
	match ast.Type:
		SType.literal_Binary  : process_Literal(ast)
		SType.literal_Char    : process_Literal(ast)
		SType.literal_Decimal : process_Literal(ast)
		SType.literal_Digit   : process_Literal(ast)
		SType.literal_String  : process_Literal(ast)
		SType.literal_True    : process_Literal(ast)
		SType.literal_False   : process_Literal(ast)
		
		SType.sym_Null : create_ASTLabel(ast)
		
		SType.sym_LP         : process_sym_LP(ast)
		SType.sym_Identifier : process_sym_Identifier(ast)
		SType.sym_Type       : process_sym_Type(ast)
		
		SType.op_AlignOf  : create_ASTLabel(ast)
		SType.op_OffsetOf : create_ASTLabel(ast)
		SType.op_PosOf    : create_ASTLabel(ast)
		SType.op_Ptr      : create_ASTLabel(ast)
		
		SType.expr_Cap     : process_expr_Capture(ast)
		SType.op_SMA       : process_op_SMA(ast)
		SType.op_Dependent : process_op_Dependent(ast)

		SType.op_Cast     : process_op_Cast(ast)
		
		SType.op_UnaryNeg : process_op_Unary(ast)
		SType.op_BNot     : process_op_Unary(ast)
		SType.op_LNot     : process_op_Unary(ast)

		SType.op_Add      : process_op_Binary(ast)
		SType.op_Subtract : process_op_Binary(ast)
		SType.op_Multiply : process_op_Binary(ast)
		SType.op_Divide   : process_op_Binary(ast)
		SType.op_Modulo   : process_op_Binary(ast)
		
		SType.op_BAnd : process_op_Binary(ast)
		SType.op_BOr  : process_op_Binary(ast)
		SType.op_BXOr : process_op_Binary(ast)
		SType.op_BSL  : process_op_Binary(ast)
		SType.op_BSR  : process_op_Binary(ast)
		
		SType.op_Greater      : process_op_Binary(ast)
		SType.op_GreaterEqual : process_op_Binary(ast)
		SType.op_Lesser       : process_op_Binary(ast)
		SType.op_LesserEqual  : process_op_Binary(ast)

		SType.op_Equal    : process_op_Binary(ast)
		SType.op_NotEqual : process_op_Binary(ast)
									
		SType.op_Assign : process_op_Binary(ast)
		SType.op_AB_And : process_op_Binary(ast)
		SType.op_AB_Not : process_op_Binary(ast)
		SType.op_AB_Or  : process_op_Binary(ast)
		SType.op_AB_SL  : process_op_Binary(ast)
		SType.op_AB_SR  : process_op_Binary(ast)
		SType.op_AB_XOr : process_op_Binary(ast)
		
		SType.op_CD : process_op_Binary(ast)
	return

func process_op_SMA(ast):
	process_Expr(ast.name())
	create_Label( STxt[SType.op_SMA], SType.op_SMA)
	Stack.append(ast)
	process_Expr(ast.member())
	return

func process_op_Cast(ast):
	create_ASTLabel(ast)
	process_Expr(ast.entry(1))
	return

func process_expr_Capture(ast):
	create_Label("(", "op")
	process_Expr(ast.entry(1))
	create_Label(")", "op")
	return

func process_op_Dependent(ast):
	process_Expr( ast.name() )
	process_expr_Capture(ast.args())
	return

func process_op_Return(ast):
	create_ASTLabel(ast)
	
	if ast.expression():
		process_Expr(ast.expression())
		
	return
	
func process_op_Unary(ast):
	create_ASTLabel(ast)
	process_Expr(ast.operand())
	return

func process_op_Binary(ast):
	var left  = ast.entry(1)
	var right = ast.entry(2)
	
	process_Expr(left)
	create_ASTLabel(ast)
	process_Expr(right)
	return

func process_Literal(ast):
	if ast.Type == SType.literal_True: 
		create_Label( STxt[SType.literal_True],  ast.Type )
		Stack.append(ast)
		return
		
	elif ast.Type == SType.literal_False:
		create_Label( STxt[SType.literal_False], ast.Type )
		Stack.append(ast)
		return
			
	create_Label( ast.entry(1), ast.Type )
	Stack.append(ast)
	return
#endregion Generation

#region Serialization
func str_Content() -> String:
	var result : String
	for child in Content.get_children():
		result += child.text + " "
		
	return result
	
func to_str(nestingIndex := 0) -> String:
	var result := str_Content()
	if Children.size() > 0:
		var tabs : String
		if nestingIndex == 0:
			tabs = ""
		else:
			tabs = "\t".repeat(nestingIndex)
		
		result += "\n" + tabs + "{\n"
		for child in Children:
			result += tabs + "\t" + child.to_str(nestingIndex + 1) + "\n"
			
		result += tabs + "}\n"
		
	return result
#endregion Serialization


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
