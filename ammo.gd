extends Area3D

func _ready():
	# Connect the finished signal to the _on_audio_stream_player_finished method using Callable
	$AudioStreamPlayer.connect("finished", Callable(self, "_on_audio_stream_player_finished"))

func _on_body_entered(body):
	if body.is_in_group("player")and Global.ammo < 100:
		Global.ammo += 10  
		$AudioStreamPlayer.play()
		print(Global.ammo)
		Global.current_weapon = Global.last_weapon
		set_deferred("monitoring", false)

func _on_audio_stream_player_finished():
	queue_free()
