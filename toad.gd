extends KinematicBody2D

onready var toad = $AnimatedSprite
onready var ray = $RayCast2D

var direction : int = 1
var velocity : Vector2
export var gravity : float
export var speed : float


func _ready():
	get_parent().toads += 1

func stop():
	speed = 0

func die():
	$Area2D.queue_free()
	get_parent().toads_killed += 1
	if get_parent().toads == get_parent().toads_killed:
		scorekeeper.text = get_parent().get_node("%TIME").text
		get_tree().change_scene("res://score.tscn")
	$AnimationPlayer.play("die")

func is_grounded():
	return test_move(global_transform, Vector2(0, 0.1))

func _physics_process(delta):
	velocity.x = direction * speed
	velocity.y += gravity
	velocity = move_and_slide(velocity)
	
	if test_move(global_transform, Vector2(0.1 * direction, 0)):
		direction = -direction
	if !ray.is_colliding():
		direction = -direction
	ray.position.x = 12 * direction
	
	toad.flip_h = (direction == 1)
