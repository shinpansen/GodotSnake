class_name PickupBase extends Area

export(float, 0, 10) var rotation_speed = 5

func _physics_process(delta):
	rotate(Vector3(0, 1, 0), delta * rotation_speed)


func _on_body_entered(body):
	if body.has_method("snake_add_new_body"):
		body.snake_add_new_body(transform.origin)
		queue_free()
