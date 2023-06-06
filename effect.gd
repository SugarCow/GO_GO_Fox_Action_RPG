extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	play("Animate")
	
#left off at 8:07 p15
		


func _on_animated_sprite_2d_animation_finished():
	queue_free()
