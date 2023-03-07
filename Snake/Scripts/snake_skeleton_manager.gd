extends Spatial

export var root_name = ""


func start_ik(start: bool):
	get_node(root_name).get_node("Skeleton").get_node("FrontSkeletonIK").start(start)
	get_node(root_name).get_node("Skeleton").get_node("BackSkeletonIK").start(start)


func rotate_front_bone(angle_deg: float, delta: float):
	var rot_y = $FrontPosition3D.rotation_degrees[1]
	$FrontPosition3D.rotation_degrees = Vector3(90, lerp(rot_y, angle_deg, 10*delta), 0)
	rot_y = self.rotation_degrees[1]
	var lerp_rot_y = lerp(rot_y, 180 - angle_deg/2, 10*delta)
	self.rotation_degrees = Vector3(0, lerp_rot_y, 0) #Approximation
	
	
func rotate_back_bone(angle_deg: float, delta: float):
	var rot_y = $BackPosition3D.rotation_degrees[1]
	$BackPosition3D.rotation_degrees = Vector3(-90, lerp(rot_y, angle_deg, 10*delta), 0)
