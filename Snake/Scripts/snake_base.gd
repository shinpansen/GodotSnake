class_name SnakeBase extends KinematicBody

const history_max_size = 100

var num = 0
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
		#print(str(num) + " : " + str(positions_history.size()))
	
	if positions_history.size() > 100:
		positions_history.pop_at(100)
