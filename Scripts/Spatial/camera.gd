extends Camera

const node_tools = preload("res://Scripts/Tools/node_tools.gd")

var _base_origin: Vector3

onready var _root = get_tree().root.get_child(0)
onready var _snake_ref = _root.get_node("Snake")

func _ready():
	_base_origin = transform.origin - _snake_ref.transform.origin
	

func _process(delta):
	transform.origin = _snake_ref.transform.origin + _base_origin
