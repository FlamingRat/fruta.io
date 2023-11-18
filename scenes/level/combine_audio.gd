extends AudioStreamPlayer


const SEMITONE = pow(2, 1 / 12.0)
const MAJOR_SCALE = [0, 2, 4, 5, 7, 9, 11, 12]
	

func _on_level_combo_progress(combo_progress: int, _fruit_level: int):
	if combo_progress < 1:
		return

	pitch_scale = 1 * pow(SEMITONE, MAJOR_SCALE[combo_progress - 1])
	play()
