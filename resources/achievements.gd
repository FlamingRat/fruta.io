extends Resource
class_name AchievementManager


const FIRST_MERGE = "CgkIrZ_72roEEAIQBg"
const THOUSAND_COMBOS = "CgkIrZ_72roEEAIQBw"
const LEGENDARY = "CgkIrZ_72roEEAIQAQ"
const MAX_FRUIT = "CgkIrZ_72roEEAIQAg"
const PANIC_MODE = "CgkIrZ_72roEEAIQBQ"
const TOO_MUCH_EDGE = "CgkIrZ_72roEEAIQCA"


var play_games_services
var ready = false
var session_unlocks = {}


func _init():
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
	ready = true


func _on_sign_in_failed(_info):
	ready = false
	
	
func unlock(achievement_id: String):
	if achievement_id in session_unlocks:
		return

	print('Achievement unlocked: ', achievement_id)

	session_unlocks[achievement_id] = true
	
	if not ready:
		return

	play_games_services.unlockAchievement(achievement_id)


func increment(achievement_id: String, step: int):	
	print('Achievement incremented: ', achievement_id)

	if not ready:
		return

	play_games_services.incrementAchievement(achievement_id, step)
	

func is_ready() -> bool:
	return ready
