extends CheckButton


var seek: float = 0


func _toggled(active: bool):
	if active:
		$bgm.play(seek)
		$icon.frame = 2
	else:
		seek = $bgm.get_playback_position()
		$bgm.stop()
		$icon.frame = 3
