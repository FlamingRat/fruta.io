extends Control


var play_games_services


func _ready():
	print('ready')
	if Engine.has_singleton("GodotPlayGamesServices"):
		print("GPGS ok")
		play_games_services = Engine.get_singleton("GodotPlayGamesServices")

		play_games_services.init(true, false, false, "")
		
		play_games_services.connect(
			"_on_sign_in_success", _on_sign_in_success
		)
		
		var error = play_games_services.signIn()
		print(error)


func _on_sign_in_success(acc_data):
	print(acc_data)


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")
