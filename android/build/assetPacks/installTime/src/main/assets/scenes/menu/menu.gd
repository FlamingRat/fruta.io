extends Control


var play_games_services


func _ready():
	if Engine.has_singleton("GodotPlayGamesServices"):
		play_games_services = Engine.get_singleton("GodotPlayGamesServices")

		play_games_services.init(true, false, false, "")
		
		play_games_services.connect(
			"_on_sign_in_success", _on_sign_in_success
		)
		
		play_games_services.connect(
			"_on_sign_in_failed", _on_sign_in_failed
		)
		
		play_games_services.signIn()


func _on_sign_in_success(acc_data):
	print(acc_data)


func _on_sign_in_failed(info):
	print(info)


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")
