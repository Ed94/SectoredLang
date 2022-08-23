class_name SEditorCamera extends Camera2D

@onready var BG := get_node("BG") as Panel

var   Zoom_Target := 1.0
const Zoom_Step   := 0.1
const Zoom_Min    := 0.5
const Zoom_Max    := 2.0
const Zoom_Rate   := 8.0

var pan_speed = 800

var center 
var panning = false

func zoom_In() -> void:
	Zoom_Target = max(Zoom_Target - Zoom_Step, Zoom_Min)
	set_physics_process(true)
	
func zoom_Out() -> void:
	Zoom_Target = min(Zoom_Target + Zoom_Step, Zoom_Max)
	set_physics_process(true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Editor_Viewport_Pan"):
		panning = true
		
	if event.is_action_released("Editor_Viewport_Pan"):
		panning = false
		
	if event.is_action_pressed("Editor_Viewport_ZoomIn"):
		zoom_In()
		
	if event.is_action_pressed("Editor_Viewport_ZoomOut"):
		zoom_Out()
		
	if event is InputEventMouseMotion:
		if panning:
			position -= event.relative
			
			
func _physics_process(delta: float) -> void:
	zoom = lerp(
		zoom,
		Zoom_Target * Vector2.ONE,
		Zoom_Rate * delta
	)
	BG.size = get_viewport_rect().size * 1/ zoom

	set_physics_process( ! is_equal_approx(zoom.x, Zoom_Target) )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
