extends CharacterBody3D


const SPEED = 10
const JUMP_VELOCITY = 4.5
const TURN_SPEED = 0.05
var knife_range = 10
@onready var ui_script = $ui
@onready var ray = $Camera3D/RayCast3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var can_open_door = false

func _ready():
	add_to_group("player")
	Global.player = self
	print("Global.player set to: ", Global.player)
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if Input.is_action_pressed("ui_left"):
		self.rotate_y(TURN_SPEED)
	if Input.is_action_pressed("ui_right"):
		self.rotate_y(-TURN_SPEED)	
		
		
	if Input.is_action_pressed("ui_accept"):
		if ui_script.can_shoot:
			shoot()
	
	move_and_slide()

func shoot():
	var sound_player = $AudioStreamPlayer  

	match Global.current_weapon:
		"knife":
			sound_player.stream = preload("res://Knife.wav")
		"gun":
			sound_player.stream = preload("res://gun.ogg")
		"machine":
			sound_player.stream = preload("res://machine.ogg")
		"mini":
			sound_player.stream = preload("res://mini.ogg")

	sound_player.play()
	
	if ray.is_colliding():
		var collider = ray.get_collider()
		var distance_to_collider = global_position.distance_to(collider.global_position)

		if Global.current_weapon == "knife" and distance_to_collider > knife_range:
			return
		else:
			if collider.has_method("take_damage"):
				collider.take_damage()
		
func damage():
	Global.player_health -= 10
	print(Global.player_health)
	if Global.player_health <= 0:
		if Global.lives <= 1:
			queue_free()
		else:
			Global.lives -= 1
			Global.player_health = 100
			Global.current_weapon = "gun"
			Global.ammo = 10
			get_tree().change_scene_to_file("res://world.tscn")

	
