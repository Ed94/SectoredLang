class_name AuxTab extends Button

@export  var AuxNode : Node


func on_Clicked(pressed):
	AuxNode.visible = pressed
	return


func _ready():
	self.toggled.connect(self.on_Clicked)
	
	assert(AuxNode.get("visible") != null, "AuxNode must have visible property!")
	return

