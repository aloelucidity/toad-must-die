extends KinematicBody2D

onready var rot = $Rot
onready var sprites = $Sprites
onready var gun = $Sprites/Gun
onready var flash = $Sprites/Gun/Flash
onready var mario = $Sprites/AnimatedSprite
onready var ray = $Sprites/Gun/RayCast2D
onready var sound = $Sprites/Gun/Sound
onready var camera = $Camera2D
var flipped

var velocity : Vector2
export var gravity : float
export var accel : float
export var speed : float
export var jump_power : float
export var recoil : float

var shoot_cooldown : float

func is_grounded():
	return test_move(global_transform, Vector2(0, 0.1))

func _physics_process(delta):
	if !is_instance_valid(gun): return
	
	if shoot_cooldown > 0:
		shoot_cooldown -= delta
	rot.look_at(get_global_mouse_position())
	rot.rotation_degrees = wrapf(rot.rotation_degrees, 0, 360)
	flipped = (rot.rotation_degrees < 270 and rot.rotation_degrees > 90)
	sprites.scale.x = -1 if flipped else 1
	gun.rotation_degrees = clamp(wrapf(rot.rotation_degrees, 90, -90), -45, 45)
	if flipped:
		gun.rotation_degrees = -gun.rotation_degrees
	
	var move_direction = 0
	if Input.is_action_pressed("move_left"):
		move_direction -= 1
	if Input.is_action_pressed("move_right"):
		move_direction += 1
	if Input.is_action_pressed("jump") && is_grounded():
		velocity.y = -jump_power
	if Input.is_action_pressed("shoot") && shoot_cooldown <= 0:
		if ray.is_colliding():
			if ray.get_collider().get_collision_layer_bit(1) == true:
				ray.get_collider().get_parent().die()
		
		sound.play()
		shoot_cooldown = 0.2
		gun.offset.x = 3
		flash.modulate.a = 1
		camera.zoom = Vector2(0.95, 0.95)
		camera.rotation_degrees = rand_range(-3, 3)
		var recoil_vel = Vector2(-recoil if flipped else recoil, 0).rotated(gun.rotation)
		recoil_vel.y *= -1 if flipped else 1
		velocity -= recoil_vel
	gun.offset.x = lerp(gun.offset.x, 6, delta * 3)
	flash.modulate.a = lerp(flash.modulate.a, 0, delta * 12)
	camera.zoom = camera.zoom.move_toward(Vector2(1, 1), delta / 10)
	camera.rotation_degrees = lerp(camera.rotation_degrees, 0, delta * 3)
	
	velocity.x = lerp(velocity.x, move_direction * speed, delta * accel)
	velocity.y += gravity
	velocity = move_and_slide(velocity)
	
	mario.speed_scale = abs(velocity.x) / speed
	if !is_grounded():
		mario.speed_scale = 0
		mario.frame = 0
	if is_grounded() && abs(velocity.x) < 5:
		mario.speed_scale = 0
		mario.frame = 2
