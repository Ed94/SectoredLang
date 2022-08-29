class_name VSN_Nav extends PanelContainer

var Editor    :  VSN_Editor
var Margin    := MarginContainer.new()
var VBox      := VBoxContainer.new()
var VSN_Stack := []
var Current 



func place_back(parent : Node, widget : Node, index : int):
	parent.add_child(widget)
	parent.move_child(widget, index)
	return


# Selects the next inner navigatable (if available)
func enter():
	if Current == null:
		return
		
	if Current.get_class() != "VSNode":
		return
		
	if Current.get_child_count() == 1:
		return 
		
	VSN_Stack.append(Current)
		
	var vsn           = VSN_Stack.back()
	var parent        = get_parent()
	var pastIndex     = get_index()
	var currentsIndex = get_index()
	
	# Put VSN back in parent
	VBox.remove_child(Current)
	place_back(parent, Current, pastIndex)
	
	parent.remove_child(self)
	Current.position = Vector2.ZERO
	Current.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	Current.anchor_top = 0.0
	
	place_back(Current, self, 0)

	Current.remove_child(Current.Content)
	VBox.add_child(Current.Content)
	
	Current = Current.Content
		
	return

func leave():
	if Current == null || VSN_Stack.size() == 0:
		return
		
	var lastIndex = get_index()
	var last      = Current
	var vsn       = VSN_Stack.back()
	if  vsn.Content == Current:
		vsn.remove_child(self)
		VBox.remove_child(Current)
		
		# Add back VSN's content to its original position
		place_back(vsn, Current, lastIndex)
		
		var parent = vsn.get_parent()
		var index  = vsn.get_index()
		
		# Move the nav back to parent of VSN
		place_back(parent, self, index)
		parent.remove_child(vsn)
		
		position = Vector2.ZERO
		set_anchors_preset(Control.PRESET_CENTER_LEFT)
		anchor_top = 0.0
		
		# Move vsn back into the nav VBOX.
		VBox.add_child(vsn)
		
		Current = vsn
		VSN_Stack.pop_back()
		
	elif VSN_Stack.size() > 1:
		vsn.VB.remove_child(self)
		
		# Put current back in VSN VB slot.
		VBox.remove_child(Current)
		vsn.VB.add_child(Current)
		vsn.VB.move_child(Current, lastIndex)

		var parent      = VSN_Stack[VSN_Stack.size() - 2]
		var vsnIndex    = vsn.get_index()
		var content     = vsn.Content
		var parentIndex = parent.get_index()
		
		# Get the current vsn out of parent VB and move Nav into slot
		parent.VB.remove_child(vsn)
		parent.VB.add_child(self)
		parent.VB.move_child(self, vsnIndex)
		
		VBox.add_child(vsn)
		Current = vsn
		VSN_Stack.pop_back()
	else:
		# Need to go to editor scope
		vsn.VB.remove_child(self)
		
		# Put current back in VSN VB slot.
		VBox.remove_child(Current)
		vsn.VB.add_child(Current)
		vsn.VB.move_child(Current, lastIndex)
		
		var parent = vsn.get_parent()
		var index  = vsn.get_index()
		
		# Move the nav back to parent of VSN
		place_back(parent, self, index)
		parent.remove_child(vsn)
		
		position = Vector2.ZERO
		set_anchors_preset(Control.PRESET_CENTER_LEFT)
		anchor_top = 0.0
		anchor_bottom = 0.0
		
		# Move vsn back into the nav VBOX.
		VBox.add_child(vsn)
		
		Current = vsn
		VSN_Stack.pop_back()
		
	return
		
func up():
	if Current == null:
		return

	if VSN_Stack.size() == 0:
		return

	var lastIndex = get_index()
	var last      = Current		
	var vsn       = VSN_Stack.back()
		
	if vsn.Content == Current:
		leave()
		return
		
	# Inside VB
	if vsn.VB.has_node(self.get_path()):
		vsn.VB.remove_child(self)
		VBox.remove_child(Current)
		
		# Add back current VSN child to its original position
		place_back(vsn.VB, Current, lastIndex)
		
		if lastIndex == 0:
			# Move VSN content to nav VBOX
			var child = vsn.Content
			vsn.remove_child(child)
			VBox.add_child(child)
			
			# Setup nav in content's position
			place_back(vsn, self, 0)
			Current = child
			return

		# Move VSN VB child to nav VBOX
		var prevIndex = lastIndex - 1
		var child     = vsn.VB.get_child(prevIndex)
		vsn.VB.remove_child(child)
		VBox.add_child(child)
		
		# Setup nav in child's position
		place_back(vsn.VB, self, prevIndex)
		Current = child
		
	return
	
func down():
	if Current == null:
		return
	
	if VSN_Stack.size() == 0:
		return
	
	var lastIndex = get_index()
	var last      = Current		
	var vsn       = VSN_Stack.back()
		
	if vsn.Content == Current:
		vsn.remove_child(self)
		VBox.remove_child(Current)
		
		# Add back content to its original position
		place_back(vsn, Current, 0)
		
		# Move the nav to the first index of the VSN's VB
		place_back(vsn.VB, self, 0)
		
		# Move the first child of VSN to the Nav's VBOX.
		var child = vsn.VB.get_child(1)
		vsn.VB.remove_child(child)
		VBox.add_child(child)
		
		Current = child
		
		return
	
	if vsn.VB.has_node(self.get_path()):
		var nextIndex = lastIndex + 1
		if  nextIndex < vsn.VB.get_child_count():
			vsn.remove_child(self)
			VBox.remove_child(Current)
			
			# Add VB item to VBOX
			var child = vsn.VB.get_child(nextIndex)
			vsn.VB.remove_child(child)
			VBox.add_child(child)
			
			# Add back current VSN child to its original position
			place_back(vsn.VB, Current, lastIndex)
			
			# Slot in the nav to child's original location
			place_back(vsn.VB, self, nextIndex)
			
			Current = child
		else:
			leave()
			down()
			
	return



# Highlights and entire VSNode
func hover(vsnode):
	vsnode.get_parent().remove_child(vsnode)
	VBox.add_child(vsnode)
	
	vsnode.set_anchors_preset(Control.PRESET_CENTER)
	vsnode.set_position(Vector2(0, 0))
	
	Current = vsnode
#	VSN_Stack.append(vsnode)



#region Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Margin.name = "Margin"
	VBox.name = "VBox"
	add_child(Margin)
	
	Margin.set_anchors_preset(Control.PRESET_CENTER)
	
	var margin_value = 5
	Margin.add_theme_constant_override("margin_top", margin_value)
	Margin.add_theme_constant_override("margin_left", margin_value)
	Margin.add_theme_constant_override("margin_bottom", margin_value)
	Margin.add_theme_constant_override("margin_right", margin_value)
	
	Margin.add_child(VBox)
	return # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _init(editor):
	Editor = editor
	
#endregion Node
