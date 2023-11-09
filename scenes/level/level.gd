extends Node2D
class_name LevelManager


const GAME_OVER_TIMEOUT = 5.0
const HIGH_SCORE_FILE = "user://highscores.save"


signal score_changed(score: int)
signal high_score_updated(score: int)
signal game_over


var score: int = 0 : set = update_score
var fruit_counter: int = 0
var game_over_timer: float = 0
var is_game_over = false
var high_score: int = 0


@onready var combine_audio: AudioStreamPlayer = $combine_audio
@onready var high_score_label: Label = $ui_root/top_bar/high_score


func update_high_score(new_score: int):	
	var fd = FileAccess.open(HIGH_SCORE_FILE, FileAccess.WRITE)
	
	fd.store_var({'high_score': new_score}, true)
	fd.close()
	
	high_score = new_score
	high_score_updated.emit(new_score)


func _ready():
	if FileAccess.file_exists(HIGH_SCORE_FILE):
		var fd = FileAccess.open(HIGH_SCORE_FILE, FileAccess.READ)
		var data = fd.get_var(true)

		if 'high_score' in data:
			update_high_score(data['high_score'])


func _physics_process(delta):
	if fruit_counter > 0:
		game_over_timer += delta
	else:
		game_over_timer = 0
		
	if game_over_timer > GAME_OVER_TIMEOUT:
		game_over.emit()
		is_game_over = true
		$ui_root/game_over_screen.visible = true


func update_score(new: int):
	score = new
	score_changed.emit(score)
	
	if score > high_score:
		update_high_score(score)
	
	
func new_game():
	get_tree().reload_current_scene()


func _on_dispenser_fruit_dropped(level: int):
	if is_game_over:
		return

	score += int(pow(2, level))
	

func _on_fruit_combined(level: int):
	if is_game_over:
		return

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
