class_name UnitFileTxt extends File

var text        : String
var lastModifed : int

func open_Unit(path : String):
	if is_open():
		close()
	
	var error := open(path, File.READ_WRITE)
	
	if G.check(error == OK, "Failed to open unit file"):
		return
		
	lastModifed
	buffer()
	return

func save():
	if ! is_open():
		return
	
	open(get_path(), File.WRITE_READ)
	
	store_string(text)
	flush()
	return
	
func buffer():
	text = get_as_text()
	
	G.TxtPipeline.on_BufferUpdated()
	return


#region Object

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#endregion Object
