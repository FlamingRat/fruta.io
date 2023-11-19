extends Node2D
class_name LevelManager


const achievements = preload("res://resources/achievements.tres")
const SCORE_VERSION = '23.11.13.1'
const GAME_OVER_TIMEOUT = 7.0
const GAME_OVER_WARNING = 3.0
const GAME_OVER_BOUNDARY_TIMER = 1.0
const HIGH_SCORE_FILE = "user://highscores.save"


signal score_changed(score: int)
signal high_score_updated(score: int)
signal game_over
signal combo_progress(combo_counter: int)
signal combo_reset


var score: int = 0 : set = update_score
var fruit_counter: int = 0
var combo_counter: int = 0
var game_over_timer: float = 0
var is_game_over = false
var high_score: int = 0


@onready var game_over_timer_label: Label = $ui_root/main_ui/game_over_timer


func update_high_score(new_score: int):
	var fd = FileAccess.open(HIGH_SCORE_FILE, FileAccess.WRITE)
	
	fd.store_var({
		'high_score': new_score,
		'version': SCORE_VERSION,
	}, true)
	fd.close()
	
	high_score = new_score
	high_score_updated.emit(new_score)


func _ready():
	if FileAccess.file_exists(HIGH_SCORE_FILE):
		var fd = FileAccess.open(HIGH_SCORE_FILE, FileAccess.READ)
		var data = fd.get_var(true)

		if 'high_score' in data and \
			'version' in data and \
			data['version'] == SCORE_VERSION:
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
	if ceil(game_over_timer) == GAME_OVER_TIMEOUT:
		achievements.unlock(AchievementManager.PANIC_MODE)
	
	game_over_timer = 0
	game_over_timer_label.set_text('')

	set_game_over_boundary_visible(false)
	
	
func declare_game_over():
	is_game_over = true
	$ui_root/game_over_screen.visible = true
	game_over.emit()
	
	if high_score <= score:
		achievements.leaderboard_submit(
			AchievementManager.LEADERBOARD_HIGH_SCORES,
			score,
		)


func _physics_process(delta: float):
	if fruit_counter > 0 and !is_game_over:
		game_over_countdown(delta)

		if game_over_timer > GAME_OVER_TIMEOUT:
			declare_game_over()
	else:
		reset_game_over_countdown()


func update_score(new: int):
	score = new
	score_changed.emit(score)
	
	if score > high_score:
		update_high_score(score)


func _on_dispenser_fruit_dropped(level: int):
	if is_game_over:
		return

	combo_reset.emit()
	combo_counter = 0

	score += int(pow(2, level - 1))


func _on_fruit_combined(level: int):
	if is_game_over:
		return
		
	if combo_counter < AchievementManager.MAX_COMBO_MULTIPLIER:
		combo_counter += 1

	achievements.combine_achievements(
		combo_counter,
		level,
	)

	combo_progress.emit(combo_counter)

	score += ceil(int(pow(2, level - 1)) * combo_counter)


func _on_game_over_boundary_body_entered(body: Node2D):
	if body.is_in_group('fruit'):
		fruit_counter += 1


func _on_game_over_boundary_body_exited(body):
	if body.is_in_group('fruit'):
		fruit_counter -= 1


func _on_new_game_pressed():
	get_tree().reload_current_scene()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
