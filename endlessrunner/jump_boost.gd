extends Area3D

const ROTATION_SPEED = 4

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	rotate_z(deg_to_rad(ROTATION_SPEED))
	
	if has_overlapping_bodies():
		queue_free()
	
