class_name STextEditor extends CodeEdit

class KeywordsPreset:
	var Keywords : Array
	var HColor   : Color
	
	func _init(keywords : Array, color : Color):
		Keywords = keywords
		HColor   = color
		
var SectorGeneral := KeywordsPreset.new(
	[
		"alias",
		"enum",
		"struct",
		"type",
		"tt",
		"union",
		"using",
		
		"private",
		"external",
		"export"
	],
	Color.GOLD
)

var Memory := KeywordsPreset.new(
	[
		"allocator",
		"heap",
		"stack",
		"static",
		"allocate",
		"resize",
		"free",
		"wipe"
	],
	Color.RED
)

var Builtin := KeywordsPreset.new(
	[
		"bool",
		"ptr",
		"ro",
		"default",
		"string",
		"float",
		"int",
		"array",
		"map",
	],
	Color.MEDIUM_PURPLE
)

var ControlFlow := KeywordsPreset.new(
	[
		"break",
		"else",
		"exe",
		"if",
		"loop",
		"switch",
		"ret"
	],
	Color.CHARTREUSE
)

var Op := KeywordsPreset.new(
	[
		"cast",
	],
	Color.AQUA
)

var Literal := KeywordsPreset.new(
	[
		"true",
		"false",
	],
	Color.SANDY_BROWN
)


var Presets := [
	Builtin,
	Memory,
	ControlFlow,
	Literal,
	Op,
	SectorGeneral
]

@onready var Highlighter := CodeHighlighter.new()

func on_text_changed():
	var _font = get_theme_font("normal")
	var _size = get_theme_font_size("normal")

	var width = custom_minimum_size.x
	for line in text.split("\n"):
		width = max(width, _font.get_string_size(line).x * 1.55)
		custom_minimum_size.x = width
	custom_minimum_size.y = text.split("\n").size() * _font.get_height(_size) * 1.2



func _unhandled_input(event: InputEvent) -> void:	
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size = Vector2i(250, 35)
	
	Highlighter.clear_color_regions()
	Highlighter.clear_keyword_colors()
	Highlighter.clear_member_keyword_colors()
	Highlighter.clear_highlighting_cache()
	
	Highlighter.number_color          = Color.SANDY_BROWN
	Highlighter.symbol_color          = Color.AQUA
	Highlighter.member_variable_color = Color.BLANCHED_ALMOND
	Highlighter.function_color        = Color.BLANCHED_ALMOND

	for preset in Presets:
		for keyword in preset.Keywords:
			Highlighter.add_keyword_color(keyword, preset.HColor)
		
		
	syntax_highlighter = Highlighter
	
	text_changed.connect(on_text_changed)
	text_set.connect(on_text_changed)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
