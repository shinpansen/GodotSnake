class_name SnakeHead extends SnakeBase

export(float, 1, 50) var snake_speed = 10
export(float, 1, 10) var rotation_speed = 4
export(int, 0, 20) var nb_bodies = 5
export(float, 0, 20) var bodies_gap = 2

const parts_scenes: Array = [
	preload("res://Snake/Scenes/snake_tail.tscn"),
	preload("res://Snake/Scenes/snake_body.tscn"),
]

var _snake_tail: SnakeBody = null
var _bodies_list = []


func _ready():
	moving_speed = snake_speed


func _physics_process(delta):
	
	if Input.is_action_pressed("ui_down"):
		delta /= 4
	
	move_and_collide(transform.basis.z * moving_speed * delta)
	
	var input_h = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	if input_h != 0:
		rotate(Vector3.UP * input_h, rotation_speed * delta)
		
	#test
	if Input.is_action_just_pressed("ui_space"):
		snake_add_new_body(Vector3.ZERO)


func snake_add_new_body(pos: Vector3):
	if _snake_tail == null:
		_snake_tail = get_new_body(pos, true, true, false)
		get_root().add_child(_snake_tail)
	else:
		var tra = get_last_body().transform
		var snake_body = get_new_body(tra.origin + tra.basis.z * 3, false, false, true)
		var temp_body = get_new_body(pos, true, false, false)
		snake_body.temp_body = temp_body
		_bodies_list.append(snake_body)
		_snake_tail.parent_body = snake_body
		_snake_tail.step_back(bodies_gap)
		get_root().add_child(snake_body)
		get_root().add_child(temp_body)


func get_new_body(pos: Vector3, animation: bool, tail: bool, transparent: bool) -> Node:
	var scene = parts_scenes[0].instance() if tail else parts_scenes[1].instance()
	var material = materials[1] if transparent else materials[0]
	util.get_node_type(scene.get_children(), MeshInstance).set_surface_material(0, material)
	scene.init(pos, get_last_body(), bodies_gap, animation, "")
	return scene

func get_last_body() -> SnakeBody:
	return _bodies_list[_bodies_list.size()-1] if _bodies_list.size() else self
