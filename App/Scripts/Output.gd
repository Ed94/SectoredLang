class_name Output extends Window


@onready var OutView := get_node("OutView") as TextEdit




func write(message : String):
	OutView.text += message
	return



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
