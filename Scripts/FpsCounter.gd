extends Label

func _process(delta):
	set_text("FPS " + String(Engine.get_frames_per_second()))
