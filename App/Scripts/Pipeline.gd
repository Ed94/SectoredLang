class_name Pipeline extends Control

#region Globals
const LogType = Log.EType
#endregion Globals

var SRX_Cache : Dictionary # Not used yet.
var Lex       : Lexer
var SPars     : TParser
var AST       : TParser.SNode
var MAS       : Interpreter
 
#region Editor
@onready var Editor       := get_node("HB/STEditor") as TextEdit
@onready var SViewViewTxt := get_node("HB/STreeViewTxt") as TextEdit
@onready var STreeView    := get_node("HB/STreeTree") as STree
@onready var VSE_View     := get_node("HB/VSE_Viewport/SubViewport") as SubViewport
@onready var EnvView      := get_node("HB/EnvView")
#endregion Editor

#region File
@onready var CurrentFile := UnitFileTxt.new()

signal buffer_updated


func on_EnvUpdated():
	EnvView.text = JSON.new().stringify(MAS.Env.to_SExpression(), "\t")


func on_BufferUpdated():
	Editor.text = CurrentFile.text
	buffer_updated.emit()
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
	
		SViewViewTxt.text = JSON.new().stringify(ast.to_SExpression(), "\t")
		
		STreeView.clear()
		STreeView.generate(ast)
		return
		
	if event.is_action_pressed("Editor_Interpret"):
		var result = MAS.eva(G.TxtPipeline.AST)
	
		if result != null:
			G.Persistent.Out.write( result )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Lex   = Lexer.new()
	SPars = TParser.new(Lex)

	MAS = Interpreter.new(null)
	
	MAS = MAS
#	MAS_EnvUpdated.connect( on_EnvUpdated )
	G.Pipeline = self
	G.PipelineReady.emit()
	return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#endregion Node
