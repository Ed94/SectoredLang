class_name VSE_ViewportContainer extends SubViewportContainer


@onready var SView := get_node("SubViewport") as VSEditorViewport

var mouse_inside = true

func on_mouse_entered():
	SView.gui_disable_input = false

func on_mouse_exited():
	SView.gui_disable_input = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	
	mouse_filter = Control.MOUSE_FILTER_STOP
#	mouse_default_cursor_shape = Control.CURSOR_CROSS
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_pos = SView.get_mouse_position()
	var size = SView.size
	
	if mouse_pos.y <= 0 or mouse_pos.y >= size.y or mouse_pos.x <= 0 or mouse_pos.x >= size.x:
		if mouse_inside:
			on_mouse_exited()
			mouse_inside = false
	elif ! mouse_inside: 
		on_mouse_entered()
		mouse_inside = true
	pass
