# HealthBar.gd
extends Node

func _ready():
	var player1 = $player
	var player2 = $player2
	
	player1.connect("health_changed", self, "_on_player1_health_changed")
	player2.connect("health_changed", self, "_on_player2_health_changed")

func _on_player1_health_changed(new_health):
	$HealthBarP1.value = new_health

func _on_player2_health_changed(new_health):
	$HealthBarP2.value = new_health




func _on_player_health_changed(current_health):
	if current_health == 0 :
		print("killed")
		get_tree().change_scene("res://tscn/GameOver.tscn")	
