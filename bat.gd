extends CharacterBody2D

@onready var anim = $AnimatedSprite
@onready var stats = $Stats
enum {
	PATROL,
	FOLLOW, 
	ATTACK,
	KNOCK_BACK
}

const patrol_speed = 25
const follow_speed = 35
const change_direction_timer = 350
const attack_cooldown = 150
const knock_back_speed = 400
var knock_back_timer = 60 
var knockback = Vector2.ZERO
var being_knocked = false

var timer = change_direction_timer
var attk_timer = attack_cooldown
var state = PATROL
var dir = Vector2.LEFT
var player
var health = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../ysort/Player")
	
	anim.play("Fly")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = knockback.move_toward(Vector2.ZERO, 500 * delta)
	knockback = velocity
	move_and_slide()
	match state: 
		PATROL: 
			patrol()
		FOLLOW: 
			follow()
		ATTACK:
			attack()
		KNOCK_BACK:
			knock_back(delta)

	if state == PATROL and timer > 0:
		timer -= 1
	

			
func patrol():
	velocity = dir * patrol_speed 
	
	if timer <= 0: 
		dir = -dir
		
		timer = change_direction_timer
	
	if dir.x > 0:
		anim.flip_h = false
	else: anim.flip_h = true
	
	move_and_slide()

func follow():
	player = get_node("../../ysort/Player")
	var target_direction = (player.position - self.position).normalized()
	if target_direction.x > 0:
		anim.flip_h = false
	else: anim.flip_h = true
	velocity = target_direction * follow_speed 
	move_and_slide()
	
func attack():
	follow()
	if attk_timer > 0:
		attk_timer -= 0
		print("attacking Player")
	if attk_timer <= 0:
		attk_timer = attack_cooldown
		

func knock_back(delta):
	pass
		

	
	

func _on_detect_player_body_entered(body):
	if body.name == "Player":
		state = FOLLOW


func _on_detect_player_body_exited(body):
	if body.name == "Player":
		state = PATROL


func _on_attack_area_body_entered(body):
	state = ATTACK
	


 
func _on_hurt_box_area_entered(area):
	knockback = player.facing_direction * 250
	being_knocked = true
	stats.health -= 1
	print(stats.health)
	


func _on_stats_no_health():
	queue_free()



func _on_attack_area_body_exited(body):
	if body.name == "Player":
		state = FOLLOW
