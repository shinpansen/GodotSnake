class_name SnakeBase extends KinematicBody

const history_max_size: int = 100

var moving_speed: float = 10
var positions_history = []

var _tick_count: int = 0
var _tick_time: float = 1000/60

onready var _tick_start: int = OS.get_ticks_msec()

func _physics_process(delta):
	_tick_count = OS.get_ticks_msec() - _tick_start
	
	#Tick = adding new position history
	if _tick_count >= _tick_time:
		_tick_count = 0
		_tick_start = OS.get_ticks_msec()
		positions_history.push_front(transform)
		print(transform.basis)
	
	if positions_history.size() > history_max_size:
		positions_history.pop_at(history_max_size)

