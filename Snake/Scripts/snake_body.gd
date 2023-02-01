class_name SnakeBody extends SnakeBase

var parent_body: SnakeBase = null
var distance_to_parent: float = 2
var n: String = ""

var _start_position: Vector3
var _start_animation_finised: bool = false
var _stepping_back: bool = false
var _stepping_back_dist: float
var _stepping_back_init_pos: Vector3


func init(start_pos: Vector3, parent: SnakeBase, gap: float, play_animation, na):
	transform.origin = start_pos
	parent_body = parent
	distance_to_parent = gap
	_start_position = start_pos
	_start_animation_finised = !play_animation
	n = na


func is_ready_to_follow() -> bool:
#	var dist = transform.origin.distance_to(parent_body.transform.origin)
#	var dist_z = abs(transform.origin.z - parent_body.transform.origin.z)
#	return (
#		_start_animation_finised and 
#		dist_z < 1 and 
#		dist <= distance_to_parent * 2
#	)
	return _start_animation_finised


func step_back(dist: float):
	_stepping_back = true
	_stepping_back_dist = dist
	_stepping_back_init_pos = transform.origin


func _ready():
	pass


func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		delta /= 4
	
	if (!_start_animation_finised):
		_play_start_animation(delta)
	elif(_stepping_back):
		_play_stepping_back_animation(delta)
	elif parent_body != null:
		moving_speed = parent_body.moving_speed
		_move_toward_parent(delta)


func _play_start_animation(delta):
	if (abs(transform.origin.distance_to(_start_position)) < 4):
		rotate(Vector3(0, 1, 0), delta * 20)
		move_and_collide(Vector3(0, 1, 0) * 10 * delta)
		_start_animation_finised =  abs(transform.origin.distance_to(_start_position)) >= 4


func _play_stepping_back_animation(delta):
	var dist = transform.origin.distance_to(_stepping_back_init_pos)
	if dist < _stepping_back_dist / 1.5:
		move_and_collide(transform.basis.z * moving_speed / 1.5 * delta)
	else:
		_stepping_back = false


func _move_toward_parent(delta):
	var pos: Transform
	var pos_previous: Transform
	var dist: float = 0
	var i: int = 1
	while (i < parent_body.positions_history.size() and dist < distance_to_parent):
		pos_previous = parent_body.positions_history[i-1]
		pos = parent_body.positions_history[i]
		dist += pos_previous.origin.distance_to(pos.origin)
		i += 1
	
	if dist > distance_to_parent:
		var dist_ratio: float = (dist - distance_to_parent) / abs(pos_previous.origin.distance_to(pos.origin))
		pos.origin = pos.origin.move_toward(pos_previous.origin, dist_ratio)
	
	var to_target = Vector3(pos.origin - transform.origin)
	transform = transform.looking_at(pos.origin, Vector3.UP)
	move_and_collide(to_target * moving_speed * delta)
	
	#Clearing position history	
	parent_body.positions_history.pop_at(i)
