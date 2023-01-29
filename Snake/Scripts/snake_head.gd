class_name SnakeHead extends SnakeBase

export(float, 1, 50) var snake_speed = 10
export(float, 1, 10) var rotation_speed = 4
export(int, 0, 20) var nb_bodies = 5
export(float, 0, 20) var bodies_gap = 2

const tail_scene_name: String = "res://Snake/Scenes/snake_tail.tscn"
const body_scene_name: String = "res://Snake/Scenes/snake_body.tscn"

var _snake_tail: SnakeBody = null
var _bodies_list = []


func _ready():
	moving_speed = snake_speed


func _physics_process(delta):
	move_and_collide(transform.basis.z * moving_speed * delta)
	
	var input_h = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	if input_h != 0:
		rotate(Vector3.UP * input_h, rotation_speed * delta)
		
	#test
	if Input.is_action_just_pressed("ui_space"):
		snake_add_new_body(Vector3.ZERO, false)
	
	#Clearing positions history of the last body (because it is parent of nobody)
	if _bodies_list.size() > 0:
		pass#_bodies_list[_bodies_list.size()-1].positions_history.pop_at(0)
		
	if (_snake_tail != null and _bodies_list.size() > 0 and 
		_snake_tail.parent_body != _bodies_list[_bodies_list.size()-1] and
		_bodies_list[_bodies_list.size()-1].is_ready_to_follow()):
			_snake_tail.parent_body = _bodies_list[_bodies_list.size()-1]


func snake_add_new_body(pos: Vector3, play_animation: bool):
	var snake_body = get_new_body_scene()
	var parent = self if _bodies_list.size() < 1 else _bodies_list[_bodies_list.size()-1]
	snake_body.init(pos, parent, moving_speed, bodies_gap, play_animation, "")
	if _snake_tail == null:
		_snake_tail = snake_body
	else:
		_bodies_list.append(snake_body)
	get_tree().root.get_child(0).add_child(snake_body)


func get_new_body_scene():
	if _snake_tail == null:
		return preload(tail_scene_name).instance()
	return preload(body_scene_name).instance()
