extends Label


const MAX_COMBO_MULTIPLIER = 8
const COMBO_LABELS = [
	'',
	'',
	'Juicy!',
	'Fresh!',
	'Crazy!',
	'Fantastic!',
	'Amazing!',
	'Impossible!!',
	'LEGENDARY!!!',
]


var achievements: AchievementManager = preload("res://resources/achievements.tres")
var combo_tween: Tween


func _ready():
	animate(0)


func animate(combo_counter: int):
	set_text(COMBO_LABELS[combo_counter])
	scale = Vector2.ZERO
	
	if !combo_tween:
		combo_tween = create_tween()

	if combo_tween.is_running():
		combo_tween.stop()
		scale = Vector2.ZERO

	combo_tween = create_tween()
	combo_tween.tween_property(self, 'scale', Vector2.ONE, 0.2)
	add_theme_font_size_override(
		"font_size", 30 + 2 * (combo_counter - 2)
	)

func _on_level_combo_progress(combo_counter: int, fruit_level: int):
	animate(combo_counter)
		
	if combo_counter == 2:
		achievements.increment(AchievementManager.CHAIN_REACTION, 1)
		achievements.increment(AchievementManager.CHAIN_REACTION_II, 1)
		
	if combo_counter == MAX_COMBO_MULTIPLIER:
		achievements.unlock(AchievementManager.LEGENDARY)
		
		if fruit_level == Fruit.MAX_LEVEL:
			achievements.unlock(
				AchievementManager.SO_MANY_STARS,
			)


func _on_level_combo_reset():
	animate(0)
