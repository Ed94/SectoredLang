class_name VSN_Editor extends Control

const SType := TParser.SType
const STxt  := TParser.STxt
const TType := Lexer.TType
const TypeColor  = GScript.TypeColor


@export var IndentSlider : HSlider


const Mode := {
	Edit = "Edit",
	Nav = "Nav",
}


var CurrentMode := Mode.Edit

var CodeEditor  := STextEditor.new()
var CodeEditor_DefaultSize : Vector2i = Vector2i(500, 200)

#var NavPanel := 

func create_CodeEditor():
	CodeEditor.name = "CodeEditor"
	add_child(CodeEditor)
#	CodeEditor.custom_minimum_size = CodeEditor_DefaultSize
	
	CodeEditor.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	CodeEditor.anchor_left = 0.0
	CodeEditor.anchor_top = 0.0
	CodeEditor.anchor_right = 0.35
	CodeEditor.anchor_bottom = 0.40

var NavPanel
func create_NavPanel():
	if NavPanel == null:
		NavPanel = VSN_Nav.new(self)
		NavPanel.name = "NavPanel"
		add_child(NavPanel)
		
		NavPanel.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	#	NavPanel.anchor_left = 0.0
		NavPanel.anchor_top = 0.0
	#	NavPanel.anchor_right = 0.65
		NavPanel.anchor_bottom = 0.35
		
		if SectorNodes.size() > 0:
			var test := SectorNodes[0] as VSNode
			NavPanel.hover(test)



var SectorNodes = []

var CurrentNode : Control
var LastMajorSector : Control

func process_Text():
	if G.check( G.TxtPipeline.Lex.tokenize(CodeEditor.text) ):
		return 
		
	var ast = G.TxtPipeline.SPars.parse_unit()
	
	if ast == null:
		return
		
	if ast.num_Entries() == 0:
		return
		
	if SectorNodes.size() > 0:
		SectorNodes[0].queue_free()
		SectorNodes.clear()
		
	CodeEditor.visible = false
	
	
	var sectorNode = VSNode.new(ast.entry(1), null, false)
	self.add_child(sectorNode)
	sectorNode.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	sectorNode.generate()
	
	SectorNodes.append(sectorNode)
	LastMajorSector = sectorNode
	
	return;
	

#region IndentSlider
func on_indent_changed(value : float):
	for sector in SectorNodes:
		sector.set_Indent(value)
			
	return	
#endregion IndentSlider


#region Node

func _unhandled_input(event: InputEvent) -> void:
	match CurrentMode:
		Mode.Edit:
			if event.is_action_pressed("SEditor_Mode_Nav"):
				process_Text()
				CurrentMode = Mode.Nav	
				create_NavPanel()
		Mode.Nav:
			if event.is_action_pressed("SEditor_Mode_Edit"):
				for sector in SectorNodes:
					var control = sector as Control
					control.visible = false
					CodeEditor.visible = true
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	IndentSlider.value_changed.connect(on_indent_changed)
	
	create_CodeEditor()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	return

#endregion Node
