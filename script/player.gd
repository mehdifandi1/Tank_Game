# player.gd
extends KinematicBody2D

var movespeed = 500
var rotation_speed = 3
var bullet_speed = 2000
var bullet = preload("res://tscn/Bullet.tscn")
var ult = preload("res://tscn/ult.tscn")
signal health_changed(current_health)

const MAX_HEALTH = 25
var current_health: int = MAX_HEALTH
var can_use_ult = false  # Track if ult can be used

func _ready():
	pass

func _physics_process(delta):
	var motion = Vector2()
	
	if Input.is_action_pressed("down"):
		motion.x -= 1
	if Input.is_action_pressed("up"):
		motion.x += 1
	
	motion = motion.rotated(rotation).normalized()
	motion = move_and_slide(motion * movespeed)
	
	if Input.is_action_pressed("left"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("right"):
		rotation += rotation_speed * delta
	
	if Input.is_action_just_pressed("shoot"):
		fire_bullet()
	
	if Input.is_action_just_pressed("ult_2") and can_use_ult:
		fire_ult()
		can_use_ult = false  # Ult can only be used once

func fire_bullet():
	var bullet_instance = bullet.instance()
	bullet_instance.position = global_position
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.set_name("Bullet1")
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", bullet_instance)

func fire_ult():
	var ult_instance = ult.instance()
	ult_instance.position = global_position
	ult_instance.rotation_degrees = rotation_degrees
	ult_instance.set_name("ult1")
	ult_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child", ult_instance)

func kill():
	get_tree().change_scene("res://tscn/GameOver.tscn")		

func _on_Area2D_body_entered(body):
	if "Bullet2" in body.name and current_health <= 1 or "ult2" in body.name:
		kill()
	elif "Bullet2" in body.name:
		current_health -= 1
		if current_health == 20:
			can_use_ult = true  # Allow ult when health is 20
		emit_signal("health_changed", current_health)
