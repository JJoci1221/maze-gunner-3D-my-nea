extends CharacterBody3D


const SPEED = 2.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")  # Get the gravity from the project settings to be synced with RigidBody nodes.
var dead = false
var is_attacking = false  
var attack_range = 5
var guard_health = 100
@onready var player = Global.player

func _ready():
	add_to_group("enemy")

func _physics_process(delta):
	player = Global.player
	if dead or is_attacking: 
		return

	if player == null:
		return
		
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()

	
	velocity = dir * SPEED

	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()
	attack()

func attack():
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		return
	
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	rotation.y = atan2(dir.x, dir.z)

	
	is_attacking = true
	$AnimatedSprite3D.play("shoot")
	$AudioStreamPlayer2.play()
	if $RayCast3D.is_colliding() and $RayCast3D.get_collider().has_method("damage"):
		$RayCast3D.get_collider().damage()
	
	await $AnimatedSprite3D.animation_finished  
	is_attacking = false 

func die():
	dead = true 
	Global.player_score += 100
	$AnimatedSprite3D.play("die")
	$AudioStreamPlayer.play()
	$CollisionShape3D.disabled = true
	
func take_damage():
	guard_health -= 30
	if guard_health <= 0:
		die()

	
	
