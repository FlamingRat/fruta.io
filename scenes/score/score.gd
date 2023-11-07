extends Label


func _on_level_score_changed(score: int):
	set_text("Score: " + str(score))
