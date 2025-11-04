class_name CoxeterEdge extends Node2D

var node_a: CoxeterNode = null
var node_b: CoxeterNode = null

@onready var line := $Line

func _physics_process(delta):
	if is_instance_valid(node_a) && is_instance_valid(node_b):
		apply_spring(delta)
		
		if Input.is_key_pressed(KEY_BACKSPACE):
			if line_sdf(get_global_mouse_position(), node_a.position, node_b.position) < 9.0:
				queue_free()
	else:
		queue_free()

func apply_spring(delta: float):
	line.points = [node_a.position, node_b.position]
	
	var ab_vector := node_b.position - node_a.position
	var ab_distance := ab_vector.length()
	
	var spring_value := ab_distance - 120.0 # 120.0 is the desired distance
	var spring_strength := 1296.0 if Input.is_key_pressed(KEY_SPACE) else 36.0
	
	node_a.apply_central_impulse(ab_vector.normalized() * spring_value * 0.5 * delta * spring_strength)
	node_b.apply_central_impulse(-ab_vector.normalized() * spring_value * 0.5 * delta * spring_strength)

# not my code :(
func line_sdf(input_point: Vector2, point_a: Vector2, point_b: Vector2) -> float:
	var a_to_input := input_point - point_a
	var a_to_b := point_b - point_a
	var h := clampf(a_to_input.dot(a_to_b) / a_to_b.dot(a_to_b), 0.0, 1.0)
	
	return (a_to_input - (a_to_b * h)).length();
