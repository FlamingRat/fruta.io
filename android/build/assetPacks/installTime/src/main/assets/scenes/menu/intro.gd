extends Node2D


func open_menu():
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_click_mask_click_mask_pressed():
	open_menu()
