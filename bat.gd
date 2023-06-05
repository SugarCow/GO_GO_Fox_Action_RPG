extends CharacterBody2D

@onready var anim = $AnimatedSprite
enum {
	PATROL,
	FOLLOW, 
	ATTACK
}

const patrol_speed = 25
const follow_speed = 35
const change_direction_timer = 350
const attack_cooldown = 150
const knock_back_speed = 500

var timer = change_direction_timer
var attk_timer = attack_cooldown
var state = PATROL
var dir = Vector2.LEFT
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Fly")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state: 
		PATROL: 
			patrol()
		FOLLOW: 
			follow()
		ATTACK:
			attack()
			
	if state == PATROL and timer > 0:
		timer -= 1
			
func patrol():
	velocity = dir * patrol_speed 
	
	if timer <= 0: 
		dir = -dir
		print("changing direction")
		timer = change_direction_timer
	
	if dir == Vector2.LEFT:
		anim.flip_h = true
	else: anim.flip_h = false
	move_and_slide()

func follow():
	player = get_node("../Player")
	var target_direction = (player.position - self.position).normalized()
	
	velocity = target_direction * follow_speed 
	move_and_slide()
	
func attack():
	follow()
	if attk_timer > 0:
		attk_timer -= 0
		print("attacking Player")
	if attk_timer <= 0:
		attk_timer = attack_cooldown
		

func _on_detect_player_body_entered(body):
	if body.name == "Player":
		state = FOLLOW


func _on_detect_player_body_exited(body):
	if body.name == "Player":
		state = PATROL


func _on_attack_area_body_entered(body):
	state = ATTACK
	


func _on_hurt_box_body_entered(body):
	var knock_back_dir = player.input_direction 
	velocity = knock_back_dir *knock_back_speed 
	move_and_slide()
