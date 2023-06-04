extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func create_grass_effect():

	var GrassEffect = load("res://grass_effect.tscn")
	var grassEffect = GrassEffect.instantiate()
	
	var main = get_tree().current_scene # find the grasses node to spawn the effects for the grass
	main.add_child(grassEffect) #create an instance of grass effect
	
	
	grassEffect.global_position = self.global_position
	queue_free()
	




func _on_hurt_box_area_entered(area):
	create_grass_effect()

