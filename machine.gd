extends Area3D

func _ready():
	# Connect the finished signal to the _on_audio_stream_player_finished method using Callable
	$AudioStreamPlayer.connect("finished", Callable(self, "_on_audio_stream_player_finished"))


func _on_body_entered(body):
	# Check if the collided body is the player
	if body.is_in_group("player"):
		$AudioStreamPlayer.play()
		Global.last_weapon = "machine"
		Global.current_weapon = "machine"
		set_deferred("monitoring", false)



func _on_audio_stream_player_finished():
	queue_free()
