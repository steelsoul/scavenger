extends Node

onready var screen_size = Vector2(
	ProjectSettings.get("display/window/size/width"),
	ProjectSettings.get("display/window/size/height"))
onready var player = $Player
onready var info_position = $Info.rect_position

func _ready():
	update_camera()

func update_camera():
	var canvas_transform = get_viewport().get_canvas_transform()
	canvas_transform[2] = - player.position + screen_size / 2
	get_viewport().set_canvas_transform(canvas_transform)
	$Info.rect_position = info_position - canvas_transform[2]
	pass
	
func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		var vp = get_viewport()
		var mp = vp.get_mouse_position()
		var canvas_transform = get_viewport().get_canvas_transform()
		var wp = $Level/FOOD.world_to_map(mp - canvas_transform[2])
		
		wp.x = floor(wp.x / 2)
		wp.y = floor(wp.y / 2)
		
		print(mp, " is ", wp)
	$Info.text = "Food: " + str($Player.food)

 