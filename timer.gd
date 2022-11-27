extends Label

var seconds : float

func _physics_process(delta):
	seconds += delta
	text = str(stepify(seconds, 0.01)).pad_decimals(2).pad_zeros(2)
