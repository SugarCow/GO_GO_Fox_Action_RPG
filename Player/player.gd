extends CharacterBody2D


# Called when the node enters the scene tree for the first time.

var direction;
@export var acceleration = 500 # the rate of which the speed changes overtime, so a higher value will mean it will reach the max_speed faster
@export var max_speed = 80; 
@export var friction = 500 # used for decelerating movements so that the movement is more smooth
@export var roll_speed = 400
var roll_finished = true

enum {  #short for enumerations similar to const
	MOVE, #rtepresents 1 
	ROLL,  # represents 2 
	ATTACK # represents 3 
}
enum {  #short for enumerations similar to const
	run, #rtepresents 1 
	roll,  # represents 2 
	attack # represents 3 
}
var state = MOVE
var stats = PlayerStats

@onready var animation_tree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

var input_direction = Vector2.ZERO
var roll_direction = Vector2.DOWN
var facing_direction = Vector2.DOWN # used for the knockback direction of enemies
func _ready():
	stats.no_health.connect(queue_free)
	animation_tree.active = true

func _process(delta): # use this instead of the _physis_process() because we are not using any characterBody2D functionaility

	match state:  # same as the switch statement 
		MOVE:
			move_state(delta)
		ROLL: 
			roll_state(delta, roll_direction)
		ATTACK: 
			attack_state(delta)

func attack_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("attack")

func roll_state(delta, dir):
	animation_state.travel("roll")
	dir = dir.normalized()
	velocity = velocity.move_toward(dir * roll_speed, 200 * delta) 
	move_and_slide()


func move_state(delta):
	input_direction = Vector2( 
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") -  Input.get_action_strength("ui_up"))
		
	
	input_direction = input_direction.normalized() # the vector is normalized so that the player moves at consistent speed, this will prevent the 
													# the player from moving faster in the diagonal direction
	
	
	
	if input_direction != Vector2.ZERO:
		animation_tree.set("parameters/run/blend_position", input_direction)
		animation_tree.set("parameters/idle/blend_position", input_direction)
		animation_tree.set("parameters/attack/blend_position", input_direction) 
		animation_tree.set("parameters/roll/blend_position", input_direction) 
		roll_direction = input_direction
		facing_direction = input_direction
		animation_state.travel("run")

#		velocity += input_direction * accleration * delta
#		velocity = velocity.clamp(-1 * Vector2(max_speed, max_speed), Vector2(max_speed, max_speed))
		velocity = velocity.move_toward(input_direction * max_speed, acceleration * delta) # we could also use this

	else:
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta ) 

	
		
#	move_and_slide()
	move_and_slide()
	if Input.is_action_just_pressed("attack"):
		state = ATTACK 
	if Input.is_action_just_pressed("roll") and roll_finished == true  :
		state = ROLL 
		roll_finished = false
	

#func _on_animation_tree_animation_finished(anim_name):
#	match anim_name:
#		attack:
#			state = MOVE
#		roll: 
#			state = MOVE

func attack_animation_finished():
	state = MOVE

func roll_animation_finsihed():
	velocity = velocity.move_toward(Vector2.ZERO, friction ) 
	move_and_slide()
	state = MOVE
	roll_finished = true



func _on_hurt_box_area_entered(area):
	stats.health -= 1
	print("health depleting")
