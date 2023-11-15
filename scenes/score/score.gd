extends Label


@export var prefix: String = ''


func _ready():
	set_text(prefix + '0')


func _on_level_score_changed(score: int):
	set_text(prefix + str(score))
