extends Area3D

func _ready():
	# Connect the finished signal to the _on_audio_stream_player_finished method using Callable
	$AudioStreamPlayer.connect("finished", Callable(self, "_on_audio_stream_player_finished"))

func _on_body_entered(body):
	# Check if the collided body is the player
	if body.is_in_group("player") and Global.player_health < 100:
		$AudioStreamPlayer.play()  # Call play as a function
		Global.player_health = min(Global.player_health + 25, 100)
		print(Global.player_health)
		# Disable the area to prevent multiple triggers
		set_deferred("monitoring", false)

func _on_audio_stream_player_finished():
	queue_free()
