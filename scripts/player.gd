extends CharacterBody2D

@onready var walking_sound = $walking_sound

signal end_level
signal died

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var game_ended = false
var flipping = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if Input.is_action_just_pressed("flip") and not flipping:
			flipping = true
			%AnimationPlayer.play("flip")
		if Input.is_action_just_pressed("backflip") and not flipping:
			flipping = true
			%AnimationPlayer.play("backflip")
	
	# Handle jump.
	if (Input.is_action_just_pressed("up") or Input.is_action_just_pressed("jump")) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if $cry_sound.playing:
			$cry_sound.stop()
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
	elif %AnimatedSprite2D.animation != "crying":
		%AnimatedSprite2D.play("idle")
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Node:
			if collider.is_in_group("KillPlayer"):
				die()
		var collider_shape = collision.get_collider_shape()
		if collider_shape is Node:
			if collider_shape.is_in_group("KillPlayer"):
				die()
			elif collider_shape.is_in_group("EndLevel"):
				end()

func die():
	if not game_ended:
		%AnimationPlayer.play("death")
		game_ended = true
		died.emit()

func end():
	if not game_ended:
		game_ended = true
		end_level.emit()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flip":
		flipping = false
	if anim_name == "backflip":
		flipping = false
	%AnimationPlayer.play("RESET")
