class_name SnakeBody extends SnakeBase

var parent_body: SnakeBase = null
var distance_to_parent: float = 2
var _start_position: Vector3
var _start_animation_finised: bool = false


func init(start_pos: Vector3, parent: SnakeBase, speed: float, gap: float, n):
	transform.origin = start_pos
	_start_position = start_pos
	parent_body = parent
	moving_speed = speed
	distance_to_parent = gap
	num = n


func _ready():
	pass


func _physics_process(delta):
	if (!_start_animation_finised and abs(transform.origin.distance_to(_start_position)) < 4):
		rotate(Vector3(0, 1, 0), delta * 20)
		move_and_collide(Vector3(0, 1, 0) * 10 * delta)
		if abs(transform.origin.distance_to(_start_position)) >= 4:
			_start_animation_finised = true
		return
	
	if parent_body != null:
		_move_toward_parent(delta)


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
