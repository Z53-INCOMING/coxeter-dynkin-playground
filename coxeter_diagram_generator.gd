extends Node2D

var drawing := false

var last_spawn_position := Vector2(-1296.0, 0.0)

var last_node: CoxeterNode = null

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			drawing = !drawing
			last_node = null

func _process(delta):
	if drawing:
		if last_spawn_position.distance_squared_to(get_global_mouse_position()) > 180.0 * 180.0:
			spawn_node(last_node)

func spawn_node(connect_to: CoxeterNode):
	pass
