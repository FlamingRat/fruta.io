extends Node2D
class_name LevelManager


const GAME_OVER_TIMEOUT = 5.0


signal score_changed(score: int)
signal game_over


var score: int = 0 : set = update_score
var fruit_counter: int = 0
var game_over_timer: float = 0


@onready var combine_audio: AudioStreamPlayer = $combine_audio


func _physics_process(delta):
	if fruit_counter > 0:
		game_over_timer += delta
	else:
		game_over_timer = 0
		
	if game_over_timer > GAME_OVER_TIMEOUT:
		game_over.emit()
		$ui_root/game_over_screen.visible = true


func update_score(new: int):
	score = new
	score_changed.emit(score)
	
	
func new_game():
	get_tree().reload_current_scene()


func _on_dispenser_fruit_dropped(level: int):
	score += int(pow(2, level))
	

func _on_fruit_combined(level: int):
	score += int(pow(2, level))
	combine_audio.play()


func _on_game_over_boundary_body_entered(body: Node2D):
	if body.is_in_group('fruit'):
		fruit_counter += 1


func _on_game_over_boundary_body_exited(body):
	if body.is_in_group('fruit'):
		fruit_counter -= 1


func _on_new_game_pressed():
	new_game()
