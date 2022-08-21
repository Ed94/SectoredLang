class_name TextPipeline extends Node


var SRX_Cache : Dictionary # Not used yet.
var Lex       : Lexer
var SPars     : SyntaxParser
var AST       : SyntaxParser.ASTNode


#region Editor
@onready var Editor  := get_node("HBox/CodeEdit") as TextEdit
@onready var ASTView := get_node("HBox/ASTView") as TextEdit
@onready var ASTView_Tree := get_node("HBox/ASTView_Tree") as AST_Tree
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
	
func _input(event):
	if event.is_action_pressed("Editor_ProcessText"):
		if G.check( Lex.tokenize(Editor.text) ):
			return
		
		var ast := SPars.parse_unit()

		if G.check(ast, "Failed to get ast from parser"):
			return
	
		AST = ast
	
		ASTView.text = JSON.new().stringify(ast.to_SExpression(), "\t")
		
		ASTView_Tree.clear()
		ASTView_Tree.generate(ast)
		return
		
	if event.is_action_pressed("Editor_RefreshCurrent"):
		CurrentFile.buffer()
	
	if event.is_action_pressed("Editor_SaveCurrent"):
		CurrentFile.text = Editor.text
		CurrentFile.save()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Lex   = Lexer.new()
	SPars = SyntaxParser.new(Lex)

	G.TxtPipeline = self
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#endregion Node
