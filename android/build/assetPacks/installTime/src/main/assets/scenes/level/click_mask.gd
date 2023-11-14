extends Button


signal click_mask_pressed


func _pressed():
	click_mask_pressed.emit()
