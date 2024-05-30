extends Control

func _on_Play_pressed():
	get_tree().change_scene("res://tscn/Node2D.tscn")


func _on_Options_pressed():
	get_tree().change_scene("res://tscn/howtoplay.tscn")	

func _on_Exit_pressed():
	get_tree().quit()
