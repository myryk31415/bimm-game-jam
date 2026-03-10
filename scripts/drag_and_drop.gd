extends Control

var is_being_dragged := false
var drag_offset := Vector2.ZERO
var rotation_speed := 0.05
var just_started := false
var just_ended := false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent) -> void:
	if just_ended:
		just_ended = false
		return
	if not is_being_dragged:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_start_drag()
			just_started = true
	else:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			get_parent().rotation -= rotation_speed
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			get_parent().rotation += rotation_speed

func _input(event: InputEvent) -> void:
	if not is_being_dragged:
		return
	if just_started:
		just_started = false
		return
	if event is InputEventMouseMotion:
		get_parent().global_position = get_global_mouse_position() - drag_offset
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_end_drag()
		just_ended = true

func _start_drag() -> void:
	if _in_hell:
		return
	is_being_dragged = true
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(get_parent(), "scale", Vector2.ONE * 1.2, 0.15)
	get_parent().freeze = true
	get_parent().linear_velocity = Vector2.ZERO
	get_parent().angular_velocity = 0.0
	drag_offset = get_global_mouse_position() - get_parent().global_position
	mouse_default_cursor_shape = Control.CURSOR_DRAG

func _end_drag() -> void:
	is_being_dragged = false
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	get_parent().freeze = false
	tween.tween_property(get_parent(), "scale", Vector2.ONE, 0.15)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_mouse_button_down() -> void:
	if not is_being_dragged:
		_start_drag()

var _in_hell := false
func enter_hell() -> void:
	if not _in_hell:
		_in_hell = true
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		get_parent().gravity_scale = 1.0
func exit_hell() -> void:
	if _in_hell:
		_in_hell = false
		get_parent().gravity_scale = 0.0
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
