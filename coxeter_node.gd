class_name CoxeterNode extends RigidBody2D

@onready var circle := $Circle
@onready var ring := $Ring

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
