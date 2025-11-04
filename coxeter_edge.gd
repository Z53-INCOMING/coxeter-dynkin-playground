class_name CoxeterEdge extends Node2D

var node_a: CoxeterNode = null
var node_b: CoxeterNode = null

@onready var line := $Line

func _physics_process(delta):
	if is_instance_valid(node_a) && is_instance_valid(node_b):
		line.points = [node_a.position, node_b.position]
	else:
		line.points = []
