extends Spatial

export var root_name = ""


func start_ik(start: bool):
	get_node(root_name).get_node("Skeleton").get_node("FrontSkeletonIK").start(start)
	get_node(root_name).get_node("Skeleton").get_node("BackSkeletonIK").start(start)


func rotate_bones(front_angle_deg: float, back_angle_deg: float):
	var angle_avg: float = (front_angle_deg -back_angle_deg)/2
	self.rotation_degrees = Vector3(0, 180 - angle_avg/4, 0) #Approximation
	$FrontPosition3D.rotation_degrees = Vector3(90, front_angle_deg, 0)
	$BackPosition3D.rotation_degrees = Vector3(-90, back_angle_deg, 0)
