extends Control


const achievements = preload("res://resources/achievements.tres")


func _process(_delta):
	$CanvasLayer/Control/vbox/leaderboards_container.visible = \
		achievements.is_ready()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")


func _on_leaderboards_pressed():
	achievements.view_leaderboard(AchievementManager.LEADERBOARD_HIGH_SCORES)
