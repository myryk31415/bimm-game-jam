extends CharacterBody2D


const SPEED = 500.0
const JUMP_VELOCITY = -400.0

var current_mask = "forest"
var mask_animation ="forest"
var available_masks: Array[String] = []
var health = 100.0
var stress = 0.0

func set_health(amount: float):
	health = amount
	%HealthBar.value = health

func change_health(amount: float):
	health += amount
	if health > 100:
		health = 100
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	%HealthBar.value = health

func set_stress(amount: float):
	stress = amount
	%StressBar.value = stress

func change_stress(amount: float):
	stress += amount
	
	if stress < 0:
		stress = 0
	if stress >= 100:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	%StressBar.value = stress

func _ready() -> void:
	pass

# move function for sidescroller
func _physics_process(delta: float) -> void:
	check_mask(delta)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var animation: String = current_mask #get_node("/root/Game/CurrentLevel/").get_child(0).name.to_snake_case()
	
	if velocity.x > 0.1:
		if animation == "space":
			%AnimatedSprite2D.play_backwards(animation)
		else:
			%AnimatedSprite2D.play(animation)
	elif velocity.x < -0.1:
		if animation == "space":
			%AnimatedSprite2D.play(animation)
		else:
			%AnimatedSprite2D.play_backwards(animation)
	else:
		%AnimatedSprite2D.pause()
	
	move_and_slide()

func check_mask(delta: float):
	var level = get_node("/root/Game/CurrentLevel").get_child(0).name.to_snake_case()
	if current_mask!= level:
		if level == "masked_ball":
			change_stress(+10*delta)
		if level == "wasteland":
			change_health(-10*delta)
		if level == "factory":
			change_health(-10*delta)	
		if level == "space":
			change_health(-10*delta)
	elif level == "forest":
		change_stress(-5*delta)


func add_mask(mask: String):
	available_masks.append(mask)

func _input(event: InputEvent):
	if event.is_action("maske1"):
		#if available_masks.find("maske1") != -1:
		current_mask = "forest"
		%AnimatedSprite2D.play(current_mask)
	if event.is_action("maske2"):
		#if available_masks.find("maske2") != -1:
		current_mask = "factory"
		%AnimatedSprite2D.play(current_mask)
	if event.is_action("maske3"):
		#if available_masks.find("mask_ball") != -1:
		current_mask = "masked_ball"
		%AnimatedSprite2D.play(current_mask)
	if event.is_action("maske4"):
		#if available_masks.find("maske4") != -1:
		current_mask = "space"
		%AnimatedSprite2D.play(current_mask)
	if event.is_action("maske5"):
		#if available_masks.find("wasteland") != -1:
		current_mask = "wasteland"
		%AnimatedSprite2D.play(current_mask)
	if event.is_action("maske6"):
		if available_masks.find("maske6") != -1:
			current_mask = "maske6"
