extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var stats = $Stats
enum {
	PATROL,
	FOLLOW, 
	ATTACK
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

const death_effect = preload("res://enemy_death.tscn")
const hurt_effect = preload("res://hit_effect.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("../../ysort/Player")
	
	anim.play("Fly")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = knockback.move_toward(Vector2.ZERO, 500  * delta)
	knockback = velocity
	move_and_slide()
	match state: 
		PATROL: 
			patrol()
		FOLLOW: 
			follow()
		ATTACK:
			attack()
	move_and_slide()

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
	player = get_node("../../Player")
	var target_direction = ((player.position - self.position)- Vector2(0,10)).normalized()
	if target_direction.x > 0:
		anim.flip_h = false
	else: anim.flip_h = true
	velocity = velocity.move_toward(target_direction * follow_speed , 200)
	move_and_slide()
	
func attack():
	follow()
	if attk_timer > 0:
		attk_timer -= 1
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
	


 
func _on_hurt_box_area_entered(area):
	knockback = player.facing_direction * 250
	being_knocked = true
	stats.health -= 1
	
	var hurtEffect = hurt_effect.instantiate()
	var main = get_tree().current_scene
	main.add_child(hurtEffect)
	hurtEffect.global_position = self.global_position
	
	
	


func _on_stats_no_health():
	var deathEffect = death_effect.instantiate() 
	var main = get_tree().current_scene
	main.add_child(deathEffect)
	deathEffect.global_position = self.global_position
	queue_free()



func _on_attack_area_body_exited(body):
	if body.name == "Player":
		state = FOLLOW




