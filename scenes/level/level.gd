extends Node2D
class_name LevelManager


const GAME_OVER_TIMEOUT = 7.0
const GAME_OVER_WARNING = 3.0
const GAME_OVER_BOUNDARY_TIMER = 1.0
const HIGH_SCORE_FILE = "user://highscores.save"
const COMBO_TIMEOUT_SECONDS = 1


signal score_changed(score: int)
signal high_score_updated(score: int)
signal game_over


var score: int = 0 : set = update_score
var fruit_counter: int = 0
var game_over_timer: float = 0
var is_game_over = false
var high_score: int = 0
var combo_counter: int = 0
var combo_timeout: float = 0


@onready var combine_audio: AudioStreamPlayer = $combine_audio
@onready var high_score_label: Label = $ui_root/top_bar/high_score
@onready var game_over_timer_label: Label = $ui_root/main_ui/game_over_timer


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


func set_game_over_boundary_visible(value: bool):
	var tween = create_tween()
	tween.tween_property(
		$game_over_boundary/sprite,
		'modulate',
		Color(1, 1, 1, 1 if value else 0),
		0.5,
	)


func game_over_countdown(delta: float):
	game_over_timer += delta
	
	if game_over_timer > GAME_OVER_BOUNDARY_TIMER:
		set_game_over_boundary_visible(true)

	if game_over_timer > GAME_OVER_WARNING and !is_game_over:
		var time = str(floor(GAME_OVER_TIMEOUT - game_over_timer))
		game_over_timer_label.set_text(time)


func reset_game_over_countdown():
	game_over_timer = 0
	game_over_timer_label.set_text('')

	set_game_over_boundary_visible(false)
	
	
func declare_game_over():
	is_game_over = true
	$ui_root/game_over_screen.visible = true
	game_over.emit()


func _physics_process(delta: float):
	if fruit_counter > 0 and !is_game_over:
		game_over_countdown(delta)

		if game_over_timer > GAME_OVER_TIMEOUT:
			declare_game_over()
	else:
		reset_game_over_countdown()
		
	if combo_timeout >= 0:
		combo_timeout -= delta
	else:
		combo_counter = 0


func update_score(new: int):
	score = new
	score_changed.emit(score)
	
	if score > high_score:
		update_high_score(score)


func _on_dispenser_fruit_dropped(level: int):
	if is_game_over:
		return

	score += int(pow(2, level))
	

func _on_fruit_combined(level: int):
	if is_game_over:
		return

	score += int(pow(2, level))
	combo_timeout = COMBO_TIMEOUT_SECONDS
	combo_counter += 1
	combine_audio.pitch_scale = 0.9 + 0.1 * combo_counter
	combine_audio.play()


func _on_game_over_boundary_body_entered(body: Node2D):
	if body.is_in_group('fruit'):
		fruit_counter += 1


func _on_game_over_boundary_body_exited(body):
	if body.is_in_group('fruit'):
		fruit_counter -= 1


func _on_new_game_pressed():
	get_tree().reload_current_scene()
