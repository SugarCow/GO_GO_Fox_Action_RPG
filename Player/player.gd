extends CharacterBody2D


# Called when the node enters the scene tree for the first time.

var direction;
const acceleration = 500 # the rate of which the speed changes overtime, so a higher value will mean it will reach the max_speed faster
const max_speed = 80; 
const friction = 500 # used for decelerating movements so that the movement is more smooth

@onready var animation_player =  $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

var input_direction = Vector2.ZERO

func _physics_process(delta):		
	input_direction = Vector2( 
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") -  Input.get_action_strength("ui_up"))
		
	input_direction = input_direction.normalized() # the vector is normalized so that the player moves at consistent speed, this will prevent the 
													# the player from moving faster in the diagonal direction
	
	if input_direction != Vector2.ZERO:
		animation_tree.set("parameters/run/blend_position", input_direction)
		animation_tree.set("parameters/idle/blend_position", input_direction)
		animation_state.travel("run")
		
#		velocity += input_direction * accleration * delta
#		velocity = velocity.clamp(-1 * Vector2(max_speed, max_speed), Vector2(max_speed, max_speed))
		velocity = velocity.move_toward(input_direction * max_speed, acceleration * delta) # we could also use this
	
	else:
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta ) 

		
#	if input_direction.x > 0:
#
#		animation_player.play("run_right")
##		get_node("AnimatedSprite2D").h_flip = true
#	if input_direction.x < 0:
#		animation_player.play("run_left")
##		get_node("AnimatedSprite2D").h_flip = false
#	if input_direction.y > 0:
#		if abs(input_direction.x) <= abs(input_direction.y):
#			animation_player.play("run_down")
#
#
#	if input_direction.y < 0:
#		if abs(input_direction.x) <= abs(input_direction.y):
#			animation_player.play("run_up")

#		get_node("AnimatedSprite2D").h_flip = false
	print(input_direction)
#	move_and_slide()
	move_and_slide()
