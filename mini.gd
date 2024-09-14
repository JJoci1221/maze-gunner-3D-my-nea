extends Area3D

func _ready():
	$AudioStreamPlayer.connect("finished", Callable(self, "_on_audio_stream_player_finished"))

func _on_body_entered(body):
	# Check if the collided body is the player
	if body.is_in_group("player"):
		$AudioStreamPlayer.play()
		Global.last_weapon = "mini"
		Global.current_weapon = "mini"
		set_deferred("monitoring", false)


func _on_audio_stream_player_finished():
	queue_free()
