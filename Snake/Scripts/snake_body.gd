class_name SnakeBody extends SnakeBase

var parent_body: SnakeBase = null
var temp_body: SnakeBase = null
var distance_to_parent: float = 2

var _model: Spatial
var _start_position: Vector3
var _start_animation_finised: bool = false
var _stepping_back: bool = false
var _stepping_back_dist: float
var _stepping_back_init_pos: Vector3


func init(start_pos: Vector3, parent: SnakeBase, gap: float, play_animation):
	transform.origin = start_pos
	parent_body = parent
	distance_to_parent = gap
	_start_position = start_pos
	_start_animation_finised = !play_animation


func has_finished_animation(pos: Vector3) -> bool:
	var dist = transform.origin.distance_to(pos)
	return _start_animation_finised and dist < 0.1


func step_back(dist: float):
	_stepping_back = true
	_stepping_back_dist = dist
	_stepping_back_init_pos = transform.origin


func _ready():
	_model = get_node("Model")


func _physics_process(delta):
	# TEST SLOW MO
	if Input.is_action_pressed("ui_down"):
		delta /= 4
	
	_handle_temp_body()
	
	if !_start_animation_finised:
		_play_start_animation(delta)
	elif _stepping_back:
		_play_stepping_back_animation(delta)
	elif parent_body != null:
		moving_speed = parent_body.moving_speed
		_move_toward_parent(delta)


func _play_start_animation(delta):
	if abs(transform.origin.distance_to(_start_position)) < 4:
		rotate(Vector3(0, 1, 0), delta * 20)
		move_and_collide(Vector3(0, 1, 0) * 10 * delta)
		_start_animation_finised =  abs(transform.origin.distance_to(_start_position)) >= 4


func _play_stepping_back_animation(delta):
	var dist = transform.origin.distance_to(_stepping_back_init_pos)
	if dist < _stepping_back_dist:
		move_and_collide(transform.basis.z * moving_speed * delta)
	else:
		_stepping_back = false


func _move_toward_parent(delta):
	var tr: Transform
	var tr_previous: Transform
	var tr_test: Transform
	var tr_previous_test: Transform
	var tr_skeleton_front: Transform
	var tr_skeleton_back: Transform
	var dist: float = 0
	var i: int = 1
	
	while i < parent_body.positions_history.size() and dist < distance_to_parent + distance_to_parent/2:
		tr_previous_test = parent_body.positions_history[i-1]
		tr_test = parent_body.positions_history[i]
		dist += tr_previous_test.origin.distance_to(tr_test.origin)
		if dist >= distance_to_parent and tr == Transform.IDENTITY:
			tr = tr_test
			tr_previous = tr_previous_test
		if dist >= distance_to_parent/2 and tr_skeleton_front == Transform.IDENTITY:
			tr_skeleton_front = tr_test
		if dist >= distance_to_parent + distance_to_parent/2 and tr_skeleton_back == Transform.IDENTITY:
			tr_skeleton_back = tr_test
		i += 1
	
	if dist > distance_to_parent:
		var dist_ratio: float = (dist - distance_to_parent) / abs(tr_previous.origin.distance_to(tr.origin))
		tr.origin = tr.origin.move_toward(tr_previous.origin, dist_ratio)
	
#	var look_at_vector = Vector3(pos.origin.x, transform.origin.y, pos.origin.z)
#	transform = transform.looking_at(look_at_vector, Vector3.UP)
	var to_target = Vector3(tr.origin - transform.origin)
	move_and_collide(to_target * moving_speed * delta)
	look_at(tr.origin, Vector3.UP)
	
	if _model.has_method("rotate_bones"):
		var angle_skeleton_front = get_skeleton_bone_angle(tr,  tr_skeleton_front)
		var angle_skeleton_back = get_skeleton_bone_angle(tr,  tr_skeleton_back)
		_model.rotate_bones(angle_skeleton_front, angle_skeleton_back)
		_model.start_ik(true)
	
	#Clearing position history	
	parent_body.positions_history.pop_at(i)


func _handle_temp_body(): 
	if temp_body != null and temp_body.has_finished_animation(transform.origin):
		var mesh = node_tools.get_node_type(get_children(), MeshInstance)
#		mesh.set_surface_material(0, materials[0])
		_model.visible = true
		temp_body.queue_free()
		temp_body = null


func get_skeleton_bone_angle(transform_a: Transform, transform_b: Transform) -> float:
	var angle = rad2deg(transform_a.basis.z.signed_angle_to(transform_b.basis.z, Vector3.UP))
	return angle
