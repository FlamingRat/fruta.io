extends Label


func _ready():
	set_text('0')


func _on_level_high_score_updated(score: int):
	set_text(str(score))
