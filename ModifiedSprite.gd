extends Node2D

func _ready():
	$Sprite.visible = false
	pass

func play_sprite_animation(index):
	$Sprite.visible = true
	$Sprite.region_rect.position.x = 32*index + 64
	$Animation.current_animation = "Takeout"
	$Animation.play()

func _on_Animation_animation_finished(anim_name):
	$Sprite.visible = false
	pass
