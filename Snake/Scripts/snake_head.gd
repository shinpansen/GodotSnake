class_name SnakeHead extends SnakeBase

export(float, 1, 50) var snake_speed = 10
export(float, 1, 10) var rotation_speed = 4
export(float, 1, 10) var head_tilt_speed = 2
export(float, 1, 50) var max_tilt = 10
export(float, 0, 20) var bodies_gap = 2
export(int, 0, 20) var nb_bodies = 2

const parts_scenes: Array = [
	preload("res://Snake/Scenes/snake_tail.tscn"),
	preload("res://Snake/Scenes/snake_body_first.tscn"),
	preload("res://Snake/Scenes/snake_body.tscn"),
]

var _snake_tail: SnakeBody = null
var _bodies_list = []


func add_new_body(pos: Vector3, anim: bool = true):
	if _snake_tail == null:
		_snake_tail = _get_new_body(pos, anim, true)
		root.add_child(_snake_tail)
	else:
		var tra = _get_last_body().transform
		var snake_body = _get_new_body(tra.origin + tra.basis.z * 3 if anim else pos, false, !anim)
		_snake_tail.parent_body = snake_body
		_snake_tail.step_back(bodies_gap)
		if anim:
			var temp_body = _get_new_body(pos, true, true)
			snake_body.temp_body = temp_body
			root.add_child(temp_body)
		_bodies_list.append(snake_body)
		root.add_child(snake_body)


func _ready():
	moving_speed = snake_speed


func _physics_process(delta):
	# TEST SLOW MO
	if Input.is_action_pressed("ui_down"):
		delta /= 4
	if Input.is_action_pressed("ui_down"):
		delta /= 4
	if Input.is_action_just_pressed("ui_space"):
		add_new_body(Vector3.ZERO)
		
	_init_snake()
	_handle_inputs(delta)
	move_and_collide(transform.basis.z * moving_speed * delta)


func _init_snake():
	if _snake_tail != null:
		return
	add_new_body(transform.origin - transform.basis.z * bodies_gap * (nb_bodies+1), false) #Tail
	for i in range(0, nb_bodies):
		add_new_body(transform.origin - transform.basis.z * bodies_gap * (i+1), false)


func _handle_inputs(delta):
	var input_h = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	if input_h != 0:
		rotate(Vector3.UP * input_h, rotation_speed * delta)
		_tilt_head(-input_h * max_tilt)
	else:
		_tilt_head(0)


func _tilt_head(value: float):
	if !ticker.is_ticking:
		return
	#TODO - améliorer ce code
	var rot = model.rotation_degrees
	if rot[2] < value and value > 0:
		model.rotation_degrees = Vector3(rot[0], rot[1], rot[2] + head_tilt_speed)
	elif rot[2] > value and value < 0:
		model.rotation_degrees = Vector3(rot[0], rot[1], rot[2] - head_tilt_speed)
	elif rot[2] > value and value == 0:
		model.rotation_degrees = Vector3(rot[0], rot[1], rot[2] - head_tilt_speed)
	elif rot[2] < value and value == 0:
		model.rotation_degrees = Vector3(rot[0], rot[1], rot[2] + head_tilt_speed)


func _get_new_body(pos: Vector3, animation: bool, visible: bool) -> Node:
	var scene = parts_scenes[_get_new_body_scene_id()].instance()
	scene.get_node("Model").visible = visible
	scene.init(pos, _get_last_body(), bodies_gap, animation)
	return scene


func _get_last_body() -> SnakeBody:
	return _bodies_list[_bodies_list.size()-1] if _bodies_list.size() else self


func _get_new_body_scene_id() -> int:
	if _snake_tail != null:
		return 2 if _bodies_list.size() == 0 else 2
	return 0
