extends CharacterBody2D

@onready var walking_sound = $walking_sound

signal end_level

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var game_ended = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if (Input.is_action_just_pressed("up") or Input.is_action_just_pressed("jump")) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if not walking_sound.playing:
			walking_sound.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		walking_sound.stop()

	if velocity.x > 0:
		%AnimatedSprite2D.play("walk")
		%AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		%AnimatedSprite2D.play("walk")
		%AnimatedSprite2D.flip_h = true
	else:
		%AnimatedSprite2D.play("stand")
	move_and_slide()
	get_last_slide_collision()
	
	for i in get_slide_collision_count():
		var collider_shape = get_slide_collision(i).get_collider_shape()
		if collider_shape is Node:
			if collider_shape.is_in_group("EndLevel"):
				if not game_ended:
					emit_signal("end_level")
				game_ended = true
