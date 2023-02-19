class_name Ticker extends Node

var is_ticking: bool = false

var _tick_start: int
var _tick_count: int = 0
var _tick_time: float = 1000/60


func init(os, tick_time:float=1000/60):
	_tick_time = tick_time
	_tick_start = os.get_ticks_msec()


func update(os):
	is_ticking = false
	_tick_count = os.get_ticks_msec() - _tick_start

	if _tick_count >= _tick_time:
		is_ticking = true
		_tick_reset()


func _tick_reset():
	#Tick reset
	_tick_count = 0
	_tick_start = OS.get_ticks_msec()
