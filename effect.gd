extends AnimatedSprite2D



# Called when the node enters the scene tree for the first time.
func _ready():

	self.animation_finished.connect(_on_animation_finished)
	play("Animate")
	
#left off at 8:07 p15
		

func _on_animation_finished():
	queue_free()
