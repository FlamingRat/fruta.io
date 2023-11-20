extends Node


const MAX_COMBO_MULTIPLIER = 8
const LEADERBOARD_HIGH_SCORES = "CgkIrZ_72roEEAIQAw"
const LEADERBOARD_WATERMELONS = "CgkIrZ_72roEEAIQBA"  # TODO: Implement global counter
const FIRST_MERGE = "CgkIrZ_72roEEAIQBg"
const CHAIN_REACTION = "CgkIrZ_72roEEAIQBw"
const CHAIN_REACTION_II = "CgkIrZ_72roEEAIQCg"
const LEGENDARY = "CgkIrZ_72roEEAIQAQ"
const MAX_FRUIT = "CgkIrZ_72roEEAIQAg"
const PANIC_MODE = "CgkIrZ_72roEEAIQBQ"
const TOO_MUCH_EDGE = "CgkIrZ_72roEEAIQCA"
const HEARTBREAKER = "CgkIrZ_72roEEAIQCw"
const SO_MANY_STARS = "CgkIrZ_72roEEAIQCQ"
const STYLE_POINTS = "CgkIrZ_72roEEAIQDA"


var play_games_services
var _is_ready = false
var session_unlocks = {}
var achievement_cube_counter: int = 0
var heartbreaker_counter: int = 0


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


func _on_sign_in_success(_acc_data):
	_is_ready = true


func _on_sign_in_failed(_info):
	_is_ready = false
	
	
func unlock(achievement_id: String):
	if achievement_id in session_unlocks:
		return

	print('Achievement unlocked: ', achievement_id)

	session_unlocks[achievement_id] = true
	
	if not _is_ready:
		return

	play_games_services.unlockAchievement(achievement_id)


func increment(achievement_id: String, step: int):	
	print('Achievement incremented: ', achievement_id)

	if not _is_ready:
		return

	play_games_services.incrementAchievement(achievement_id, step)
	

func leaderboard_submit(leaderboard_id: String, score: float):
	print("Submitted for leaderboard ", leaderboard_id, ": ", score)

	if not _is_ready:
		return
		
	play_games_services.submitLeaderBoardScore(leaderboard_id, score)
	
	
func view_leaderboard(leaderboard_id: String):
	play_games_services.showLeaderBoard(leaderboard_id)


func is_ready() -> bool:
	return _is_ready
	
	
func combine_achievements(combo_counter: int, level: int):
	if not ready:
		return
	
	unlock(FIRST_MERGE)

	if level == 5:
		heartbreaker_counter += 1
		
		if heartbreaker_counter == 3:
			unlock(HEARTBREAKER)
	else:
		heartbreaker_counter = 0

	if level == 7:
		achievement_cube_counter += 1
		
		if achievement_cube_counter >= 4:
			unlock(TOO_MUCH_EDGE)
	if level == 8:
		achievement_cube_counter -= 1
		
	if level == Fruit.MAX_LEVEL:
		unlock(MAX_FRUIT)
		
		if combo_counter == MAX_COMBO_MULTIPLIER:
			unlock(SO_MANY_STARS)
		
	if combo_counter == 2:
		increment(CHAIN_REACTION, 1)
		increment(CHAIN_REACTION_II, 1)
		
	if combo_counter == MAX_COMBO_MULTIPLIER:
		unlock(LEGENDARY)
