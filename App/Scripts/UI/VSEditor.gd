class_name VSEditor extends Control

const SType     := TParser.SType
const STxt      := TParser.STxt
const TType     := Lexer.TType
const TypeColor  = GScript.TypeColor

@export var IndentSlider : HSlider
@export var Mode_Indi    : RichTextLabel
@export var Follow_Indi  : RichTextLabel


@onready var GPipeline := G.Pipeline as Pipeline
@onready var Cam := get_parent().get_node("VPCam") as Camera2D


const Mode := {
	Edit = "Edit",
	Edit_Node = "Edit Node",
	Nav = "Nav",
}


var CurrentMode := Mode.Edit
var FollowOpt := true

var CodeEditor  := STextEditor.new()

func create_CodeEditor():
	SVB.add_child(CodeEditor)
	CodeEditor.name = "CodeEditor"
#	CodeEditor.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
#	CodeEditor.anchor_left = 0.5
#	CodeEditor.anchor_top = 0.5
#	CodeEditor.anchor_right = 0.00
#	CodeEditor.anchor_bottom = 0.00
#	CodeEditor.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
#	CodeEditor.size_flags_vertical = Control.SIZE_SHRINK_CENTER

var NavPanel
func create_NavPanel():
	if NavPanel == null:
		NavPanel      = VSNav.new(self)
		NavPanel.name = "NavPanel"
	else:
		NavPanel.visible = true

	SVB.add_child(NavPanel)
	var test := SectorNodes[0] as VSNode
	NavPanel.hover(test)


var SectorNodes = []
var rect : ReferenceRect
var SVB : VBoxContainer

var CurrentNode : Control
var LastMajorSector : Control


func process_Text():
	if G.check( G.Pipeline.Lex.tokenize(CodeEditor.text) ):
		return 
		
	var ast = G.Pipeline.SPars.parse_unit()
	
	if ast == null:
		return
		
	if ast.num_Entries() == 0:
		return
		
	for node in SectorNodes:
		node.queue_free()
		
	SectorNodes.clear()
	CodeEditor.visible = false
		
	for index in range(1, ast.num_Entries() + 1):
		var sectorNode = VSNode.new(ast.entry(index), null, false)
		SVB.add_child(sectorNode)
		sectorNode.set_anchors_preset(Control.PRESET_CENTER)
		sectorNode.generate()
		
		SectorNodes.append(sectorNode)
		LastMajorSector = sectorNode
		
	on_editor_update()
	return;
	

func on_buffer_updated():
	switch_to_Edit()
	CodeEditor.text =  G.Pipeline.CurrentFile.text
	call_deferred( "svb_ForceResize" )

#region IndentSlider
func on_indent_changed(value : float):
	for sector in SectorNodes:
		sector.set_Indent(value)
			
	return	
#endregion IndentSlider

func switch_to_Nav():
	if CurrentMode == Mode.Nav:
		return
		
	process_Text()
	
	if SectorNodes.size() == 0:
		return
	
	CurrentMode = Mode.Nav	
	Mode_Indi.text = CurrentMode
	create_NavPanel()
	
func switch_to_Edit():
	if CurrentMode == Mode.Edit:
		return
	
	for sector in SectorNodes:
		if sector == null:
			continue
		
		var control = sector as Control
		
		control.visible    = false
		CodeEditor.visible = true

	if NavPanel:
		NavPanel.disengage()
		NavPanel.visible   = false

	CurrentMode = Mode.Edit
	Mode_Indi.text = CurrentMode
	cam_MoveToSVB()

#region Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("VSEditor_ToggleFollow"):
		FollowOpt = ! FollowOpt
		Follow_Indi.visible = FollowOpt
	
	if event.is_action_pressed("VSN_Editor_ModeToggle_Edit_Nav"):
		match CurrentMode:
			Mode.Edit:
				switch_to_Nav()
			Mode.Nav:
				switch_to_Edit()
				
	match CurrentMode:
		Mode.Edit:
			pass
			
		Mode.Edit_Node:
			if event.is_action_pressed("VS_Editor_EditSelected") && !Input.is_key_pressed(KEY_ALT):
#				G.Pipeline.Lex.tokenize(CodeView.text)
				pass
		
		Mode.Nav:
			if event.is_action_pressed("VS_Editor_EditSelected") && !Input.is_key_pressed(KEY_ALT):
				NavPanel.inplace_Editor()
				CurrentMode = Mode.Edit
			
			if event.is_action_pressed("VSN_Editor_EnterSector"):
				if NavPanel:
					NavPanel.enter()
					
			if event.is_action_pressed("VSN_Editor_LeaveSector"):
				if NavPanel:
					NavPanel.leave()
					
			if event.is_action_pressed("VSN_Editor_NavUp"):
				if NavPanel:
					NavPanel.up()
					
			if event.is_action_pressed("VSN_Editor_NavDown"):
				if NavPanel:
					NavPanel.down()

var CodeEditor_LastLineCount : float
func on_editor_update():
	Cam.set_physics_process(false)
	var currentLineCount = CodeEditor.text.split("\n").size()
	
	if CodeEditor_LastLineCount > currentLineCount \
	&& SVB.get_child_count() == 1 && SVB.get_child(0) == CodeEditor:
		call_deferred("svb_ForceResize")
		CodeEditor_LastLineCount = currentLineCount
		return
	
	cam_MoveToSVB()
	CodeEditor_LastLineCount = currentLineCount
	return

func svb_ForceResize():
	SVB.size = SVB.custom_minimum_size
	SVB.visible = false
	
	SVB.call_deferred("set_visible", true)
	CodeEditor.call_deferred("grab_focus")
	
	cam_MoveToSVB()
	return

const PosOffset = Vector2(0, 20)

func cam_scroll_Up():
	Cam.position -= PosOffset * 4

func cam_scroll_Down():
	Cam.position += PosOffset * 4

func cam_MoveToSVB():
	if ! FollowOpt:
		return
	Cam.position = SVB.position \
	+ Vector2( (CodeEditor.custom_minimum_size / 2).x, 0) \
	+ Vector2(0, CodeEditor.get_caret_draw_pos().y)

func svb_MoveToCam():
	SVB.position = Cam.position - CodeEditor.custom_minimum_size / 2 - PosOffset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	IndentSlider.value_changed.connect(on_indent_changed)
	
	SVB = VBoxContainer.new()
	add_child(SVB)
	SVB.name = "SVB"
	SVB.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	SVB.size_flags_vertical   = Control.SIZE_SHRINK_END
	
	create_CodeEditor()
	svb_MoveToCam()
	CodeEditor.text_changed.connect(on_editor_update)
	CodeEditor.caret_changed.connect(on_editor_update)
	
	Mode_Indi.text = CurrentMode
	
	
	var pipeline = G
	
	if G.Pipeline:
		bind_buffer_updated()
	else: 
		G.PipelineReady.connect(bind_buffer_updated)
	
	return
	
func bind_buffer_updated():
	G.Pipeline.buffer_updated.connect(on_buffer_updated)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	return

#endregion Node
