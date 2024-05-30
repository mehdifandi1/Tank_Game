# player2.gd
# player2.gd
extends KinematicBody2D

var movespeed = 500
var rotation_speed = 3
var bullet_speed = 2000
var bullet = preload("res://tscn/Bullet2.tscn")
var ult2 = preload("res://tscn/ult2.tscn")
signal health_changed(current_health)

const MAX_HEALTH = 25
var current_health: int = MAX_HEALTH
var can_use_ult = false  # Track if ult can be used

func _ready():
	pass

func _physics_process(delta):
	var motion = Vector2()
	
	if Input.is_action_pressed("down_2"):
		motion.x -= 1
	if Input.is_action_pressed("up_2"):
		motion.x += 1
	
	motion = motion.rotated(rotation).normalized()
	motion = move_and_slide(motion * movespeed)
	
	if Input.is_action_pressed("left_2"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("right_2"):
		rotation += rotation_speed * delta
	
	if Input.is_action_just_pressed("shooting_2"):
		fire_bullet()
	
	if Input.is_action_just_pressed("ult") and can_use_ult:
		fire_ult()
		can_use_ult = false  # Ult can only be used once

func fire_bullet():
	var bullet_instance = bullet.instance()
	bullet_instance.position = global_position
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.set_name("Bullet2")
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)

func fire_ult():
	var ult2_instance = ult2.instance()
	ult2_instance.position = global_position
	ult2_instance.rotation_degrees = rotation_degrees
	ult2_instance.set_name("ult2")
	ult2_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", ult2_instance)

func kill():
	get_tree().change_scene("res://tscn/GameOver.tscn")	

func _on_Area2D_body_entered(body):
	if "Bullet1" in body.name and current_health <= 1 or "ult1" in body.name:
		kill()
	elif "Bullet1" in body.name:
		current_health -= 1
		if current_health == 20:
			can_use_ult = true  # Allow ult when health is 20
		emit_signal("health_changed", current_health)
