extends ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.visible = true
