extends RigidBody2D

@onready var _control = $Control

func enter_hell() -> void:
	_control.enter_hell()

func exit_hell() -> void:
	_control.exit_hell()

# func _ready() -> void:
	# _idle_wiggle()

func _idle_wiggle():
	while true:
		var t = create_tween()
		t.set_parallel(true)

		t.tween_property(self, "rotation", 1, 1).as_relative()
		t.tween_property(self, "scale", Vector2.ONE * 2, 1)

		t.chain().set_parallel(true)
		t.tween_property(self, "rotation", -2, 1).as_relative()
		t.tween_property(self, "scale", Vector2.ONE * 0.5, 1)

		t.chain().set_parallel(true)
		t.tween_property(self, "rotation", 1, 1).as_relative()
		t.tween_property(self, "scale", Vector2.ONE, 1)
		return
