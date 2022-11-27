extends AudioStreamPlayer

export(Array, AudioStream) var sounds

func play_random():
	stream = sounds[randi() % sounds.size()]
	play()
