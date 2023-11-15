extends Control


const achievements = preload("res://resources/achievements.tres")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")
