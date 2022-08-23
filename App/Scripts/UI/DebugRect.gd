extends ReferenceRect

@onready var TxtLabel = get_node("Label") as RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TxtLabel.get_parent_area_size()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
