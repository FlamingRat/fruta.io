extends Control


@onready var default_button := $CanvasLayer/Control/vbox/buttons_container/Default
@onready var flowers_button := $CanvasLayer/Control/vbox/buttons_container/Flowers


func _process(_delta):
	for btn in [default_button, flowers_button]:
		btn.button_pressed = false
		
	if Customization.current_skin == 'default':
		default_button.button_pressed = true
	elif Customization.current_skin == 'flowers':
		flowers_button.button_pressed = true


func _on_default_pressed():
	Customization.current_skin = 'default'


func _on_flowers_pressed():
	Customization.current_skin = 'flowers'


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
