extends Node2D

var drawing := false

var last_spawn_position := Vector2(-1296.0, 0.0)

var last_node: CoxeterNode = null

@onready var coxeter_node_scene := preload("res://coxeter_node.tscn")
@onready var coxeter_edge_scene := preload("res://coxeter_edge.tscn")

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
	coxeter_node.linear_velocity = random_point_in_circle(12.0)
	last_spawn_position = get_global_mouse_position()
	
	add_child(coxeter_node)
	
	if is_instance_valid(last_node):
		var coxeter_edge: CoxeterEdge = coxeter_edge_scene.instantiate()
		
		coxeter_edge.node_a = last_node
		coxeter_edge.node_b = coxeter_node
		
		add_child(coxeter_edge)
	
	last_node = coxeter_node

func random_point_in_circle(radius: float) -> Vector2:
	var point := Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
	
	while point.length_squared() > radius * radius:
		point = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
	
	return point
