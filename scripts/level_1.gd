extends Node2D

const CUTE_SPIDER = preload("uid://bnn03bt1lwb0g")
const DRAG = preload("uid://dkfhmnuke066g")
var bow_used = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func reset():
	get_tree().change_scene_to_file("res://scenes/" + get_tree().current_scene.name.to_snake_case() + ".tscn")


func _on_water_drop_interaction(from: Drag, _with: Drag) -> void:
	$Fire/AudioStreamPlayer2.play()
	$Fire.fade_away()
	from.fade_away()


func _on_bow_interaction(from: Drag, with: Drag) -> void:
	$Bow/AudioStreamPlayer.stop()
	if with == $Spider and not bow_used:
		bow_used = true
		$Spider/AudioStreamPlayer2.play()
		
		var cute_spider = make_item("res://assets/ElinAssets/CuteSpider.png")
		cute_spider.name = "cute_spider"
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
	if with == $Fire and not bow_used:
		bow_used = true
		var BurntBow = make_item("res://assets/ElinAssets/BowBurned.png",true)
		BurntBow.global_position = from.global_position
		add_child(BurntBow)
		from.queue_free()


func _on_player_died() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")


func _on_player_end_level() -> void:
	get_tree().change_scene_to_file("res://scenes/outro.tscn")

func make_item(
	texture_path: String,
	draggable: bool = false,
	interact_with: Array[String] = [],
	sounds: Array[AudioStream] = [],
	collidable: bool = true,
	) -> Drag:
	var texture = load(texture_path)
	var item = DRAG.instantiate()
	item.texture = texture
	item.draggable = draggable
	item.collidable = collidable
	item.interact_with = interact_with
	item.sounds = sounds
	return item


func _on_ice_cream_interaction(from: Drag, _with: Drag) -> void:
	$IceCream/AudioStreamPlayer.stop()
	var IceCreamBite = make_item("res://assets/ElinAssets/IceCreamBite.png",true)
	IceCreamBite.global_position = from.global_position
	add_child(IceCreamBite)
	from.queue_free()


func _on_butterfly_interaction(from: Drag, _with: Drag) -> void:
	$Butterfly/AudioStreamPlayer.stop()
	var BurnButterfly = make_item("res://assets/ElinAssets/ButterflyBurning.png",true)
	BurnButterfly.global_position = from.global_position
	add_child(BurnButterfly)
	from.queue_free()


func _on_muffin_interaction(from: Drag, with: Drag) -> void:
	if with.name == "Fire":
		$Muffin/AudioStreamPlayer.stop()
		var BurntMuffin = make_item("res://assets/ElinAssets/MuffinBurned.png",true)
		BurntMuffin.global_position = from.global_position
		add_child(BurntMuffin)
		from.queue_free()
	else:
		var BittenMuffin = make_item("res://assets/ElinAssets/MuffinBite.png",true)
		BittenMuffin.global_position = from.global_position
		add_child(BittenMuffin)
		from.queue_free()


func _on_star_interaction(from: Drag, _with: Drag) -> void:
	$Star/AudioStreamPlayer.stop()
	var AngryStar = make_item("res://assets/ElinAssets/StarHurt.png",true)
	AngryStar.global_position = from.global_position
	add_child(AngryStar)
	from.queue_free()


func _on_balloons_interaction(from: Drag, with: Drag) -> void:
	$Balloons/AudioStreamPlayer.stop()
	var ClownBalloon = make_item("res://assets/ElinAssets/ClownBalloon.png")
	ClownBalloon.name = "ClownBalloon"
	ClownBalloon.global_position = with.global_position
	add_child(ClownBalloon)
	move_child(ClownBalloon, 1)
	from.queue_free()
	with.queue_free()


func _on_soap_interaction(from: Drag, with: Drag) -> void:
	$Soap/AudioStreamPlayer.stop()
	var ClownNoScary = make_item("res://assets/ElinAssets/ClownNoScary.png", false, [], [], false)
	ClownNoScary.name = "ClownNoScary"
	ClownNoScary.global_position = with.global_position
	add_child(ClownNoScary)
	move_child(ClownNoScary, 1)
	from.queue_free()
	with.queue_free()


func _on_shoe_interaction(from: Drag, with: Drag) -> void:
	$Shoe/AudioStreamPlayer.stop()
	$cute_spider/AudioStreamPlayer.stop()
	var CuteSpiderMush = make_item("res://assets/ElinAssets/CuteSpiderMush.png")
	CuteSpiderMush.global_position = with.global_position
	add_child(CuteSpiderMush)
	move_child(CuteSpiderMush, 1)
	from.queue_free()
	with.queue_free()


func _on_fart_interaction(_from: Drag, _with: Drag) -> void:
	$Fire/AudioStreamPlayer2.play()
	$Fire.fade_away()


func _on_bubble_clicked(node: Drag) -> void:
	print("TRIGGERED")
	node.fade_away()
