extends StaticBody2D

signal interaction(from: Node2D)

@export var draggable: bool:
	set(value):
		draggable = value
		if value:
			set_collision_layer_value(1, false)
		else:
			set_collision_layer_value(1, true)

@export var interact_with: String

@export var texture: Texture2D:
	set(value):
		%Sprite2D.texture = value
		var image = value.get_image()
		var bitmap = BitMap.new()
		bitmap.create_from_image_alpha(image)
		var polys = bitmap.opaque_to_polygons(
			Rect2(
				Vector2.ZERO,
				value.get_size()
			),
			1
		)
		for poly in polys:
			var collision_polygon = CollisionPolygon2D.new()
			collision_polygon.polygon = poly
			# Generated polygon will not take into account the half-width and half-height offset
			# of the image when "centered" is on. So move it backwards by this amount so it lines up.
			if %Sprite2D.centered:
				collision_polygon.position -= Vector2(bitmap.get_size()/2)
			
			add_child(collision_polygon)
			%Area2D.add_child(collision_polygon.duplicate())


@export var sounds: Array[AudioStream]= []


var is_grabbed: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_grabbed:
		global_position = get_global_mouse_position()


func fade_away():
	%AnimationPlayer.play("fade_out")
	await %AnimationPlayer.animation_finished
	queue_free()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if not %AudioStreamPlayer.playing and event.is_pressed():
					%AudioStreamPlayer.stream = sounds.pick_random()
					%AudioStreamPlayer.play()
				if event.is_pressed() and draggable:
					is_grabbed = true
					scale = Vector2(1.2, 1.2)
				else:
					is_grabbed = false
					scale = Vector2(1, 1)
			MOUSE_BUTTON_WHEEL_UP:
				if is_grabbed:
					rotate(0.1)
			MOUSE_BUTTON_WHEEL_DOWN:
				if is_grabbed:
					rotate(-0.1)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == interact_with:
		interaction.emit(self)
