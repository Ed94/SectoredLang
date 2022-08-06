class_name TextPipeline extends Control


var SRX_Cache : Dictionary # Not used yet.
var Lex       : Lexer
var SPars     : SyntaxParser
var AST


#region Editor
@onready var Editor := get_node("HBox/CodeEdit") as TextEdit
@onready var ASTView := get_node("HBox/ASTView") as TextEdit

@onready var Timer_TxtChanged := Timer.new()

func on_TxtChanged() -> void:
	Timer_TxtChanged.start()
	return

func on_TxtChanged_TimeReached() -> void:
	if G.check( Lex.tokenize(Editor.text) ):
		Timer_TxtChanged.stop()
		return
		
	var ast = SPars.parse()

	if G.check(ast, "Failed to get ast from parser"):
		Timer_TxtChanged.stop()
		return
	
	G.AST = ast
	
	ASTView.text = JSON.new().stringify(ast.to_SExpression(), "\t")
		
	Timer_TxtChanged.stop()
	return
#endregion Editor

#region Node
func _exit_tree() -> void:
	Lex.free()
	SPars.free()
	Timer_TxtChanged.free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Lex   = Lexer.new()
	SPars = SyntaxParser.new(Lex)
	
	Editor.text_changed.connect(on_TxtChanged)
	
	Timer_TxtChanged.wait_time = 2.0
	Timer_TxtChanged.timeout.connect(on_TxtChanged_TimeReached)
	add_child(Timer_TxtChanged)
	
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#endregion Node
