extends Node2D

var drawing := false

var last_spawn_position := Vector2(-1296.0, 0.0)

var last_node: CoxeterNode = null
var second_to_last_node: CoxeterNode = null

@onready var coxeter_node_scene := preload("res://coxeter_node.tscn")
@onready var coxeter_edge_scene := preload("res://coxeter_edge.tscn")

var has_gravity := false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			drawing = !drawing
			last_node = null
			second_to_last_node = null
	if event is InputEventKey:
		if event.keycode == KEY_DOWN and event.pressed:
			has_gravity = !has_gravity
			
			if has_gravity:
				var physics_space := get_viewport().find_world_2d().space
				PhysicsServer2D.area_set_param(physics_space, PhysicsServer2D.AREA_PARAM_GRAVITY, 2592.0)
				PhysicsServer2D.area_set_param(physics_space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2.DOWN)
			else:
				var physics_space := get_viewport().find_world_2d().space
				PhysicsServer2D.area_set_param(physics_space, PhysicsServer2D.AREA_PARAM_GRAVITY, 0.0)
				PhysicsServer2D.area_set_param(physics_space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, Vector2.ZERO)

func _process(_delta):
	if drawing:
		spawn_node()

func spawn_node():
	var closest_distance := INF
	for node in get_tree().get_nodes_in_group("coxeter nodes"):
		var distance := get_global_mouse_position().distance_squared_to(node.position)
		if distance < closest_distance:
			closest_distance = distance
		
		if get_global_mouse_position().distance_squared_to(node.position) < 41.94 * 41.94 and node != last_node and node != second_to_last_node: # connect to old node
			var edge_already_exists := false
			for edge in get_tree().get_nodes_in_group("coxeter edges"):
				if (edge.node_a == last_node and edge.node_b == node) or (edge.node_a == node and edge.node_b == last_node):
					edge_already_exists = true
					break
			
			if !edge_already_exists:
				var coxeter_edge: CoxeterEdge = coxeter_edge_scene.instantiate()
				
				coxeter_edge.node_a = last_node
				coxeter_edge.node_b = node
				
				add_child(coxeter_edge)
				second_to_last_node = last_node
				last_node = node
			return
	
	if last_spawn_position.distance_squared_to(get_global_mouse_position()) > 120.0 * 120.0 and closest_distance > 72.0 * 72.0:
		# create new node
		var coxeter_node: CoxeterNode = coxeter_node_scene.instantiate()
		
		coxeter_node.position = get_global_mouse_position()
		coxeter_node.linear_velocity = random_point_in_circle(12.0)
		last_spawn_position = get_global_mouse_position()
		
		add_child(coxeter_node)
		
		# if this isn't the start of a chain, connect to the previous
		if is_instance_valid(last_node):
			var coxeter_edge: CoxeterEdge = coxeter_edge_scene.instantiate()
			
			coxeter_edge.node_a = last_node
			coxeter_edge.node_b = coxeter_node
			
			add_child(coxeter_edge)
		
		second_to_last_node = last_node
		last_node = coxeter_node

func random_point_in_circle(radius: float) -> Vector2:
	var point := Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
	
	while point.length_squared() > radius * radius:
		point = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
	
	return point
