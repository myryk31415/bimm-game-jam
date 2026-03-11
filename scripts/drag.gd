extends StaticBody2D

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
			add_child(collision_polygon)

			# Generated polygon will not take into account the half-width and half-height offset
			# of the image when "centered" is on. So move it backwards by this amount so it lines up.
			if %Sprite2D.centered:
				collision_polygon.position -= Vector2(bitmap.get_size()/2)

var is_grabbed: bool = false
var mouse_start_pos
var item_start_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_grabbed:
		var mouse_pos = get_global_mouse_position()
		global_position = mouse_pos - mouse_start_pos + item_start_pos

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if not event.is_pressed():
			#is_grabbed = false

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			is_grabbed = true
			scale = Vector2(1.2, 1.2)
			mouse_start_pos = get_global_mouse_position()
			item_start_pos = global_position
		else:
			is_grabbed = false
			scale = Vector2(1, 1)
