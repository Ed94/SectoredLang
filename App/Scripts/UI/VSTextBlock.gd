class_name VSTextBlock extends RichTextLabel

var Margin : MarginContainer

class Token:
	var Text : String
	var Colour : Color
	
	func _init(text, color):
		Text   = text
		Colour = color
	
var Tokens : Array


func on_text_changed():
	var _font   = get_theme_font("normal")
	var _size   = get_theme_font_size("normal")
	var content = get_parsed_text()

	var width = custom_minimum_size.x
	for line in content.split("\n"):
		width = max(width, _font.get_string_size(line).x * 1.55)
		custom_minimum_size.x = width
	custom_minimum_size.y = content.split("\n").size() * _font.get_height(_size) * 1.2
	
	Margin.add_theme_constant_override("margin_top", custom_minimum_size.y * 1.4)
	
func add_TextHelper(token) -> String:
	var result : String
	
	if token.Colour:
		result += ("[color=#%x%x%x]{text}[/color]" % [
			token.Colour.r8, token.Colour.g8, token.Colour.b8]).format({ 
			"text" : token.Text
		})
	else:
		result += token.Text
	
	return result
	
func add_Text(newText : String, color : Color):
	var content : String
	
	var newToken = Token.new(newText, color)
	Tokens.append(newToken)

	for token in Tokens:
		content += add_TextHelper(token)
		
	text = "[center]" + content + "[/center]"
	on_text_changed()
	
func set_Text(newText : String, color : Color):
	var content : String
	if color:
		content += ("[color=#%x%x%x]{text}[/color]" % [
			color.r8, color.g8, color.b8]).format({ 
			"text" : newText
		})
	else:
		content += newText
		
	text = "[center]" + content +  "[/center]"
	on_text_changed()
	
func set_parent(parent):
	if Margin == null:
		Margin = MarginContainer.new()
		Margin.add_child(self)
	
	parent.add_child(Margin)
	
func remove_parent():
	get_parent().remove_child(self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	custom_minimum_size = Vector2i(250, 35)
	custom_minimum_size = Vector2i.ZERO
	bbcode_enabled = true
	Margin = MarginContainer.new()
	Margin.add_child(self)
	
	on_text_changed()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
