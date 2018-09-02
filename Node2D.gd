extends Node

onready var screen_size = Vector2(
	ProjectSettings.get("display/window/size/width"), 
	ProjectSettings.get("display/window/size/height"))

func _ready():
	var canvas_transform = get_viewport().get_canvas_transform()
	canvas_transform[2] = $Player.position
	get_viewport().set_canvas_transform(canvas_transform)
	
	
	print (screen_size)
	
#	for x in ProjectSettings.get_property_list():
#		if x.name.find("display") != -1:
#			print(x)
			
	
	pass

