extends Label


@export var prefix: String = ''


func _on_level_score_changed(score: int):
	set_text(prefix + str(score))
