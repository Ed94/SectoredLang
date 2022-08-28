class_name TextPipeline extends Node


var SRX_Cache : Dictionary # Not used yet.
var Lex       : Lexer
var SPars     : TParser
var AST       : TParser.SNode


#region Editor
@onready var Editor  := get_node("HBox/CodeEdit") as TextEdit
@onready var SView := get_node("HBox/SView") as TextEdit
@onready var SView_Tree := get_node("HBox/SView_Tree") as STree
@onready var SEView := get_node("HBox/SE_Viewport/SubViewport") as SubViewport
#endregion Editor

#region File
@onready var CurrentFile := UnitFileTxt.new()

func on_BufferUpdated():
	Editor.text = CurrentFile.text
#endregion File

#region Node
func _exit_tree() -> void:
	Lex.free()
	SPars.free()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Editor_RefreshCurrent"):
		CurrentFile.buffer()
	
	if event.is_action_pressed("Editor_SaveCurrent"):
		CurrentFile.text = Editor.text
		CurrentFile.save()

	if event.is_action_pressed("Editor_ProcessText"):
		if G.check( Lex.tokenize(Editor.text) ):
			return
		
		var ast := SPars.parse_unit()

		if G.check(ast, "Failed to get ast from parser"):
			return
	
		AST = ast
	
		SView.text = JSON.new().stringify(ast.to_SExpression(), "\t")
		
		SView_Tree.clear()
		SView_Tree.generate(ast)
		return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Lex   = Lexer.new()
	SPars = TParser.new(Lex)

	G.TxtPipeline = self
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#endregion Node
