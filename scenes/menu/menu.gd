extends Control


func _process(_delta):
	$CanvasLayer/Control/vbox/leaderboards_container.visible = \
		Achievements.is_ready()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")


func _on_leaderboards_pressed():
	Achievements.view_leaderboard(Achievements.LEADERBOARD_HIGH_SCORES)
