class_name VSNav extends PanelContainer

var Editor    :  VSEditor
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
	if Current == null \
	|| Current.get_class() != "VSNode" \
	|| Current.get_child_count() == 1:
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
	place_back(Current, self, 0)

	Current.remove_child(Current.Content)
	VBox.add_child(Current.Content)
	
	Current = Current.Content
	on_nav_moved()
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
		place_back(parent.VB, self, vsnIndex)
		
		VBox.add_child(vsn)
		Current = vsn
		VSN_Stack.pop_back()
	else:
		# Need to go to editor scope
		vsn.VB.remove_child(self)
		
		# Put current back in VSN VB slot.
		VBox.remove_child(Current)
		place_back(vsn.VB, Current, lastIndex)
		
		var parent = vsn.get_parent()
		var index  = vsn.get_index()
		
		# Move the nav back to parent of VSN
		place_back(parent, self, index)
		parent.remove_child(vsn)
		
		# Move vsn back into the nav VBOX.
		VBox.add_child(vsn)
		
		Current = vsn
		VSN_Stack.pop_back()
		
	on_nav_moved()
	return
		
func up():
	if Current == null:
		return

	if VSN_Stack.size() > 0:
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
				
				on_nav_moved()
				return

			# Move VSN VB child to nav VBOX
			var prevIndex = lastIndex - 1
			var child     = vsn.VB.get_child(prevIndex)
			vsn.VB.remove_child(child)
			VBox.add_child(child)
			
			# Setup nav in child's position
			place_back(vsn.VB, self, prevIndex)
			Current = child
	else:
		var lastIndex     = get_index()
		var parent        = Editor.SVB
		var currentsIndex = get_index()
		
		var SNs        = Editor.SectorNodes
		var nextVSN_ID =  SNs.find(Current) - 1
		
		if SNs.size() <= nextVSN_ID:
			on_nav_moved()
			return
		
		var nextVSN = SNs[ nextVSN_ID ]
		
		VBox.remove_child(Current)
		place_back(parent, Current, lastIndex)
		
		parent.remove_child(self)
		
		## Put VSN inside Nav
		parent.remove_child(nextVSN)
		VBox.add_child(nextVSN)
		place_back(parent, self, nextVSN_ID)
		
		Current = nextVSN
		
	on_nav_moved()
	return
	
func down():
	if Current == null:
		return
	
	if VSN_Stack.size() > 0:
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
			on_nav_moved()
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
				on_nav_moved()
			else:
				leave()
				down()
				on_nav_moved()
	else:
		var lastIndex     = get_index()
		var parent        = Editor.SVB
		var currentsIndex = get_index()
		
		var SNs        = Editor.SectorNodes
		var nextVSN_ID =  SNs.find(Current) + 1
		
		if SNs.size() <= nextVSN_ID:
			nextVSN_ID = 0
		
		var nextVSN = SNs[ nextVSN_ID ]
		
		VBox.remove_child(Current)
		place_back(parent, Current, lastIndex)
		
		parent.remove_child(self)
		
		parent.remove_child(nextVSN)
		VBox.add_child(nextVSN)
		place_back(parent, self, nextVSN_ID)

		Current = nextVSN
		on_nav_moved()
	return

# Highlights and entire VSNode
func hover(vsnode):
	Editor.SVB.remove_child(vsnode)
	VBox.add_child(vsnode)
	place_back(Editor.SVB, self, 0)
	
	Current = vsnode
	
func disengage():
	if VSN_Stack.size() > 0:
		leave()
	
	if Current == null:
		return
		
	VBox.remove_child(Current)
	Editor.SVB.add_child(Current)
	Editor.SVB.add_child(self)

func on_nav_moved():
	call_deferred("defer")
	
func defer():
	if ! Editor.FollowOpt:
		return
	
	var cam = Editor.Cam
	var rect = get_global_rect()

	var rectpos = rect.position
	var rectsize = rect.size
	
	if Current.get_class() == "VSNode":
		rectsize = Current.Content.get_global_rect().size

	cam.move_to( Vector2(rectpos.x * 1.5, rectpos.y) + Vector2(0, rectsize.y) )
	return


func inplace_Editor():
	var CodeView = Editor.CodeEditor
	
	var vsn = Current
	
	if VSN_Stack.back():
		vsn = Current
	
	CodeView.text = vsn.str_Content()
	Current.visible = false
	Editor.SVB.remove_child(CodeView)
	VBox.add_child(CodeView)
	CodeView.visible = true
	
func generate_Inplace():
	var CodeView = Editor.CodeEditor
	
	var vsn = Current
	
	if VSN_Stack.back():
		vsn = Current
		
		


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






