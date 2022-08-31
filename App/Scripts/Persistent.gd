class_name PersistentType extends Node

const LogType := Log.EType

@onready var Views    := get_node("VB/Views")
@onready var Menu     := get_node("VB/MenuTabs")
@onready var Out      := Views.get_node("AuxPanels/OutPanel") as Output

@onready var STEditor := Views.get_node("HB/STEditor") as TextEdit
@onready var VSE_View := Views.get_node("HB/VSE_Viewport/SubViewport") as VSEditorViewport

@onready var STreeVewTxt := Views.get_node("HB/STreeViewTxt") as TextEdit
@onready var STreeView   := Views.get_node("HB/STreeView") as STree


#region Node
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Editor_ToggleVEditor"):
		VSE_View.get_parent().visible = ! VSE_View.get_parent().visible
	
	if event.is_action_pressed("Editor_ToggleAuxPanel"):
		Menu.visible = ! Menu.visible
		
	if event.is_action_pressed("Editor_ToggleASTViewTree"):
		STreeView.set_visible(! STreeView.is_visible())
	
	if event.is_action_pressed("Editor_ToggleTextEditor"):
		STEditor.set_visible(! STEditor.is_visible())
#		VSE_View.get_parent().visible = ! Editor.visible
	return

func _ready() -> void:
	return
#endregion Node

#region Object
func _init() -> void:
	G.Persistent = self
	G.PersistentReady.emit()
#endregion Object
