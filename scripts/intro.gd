extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%AnimatedSprite2D.play("default")
	await %AnimatedSprite2D.animation_finished
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
