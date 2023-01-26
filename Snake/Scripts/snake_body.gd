class_name SnakeBody extends SnakeBase

var parent_body: SnakeBase = null
var distance_to_parent: float = 2


func init_body(parent: SnakeBase, speed: float, gap: float, n):
	parent_body = parent
	moving_speed = speed
	distance_to_parent = gap
	num = n
	

func _ready():
	pass


func _physics_process(delta):
	if parent_body == null:
		return
	
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


