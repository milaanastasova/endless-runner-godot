extends Area3D

const ROTATION_SPEED = 4

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	rotate_z(deg_to_rad(ROTATION_SPEED))
	

func _on_body_entered(body: Node3D) -> void:
	Global.JUMP_BOOST_TAKEN = true
	queue_free()
