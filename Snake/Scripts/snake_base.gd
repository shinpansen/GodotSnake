class_name SnakeBase extends KinematicBody

const node_tools = preload("res://Scripts/Tools/node_tools.gd")
const vector_tools = preload("res://Scripts/Spatial/vector_tools.gd")
#const materials: Array = [
#	preload("res://Snake/Models/snake_skin.tres"),
#	preload("res://Snake/Models/snake_skin_transparent.tres"),
#]
const history_max_size: int = 100

var model: Spatial
var ticker: Ticker
var moving_speed: float = 10
var positions_history = []

onready var root = get_tree().root.get_child(0)


func _ready():
	model = get_node("Model")


func _init():
	ticker = Ticker.new()
	ticker.init(OS)


func _physics_process(delta):
	ticker.update(OS)

	if ticker.is_ticking:
		positions_history.push_front(self.transform)
	
	if positions_history.size() > history_max_size:
		positions_history.pop_at(history_max_size)
