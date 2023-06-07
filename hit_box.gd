extends Area2D
const hitEffect = preload("res://hit_effect.tscn")



func _on_area_entered(area):
	var hit_effect = hitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(hit_effect)
	hit_effect.global_position = global_position
