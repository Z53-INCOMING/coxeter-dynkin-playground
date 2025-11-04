class_name CoxeterNode extends RigidBody2D

@onready var circle := $Circle
@onready var ring := $Ring
@onready var hitbox := $Hitbox

@onready var ringed_node_shape := preload("res://ringed_node.tres")
@onready var unringed_node_shape := preload("res://unringed_node.tres")

var ringed: bool = false :
	set(value):
		ringed = value
		ring.visible = value
		hitbox.shape = ringed_node_shape if ringed else unringed_node_shape

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
	
	ringed = randi() % 2 == 0
