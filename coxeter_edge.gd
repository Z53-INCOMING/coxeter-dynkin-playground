class_name CoxeterEdge extends Node2D

var node_a: CoxeterNode = null
var node_b: CoxeterNode = null

@onready var line := $Line
@onready var label := $LabelOrigin/Label
@onready var label_origin := $LabelOrigin

var just_ghosted := false

var weight := Vector2i(3, 1)

var start_pressed := 0.0

var length := 120.0

func _physics_process(delta):
	if is_instance_valid(node_a) && is_instance_valid(node_b):
		line.points = [node_a.position, node_b.position]
		label_origin.position = get_edge_position()
		
		apply_spring(delta)
		
		if Input.is_key_pressed(KEY_BACKSPACE):
			if line_sdf(get_global_mouse_position(), node_a.position, node_b.position) < 9.0:
				queue_free()
		
		if Input.is_action_pressed("ghost edge"):
			if line_sdf(get_global_mouse_position(), node_a.position, node_b.position) < 9.0:
				if !just_ghosted:
					just_ghosted = true
					visible = !visible
			else:
				just_ghosted = false
		else:
			just_ghosted = false
		
		if Input.is_action_just_pressed("numerator up"):
			if line_sdf(get_global_mouse_position(), node_a.position, node_b.position) < 9.0:
				weight.x += 1
				update_weight_label()
		if Input.is_action_just_pressed("numerator down"):
			if line_sdf(get_global_mouse_position(), node_a.position, node_b.position) < 9.0:
				weight.x = maxi(weight.x - 1, 3)
				update_weight_label()
		if Input.is_action_just_pressed("denominator up"):
			if line_sdf(get_global_mouse_position(), node_a.position, node_b.position) < 9.0:
				weight.y += 1
				update_weight_label()
		if Input.is_action_just_pressed("denominator down"):
			if line_sdf(get_global_mouse_position(), node_a.position, node_b.position) < 9.0:
				weight.y = maxi(weight.y - 1, 1)
				update_weight_label()
	else:
		queue_free()

func apply_spring(delta: float):
	var ab_vector := node_b.position - node_a.position
	var ab_distance := ab_vector.length()
	
	var spring_value := ab_distance - length
	var spring_strength := 1296.0 if Input.is_key_pressed(KEY_SPACE) else 36.0
	
	node_a.apply_central_impulse(ab_vector.normalized() * spring_value * 0.5 * delta * spring_strength)
	node_b.apply_central_impulse(-ab_vector.normalized() * spring_value * 0.5 * delta * spring_strength)

# not my code :(
func line_sdf(input_point: Vector2, point_a: Vector2, point_b: Vector2) -> float:
	var a_to_input := input_point - point_a
	var a_to_b := point_b - point_a
	var h := clampf(a_to_input.dot(a_to_b) / a_to_b.dot(a_to_b), 0.0, 1.0)
	
	return (a_to_input - (a_to_b * h)).length();

func get_edge_position() -> Vector2:
	return (node_a.position + node_b.position) / 2.0

func update_weight_label():
	if weight.y == 1:
		label.text = "" if weight.x == 3 else str(weight.x)
	else:
		label.text = str(weight.x) + "/" + str(weight.y)
	
	length = maxf(120.0, label.text.length() * 50.0)
