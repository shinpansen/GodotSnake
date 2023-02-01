extends Node


static func get_node_type(array, type) -> Node:
	for child in array:
		if child is type:
			return child
	return null
