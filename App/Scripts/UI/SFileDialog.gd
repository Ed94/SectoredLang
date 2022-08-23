class_name SLFileDialog extends FileDialog

@export var TabBtn : Button

func on_file_selected(path: String):
	G.TxtPipeline.CurrentFile.open_Unit(path)
	
	return
	
func on_close_requested():
	TabBtn.button_pressed = false
	

#region Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("file_selected", on_file_selected)
	self.connect("close_requested", on_close_requested)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#endregion Node
