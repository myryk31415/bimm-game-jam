extends Node2D

const CUTE_SPIDER = preload("uid://bnn03bt1lwb0g")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func reset():
	get_tree().change_scene_to_file("res://scenes/" + get_tree().current_scene.name.to_snake_case() + ".tscn")


func _on_water_drop_interaction() -> void:
	$Fire/AudioStreamPlayer2.play()
	$Fire.fade_away()
	$WaterDrop.fade_away()


func _on_bow_interaction() -> void:
	var cute_spider = CUTE_SPIDER.instantiate()
	cute_spider.global_position = $Spider.global_position + Vector2(0, 50)
	add_child(cute_spider)
	$Spider.queue_free()
	$Bow.queue_free()


func _on_player_died() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_player_end_level() -> void:
	reset()
