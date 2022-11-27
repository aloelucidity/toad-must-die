extends Label

func _physics_process(delta):
	var current_scene = get_parent().get_parent()
	text = "= " + str(current_scene.toads_killed) + "/" + str(current_scene.toads)
