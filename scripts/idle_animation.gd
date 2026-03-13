extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while get_parent().draggable:
		await get_tree().create_timer(randfn(3, 10)).timeout
		_bounce()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _bounce():
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(get_parent(), "scale", Vector2.ONE * 1.1, 0.15)
	tween.chain()
	tween.tween_property(get_parent(), "scale", Vector2.ONE, 0.15)
