extends HSplitContainer

var LTime      : RichTextLabel
var Type       : RichTextLabel   
var Message    : RichTextLabel
var StackTrace : String


func set_Color(color : Color):
	LTime.add_theme_color_override("default_color", color)
	Type.add_theme_color_override("default_color", color)
	Message.add_theme_color_override("default_color", color)
	
func is_ready():
	return get_node("Time") != null \
		|| get_node("HSplitContainer/Type") != null \
		|| get_node("HSplitContainer/Message") != null

func set_Data(type : String, message : String, stacktrace := ""):
	LTime.text   = Time.get_datetime_string_from_system()
	Type.text    = type
	Message.text = message
	StackTrace   = stacktrace

#region Node
func _ready():
	while !is_ready():
		await get_tree().create_timer(0).timeout
	
	LTime   = get_node("Time")
	Type    = get_node("HSplitContainer/Type")
	Message = get_node("HSplitContainer/Message")
#endregion Node
