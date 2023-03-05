extends Node


static func get_projection_distance(transformA: Transform, transformB: Transform) -> Vector2:
	var dist: float = transformA.origin.distance_to(transformB.origin)
	var vectARot = transformA.basis.z.rotated(Vector3(0, 1, 0), deg2rad(180))
	var vectBRot = transformB.basis.z.rotated(Vector3(0, 1, 0), deg2rad(180))
	var projectionA: Vector3 = transformA.origin + (vectARot.normalized() * dist)
	var projectionB: Vector3 = transformA.origin + (vectBRot.normalized() * dist)
	var angle_rad = transformA.basis.z.angle_to(transformB.basis.z)
	return Vector2(transformB.origin.distance_to(projectionA)*2, angle_rad)


#Return true is vect_a == vect_b within rounding precision (ex : 0.01)
static func compare_vector3(vect_a: Vector3, vect_b: Vector3, precision: float) -> bool:
	if (stepify(vect_a.x, precision) == stepify(vect_b.x, precision) and
		stepify(vect_a.y, precision) == stepify(vect_b.y, precision) and
		stepify(vect_a.z, precision) == stepify(vect_b.z, precision)):
		return true
	return false
