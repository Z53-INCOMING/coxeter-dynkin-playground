class_name CoxeterNode extends RigidBody2D

@onready var circle := $Circle
@onready var ring := $Ring
@onready var hitbox := $Hitbox

@onready var ringed_node_shape := preload("res://ringed_node.tres")
@onready var unringed_node_shape := preload("res://unringed_node.tres")

var grabbed := false
var grabbed_by := Vector2.ZERO
var when_grabbed := 0.0

var just_hollowed := false

var ringed: bool = false :
	set(value):
		ringed = value
		ring.visible = value
		hitbox.shape = ringed_node_shape if ringed else unringed_node_shape

var hollowed: bool = false :
	set(value):
		hollowed = value
		circle.color = Color.BLACK if value else Color.WHITE
		circle.scale = Vector2.ONE * 1.4 if value else Vector2.ONE
		ring.visible = hollowed if hollowed else ringed
		hitbox.shape = ringed_node_shape if hollowed else unringed_node_shape

func _ready():
	var angle := 0.0
	var points := PackedVector2Array()
	for i in 63:
		points.append(Vector2.from_angle(angle) * 24.0)
		angle += TAU / 64.0
	circle.polygon = points
	
	for i in 63:
		points[i] *= 1.56
	ring.points = points
	
	ringed = false

func _physics_process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		linear_velocity = Vector2.ZERO
	
	if Input.is_key_pressed(KEY_BACKSPACE):
		if get_global_mouse_position().distance_squared_to(position) < 24.0 * 24.0:
			queue_free()
	
	if grabbed:
		var motion_vector := get_global_mouse_position() - position - grabbed_by
		
		apply_central_impulse((motion_vector - (linear_velocity * 0.125)) * delta * 144.0)

func _input(event):
	var close := get_global_mouse_position().distance_squared_to(position) < 24.0 * 24.0
	
	if Input.is_action_pressed("snub") and close and !just_hollowed:
		hollowed = !hollowed
		just_hollowed = true
	
	if !close or !Input.is_action_pressed("snub"):
		just_hollowed = false
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			grabbed = false
			
			if close and (Time.get_ticks_msec() / 1000.0) - when_grabbed < 0.2:
				ringed = !ringed
		
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and close:
			grabbed = true
			grabbed_by = get_global_mouse_position() - position
			when_grabbed = Time.get_ticks_msec() / 1000.0
