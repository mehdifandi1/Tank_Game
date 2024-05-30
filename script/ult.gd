# ult.gd
extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if "Player" in body.name or "Player2" in body.name:
		queue_free()
