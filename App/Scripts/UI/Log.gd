class_name Log extends Window

const LogEntry : PackedScene = preload("res://Scenes/Log/LogEntry.tscn")

@export var TabBtn : Button

@onready var Scroll  := get_node("Panel/ScrollContainer")
@onready var Entires := get_node("Panel/ScrollContainer/Entries")
@onready var GScript := get_node("/root/G")


const EType : Dictionary = \
{
	veryVerbose = "Very Verbose",
	verbose     = "Verbose",
	log         = "Log",
	warning     = "Warning",
	error       = "Error"
}


func out(type : String, message : String):
	var newEntry = LogEntry.instantiate()
	Entires.add_child(newEntry)
	
	while newEntry == null || !newEntry.is_ready():
		await get_tree().create_timer(0.01).timeout
		
	newEntry.set_Data(type, message)

	if type == EType.error:
		newEntry.set_Color(Color.RED)
#		TabBtn.button_pressed = true
		
	await get_tree().create_timer(0).timeout
	var \
	vbar : VScrollBar = Scroll.get_v_scroll_bar()
	vbar.value = vbar.max_value
	return

#region Node
func _ready():
	size = Vector2(500, 100)
	
	out(EType.log, "Log initialized")
	G.Log = self
	return
#endregion Node

#region Object
func _init() -> void:
	return
#endregion Object
