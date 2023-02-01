class_name SnakeBase extends KinematicBody

const util = preload("res://Scripts/util.gd")
const history_max_size: int = 100

var moving_speed: float = 10
var positions_history = []

var _tick_count: int = 0
var _tick_time: float = 1000/60

onready var _raycast: RayCast = util.get_node_type(get_children(), RayCast)
onready var _tick_start: int = OS.get_ticks_msec()


func _physics_process(delta):
	_tick_count = OS.get_ticks_msec() - _tick_start

	if _tick_count >= _tick_time:
		_tick_process(delta)
	
	if positions_history.size() > history_max_size:
		positions_history.pop_at(history_max_size)


func _tick_process(delta):
	#Tick reset
	_tick_count = 0
	_tick_start = OS.get_ticks_msec()
	
	#Position history
	var tra = transform
	if _raycast and _raycast.is_colliding():
		tra = Transform(transform.basis, _raycast.get_collision_point())
	positions_history.push_front(tra)
