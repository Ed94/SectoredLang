class_name TextPipeline extends Control


var SRX_Cache : Dictionary # Not used yet.
var Lex       : Lexer
var SPars     : SyntaxParser
var AST


#region Editor
@onready var Editor  := get_node("HBox/CodeEdit") as TextEdit
@onready var ASTView := get_node("HBox/ASTView") as TextEdit

#region Node
func _exit_tree() -> void:
	Lex.free()
	SPars.free()
	
func _input(event):
	if event.is_action("MAS_ProcessText"):
		if G.check( Lex.tokenize(Editor.text) ):
			return
		
		var ast = SPars.parse()

		if G.check(ast, "Failed to get ast from parser"):
			return
	
		G.AST = ast
	
		ASTView.text = JSON.new().stringify(ast.to_SExpression(), "\t")
		return

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Lex   = Lexer.new()
	SPars = SyntaxParser.new(Lex)

	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#endregion Node
