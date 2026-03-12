extends Node2D

const CUTE_SPIDER = preload("uid://bnn03bt1lwb0g")
const DRAG = preload("uid://dkfhmnuke066g")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func reset():
	get_tree().change_scene_to_file("res://scenes/" + get_tree().current_scene.name.to_snake_case() + ".tscn")


func _on_water_drop_interaction(from: Node2D, _with: Node2D) -> void:
	$Fire/AudioStreamPlayer2.play()
	$Fire.fade_away()
	from.fade_away()


func _on_bow_interaction(from: Node2D, _with: Node2D) -> void:
	$Bow/AudioStreamPlayer.stop()
	$Spider/AudioStreamPlayer2.play()
	
	var cute_spider = make_item("res://assets/ElinAssets/CuteSpider.png")
	cute_spider.global_position = $Spider.global_position + Vector2(0, 50)
	add_child(cute_spider)
	
	#var cute_spider = CUTE_SPIDER.instantiate()
	#cute_spider.global_position = $Spider.global_position + Vector2(0, 50)
	#add_child(cute_spider)
	
	$Spider.hide()
	$Bow.hide()
	await $Spider/AudioStreamPlayer2.finished
	$Bow.queue_free()
	$Spider.queue_free()


func _on_player_died() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_player_end_level() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func make_item(
	texture_path: String,
	draggable: bool = false,
	interact_with: Array[String] = [],
	sounds: Array[AudioStream] = [],
	) -> Node2D:
	var texture = load(texture_path)
	var item = DRAG.instantiate()
	item.texture = texture
	item.draggable = draggable
	item.interact_with = interact_with
	item.sounds = sounds
	return item
