class_name SnakeBase extends KinematicBody

const history_max_size: int = 100

var moving_speed: float = 10
var positions_history = []
var raycast: RayCast = null

var _tick_count: int = 0
var _tick_time: float = 1000/60

onready var _tick_start: int = OS.get_ticks_msec()


func _ready():
	pass


func _physics_process(delta):
	_tick_count = OS.get_ticks_msec() - _tick_start
	
	if raycast == null:
		for child in get_children():
			if child is RayCast:
				raycast = child
				break
	
	#Tick = adding new position history
	if _tick_count >= _tick_time:
		_tick_count = 0
		_tick_start = OS.get_ticks_msec()
		if raycast != null and raycast.is_colliding():
			positions_history.push_front(Transform(transform.basis, raycast.get_collision_point()))
		#positions_history.push_front(transform)
#		var ds = get_world().direct_space_state
#		var collision = ds.intersect_ray(
#			global_transform.origin, 
#			Vector3(0, -10, 0),#transform.origin - Vector3(0, 50, 0),
#			[self, KinematicBody],
#			3,
#			false,
#			true)
#		if collision:
#			print("collide")
#			positions_history.push_front(Transform(transform.basis, collision.position))
	
	if positions_history.size() > history_max_size:
		positions_history.pop_at(history_max_size)

