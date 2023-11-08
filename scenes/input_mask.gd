extends Button


signal drop_fruit_pressed


func _pressed():
	drop_fruit_pressed.emit()
