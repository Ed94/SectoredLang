extends Node

const LogType := Log.EType


var MAS : Interpreter


@onready var Views    := get_node("VBoxContainer/Views")
@onready var Menu     := get_node("VBoxContainer/MenuTabs")
@onready var EnvView  := Views.get_node("VBoxContainer/Views/HBox/EnvView")
@onready var Out      := Views.get_node("AuxPanels/OutPanel") as Output

@onready var Editor := Views.get_node("HBox/CodeEdit") as TextEdit
@onready var SEView := Views.get_node("HBox/SE_Viewport/SubViewport") as SubViewport

@onready var SView_Txt  := Views.get_node("HBox/SView") as TextEdit
@onready var SView_Tree := Views.get_node("HBox/SView_Tree") as STree


func on_EnvUpdated():
	EnvView.text = JSON.new().stringify(MAS.Env.to_SExpression(), "\t")



#region Node
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Editor_ToggleAuxPanel"):
		Menu.visible = ! Menu.visible
	
	if event.is_action_pressed("Editor_Interpret"):
		var result = MAS.eva(G.TxtPipeline.AST)
	
		if result != null:
			Out.write( result )
		
	if event.is_action_pressed("Editor_ToggleASTViewTree"):
		SView_Tree.set_visible(! SView_Tree.is_visible())
	
	if event.is_action_pressed("Editor_ToggleTextEditor"):
		Editor.set_visible(! Editor.is_visible())
#		SEView.get_parent().visible = ! Editor.visible

	return

func _ready() -> void:
	MAS = Interpreter.new(null)
	
	G.MAS = MAS
	G.MAS_EnvUpdated.connect( on_EnvUpdated )
	G.Log.out(LogType.log, "Initialized Persistent MAS Interpreter.")
	return
#endregion Node
