extends Node

@export var max_health = 200
@export var is_player = false
@onready var health = max_health:

	get: 
		return health 
	set(value):
		health = value 
		if health <= 0:
			emit_signal("no_health")

signal no_health
