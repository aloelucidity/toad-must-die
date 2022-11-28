extends Node2D

func _ready():
	$AnimationPlayer.play("anim")

func start_game():
	get_tree().change_scene("res://LEVEL1.tscn")
