extends StaticBody2D

@export var start: int:
	set(value):
		%Start.position.x = value

@export var end: int:
	set(value):
		%End.position.x = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
