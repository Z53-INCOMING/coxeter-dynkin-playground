extends Node2D

var drawing := false

var last_spawn_position := Vector2(-1296.0, 0.0)

var last_node: CoxeterNode = null

@onready var coxeter_node_scene := preload("res://coxeter_node.tscn")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			drawing = !drawing
			last_node = null

func _process(delta):
	if drawing:
		if last_spawn_position.distance_squared_to(get_global_mouse_position()) > 120.0 * 120.0:
			spawn_node(last_node)

func spawn_node(connect_to: CoxeterNode):
	var coxeter_node: CoxeterNode = coxeter_node_scene.instantiate()
	
	coxeter_node.position = get_global_mouse_position()
	coxeter_node.linear_velocity = random_point_in_circle(18.0)
	last_spawn_position = get_global_mouse_position()
	
	add_child(coxeter_node)

func random_point_in_circle(radius: float) -> Vector2:
	var point := Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
	
	while point.length_squared() > radius * radius:
		point = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
	
	return point
