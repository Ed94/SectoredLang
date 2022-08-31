class_name VSEditorCamera extends Camera2D

@onready var Reticle := get_parent().get_node("Reticle")
@onready var BG := get_node("BG") as Panel
@export  var HB : HBoxContainer

var   Zoom_Target := 1.0
const Zoom_Step   := 0.1
const Zoom_Min    := 0.5
const Zoom_Max    := 2.0
const Zoom_Rate   := 8.0

var   Scroll_Target : Vector2
const Scroll_Rate   := 120.0

var Move_Target : Vector2
var Move_Rate := 3.0

var pan_speed    = 800
var scroll_speed = 400

var center : Vector2
var panning = false

func move_to(target : Vector2):
	Move_Target = target
	set_physics_process(true)

func recenter() -> void:
	center   = HB.size / 2
	position = center
	Move_Target = center
	
func update_BG() -> void:
	BG.size = get_viewport_rect().size * 1/zoom
	BG.position = -BG.size / 2

func scroll_Up() -> void:
	if is_physics_processing():
		Move_Target -= Vector2(0, Scroll_Rate)
		return
	
	Move_Target = position - Vector2(0, Scroll_Rate)
	set_physics_process(true)
	
func scroll_Down() -> void:
	if is_physics_processing():
		Move_Target += Vector2(0, Scroll_Rate)
		return
	
	Move_Target = position + Vector2(0, Scroll_Rate)
	set_physics_process(true)

func zoom_In() -> void:
	Zoom_Target = max(Zoom_Target - Zoom_Step, Zoom_Min)
	set_physics_process(true)
	
func zoom_Out() -> void:
	Zoom_Target = min(Zoom_Target + Zoom_Step, Zoom_Max)
	set_physics_process(true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Editor_Viewport_ScrollUp") && !Input.is_key_pressed(KEY_CTRL):
		scroll_Up()
		
	if event.is_action_pressed("Editor_Viewport_ScrollDown") && !Input.is_key_pressed(KEY_CTRL):
		scroll_Down()
		
	if event.is_action_pressed("VSN_Viewport_ToggleReticle"):
		Reticle.visible = ! Reticle.visible
	
	if event.is_action_pressed("Editor_Viewport_Pan"):
		panning = true
		set_physics_process(false)
		
	if event.is_action_released("Editor_Viewport_Pan"):
		panning = false
		Move_Target = position
		set_physics_process(false) 
		
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
	
	position = lerp(
		position,
		Move_Target,
		Move_Rate * delta
	)
	
	update_BG()

	var atMoveTarget   = is_equal_approx(position.x, Move_Target.x) && is_equal_approx(position.y, Move_Target.y)
	var scrollAtTarget = false # is_equal_approx(position.y, Scroll_Target)
	var zoomAtTarget   = is_equal_approx(zoom.x, Zoom_Target)

	set_physics_process( !(zoomAtTarget && atMoveTarget) )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Center of cam is offset by half-point of HB.
	recenter()
	update_BG()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
