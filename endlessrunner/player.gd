extends CharacterBody3D
const SPEED = 7.0
const JUMP_VELOCITY = 4.5
@onready var anim_player: AnimationPlayer = $AuxScene/AnimationPlayer

func _ready() -> void:
	# Start running immediately
	anim_player.play("Running(2)0")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Global.JUMP_BOOST_TAKEN:
		Global.JUMP_BOOST_TAKEN = false
		Global.JUMP_BOOST = true
		
	if Global.JUMP_BOOST:
		Global.counter+=1
		if Global.counter == 800:
			Global.JUMP_BOOST = false
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if Global.JUMP_BOOST:
			velocity.y *= 2
		anim_player.play("Jumping0")
	
	# If we landed back on the floor AND we're not currently jumping, return to running
	if is_on_floor() and not Input.is_action_just_pressed("ui_accept") and anim_player.current_animation != "Running(2)0":
		anim_player.play("Running(2)0")
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	 
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if !(collider.is_in_group("terrain")):
			print("Collided with: ", collider)
			get_tree().quit()
