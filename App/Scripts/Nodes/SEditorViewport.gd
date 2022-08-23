class_name SEditorViewport extends SubViewport

@onready var ViewContainer := get_parent() as SubViewportContainer
@onready var Cam := get_node("Camera2D") as Camera2D

#var zoom_factor = max(view_rect.size.x/view_size.x, view_rect.size.y/view_size.y)

func on_resized_Contaienr():
	size = ViewContainer.size
	return



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	center = (view_rect.position + view_rect.end)/2.0
	
#	ViewContainer.stretch = false
	ViewContainer.resized.connect(on_resized_Contaienr)
	size = ViewContainer.size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

		
	pass
