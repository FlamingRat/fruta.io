extends Label


func _on_level_high_score_updated(score: int):
	set_text(str(score))
