class_name SnakeHead extends SnakeBase

export(float, 1, 50) var snake_speed = 10
export(float, 1, 10) var rotation_speed = 4
export(int, 0, 20) var nb_bodies = 5
export(float, 0, 20) var bodies_gap = 2

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
		append_new_body()
	
	#Clearing the positions history of the last body (cos useless)
	if _bodies_list.size() > 0:
		_bodies_list[_bodies_list.size()-1].positions_history.pop_at(0)
	

func append_new_body():
	var snake_body = preload("res://Snake/Scenes/snake_body.tscn").instance()
	var parent = self if _bodies_list.size() == 0 else _bodies_list[_bodies_list.size()-1]
	snake_body.init_body(parent, moving_speed, bodies_gap, _bodies_list.size() + 1)
	_bodies_list.append(snake_body)
	get_tree().root.get_child(0).add_child(snake_body)
