class_name SnakeComponent
extends KinematicBody

export (PackedScene) var SnakeHead
export (PackedScene) var SnakeBody

var _bodies_list = []
var _positions_history = []
var _nb_bodies: int = 1
var _bodies_distance: float = 2.5
var _rotation_speed: float = 4
var _moving_speed: float = 10
var _tick_count: int = 0
var _tick_time: float = 1000/60

onready var _tick_start: int = OS.get_ticks_msec()
onready var _main_node: Spatial = get_tree().root.get_child(0)


func test_si_c_bien():
	print("est ce que le gdscript c'est pas si mal finalement ?")

func _ready():
	self.add_child(SnakeHead.instance())
	pass
	
func _physics_process(delta):
	#delta
	if Input.is_action_pressed("ui_down"):
		delta /= 4
	
	#Tick
	_tick_count = OS.get_ticks_msec() - _tick_start
	
	#Bodies init
	if _bodies_list.size() < _nb_bodies:
		for n in range(_bodies_list.size(), _nb_bodies):
			pass
#			_snake_body.SnakeHead = SnakeHead
#			_snake_body.transform.origin = Vector3(-1, 0, -1)
#			_main_node.add_child(_snake_body)
#			_bodies_list.append(SnakeBody.instance())
#			_main_node.add_child(_bodies_list[n])
	
	#Rotation
	var input_h = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	if input_h != 0:
		rotate(Vector3(0, input_h, 0).normalized(), _rotation_speed * delta)
	
	#Adding body
	if Input.is_action_just_pressed("ui_space"):
		_nb_bodies += 1
	
	#Tick
	if _tick_count >= _tick_time:
		_tick_count = 0
		_tick_start = OS.get_ticks_msec()
		_positions_history.push_front(transform)
		
	#Moving head
	move_and_collide(transform.basis.x * _moving_speed * delta)
	return
	#Moving bodies
	var index: int = 1
	for n in _bodies_list.size():
		var pos: Transform
		var pos_previous: Transform
		var dist: float = 0
		while (index < _positions_history.size() and dist < _bodies_distance):
			pos_previous = _positions_history[index-1]
			pos = _positions_history[index]
			dist += pos_previous.origin.distance_to(pos.origin)
			index += 1
		
		if dist > _bodies_distance:
			var dist_ratio: float = (dist - _bodies_distance) / abs(pos_previous.origin.distance_to(pos.origin))
			pos.origin = pos.origin.move_toward(pos_previous.origin, dist_ratio)
		
		var to_target = Vector3(pos.origin - _bodies_list[n].transform.origin)
		_bodies_list[n].transform = _bodies_list[n].transform.looking_at(pos.origin, Vector3.UP)
		_bodies_list[n].move_and_collide(to_target * _moving_speed * 1.5 * delta)
#		_bodies_list[n].transform.origin = pos.origin
#		_bodies_list[n].transform.basis = pos.basis
	
	#Clearing position history	
	_positions_history.pop_at(index)
