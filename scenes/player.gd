extends CharacterBody2D


const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * SPEED
	move_and_slide()
	
	if velocity.length() > 0.0:
		%Ampelmann_rot.hide()
	else:
		%Ampelmann_rot.show()
