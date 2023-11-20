extends Node


const CUSTOMIZATION_FILE = 'user://customization.save'


var current_skin = '' : set = set_current_skin, get = get_current_skin


func get_current_skin():
	if current_skin == '' and FileAccess.file_exists(CUSTOMIZATION_FILE):
		var fd = FileAccess.open(CUSTOMIZATION_FILE, FileAccess.READ)
		var data = fd.get_var(true)
		
		if 'current_skin' in data:
			current_skin = data['current_skin']
			
	return current_skin if current_skin else 'default'


func set_current_skin(value: String):
	var fd = FileAccess.open(CUSTOMIZATION_FILE, FileAccess.WRITE)
	
	fd.store_var({
		'current_skin': value,
	}, true)
	fd.close()
	
	current_skin = value


func get_skin_resource(resource_name: String):
	var resource_path = (
		'res://sprites/skins/' + current_skin + '/' + resource_name + '.png'
	)
	
	if !ResourceLoader.exists(resource_path):
		return load('res://sprites/skins/default/' + resource_name + '.png')
	
	return load(resource_path)
