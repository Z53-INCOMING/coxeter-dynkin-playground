class_name CoxeterEdge extends Node2D

var node_a: CoxeterNode = null
var node_b: CoxeterNode = null

@onready var line := $Line

func _physics_process(delta):
	if is_instance_valid(node_a) && is_instance_valid(node_b):
		line.points = [node_a.position, node_b.position]
		
		var ab_vector := node_b.position - node_a.position
		var ab_distance := ab_vector.length()
		
		var spring_value := ab_distance - 120.0 # 120.0 is the desired distance
		
		node_a.apply_central_impulse(ab_vector.normalized() * spring_value)
		node_b.apply_central_impulse(-ab_vector.normalized() * spring_value)
	else:
		line.points = []
