extends Area3D


func _on_body_entered(body):
	# Check if the collided body is the player
	if body.is_in_group("player"):
		# Increment the global ammo variable by 10
		Global.ammo += 10  # Assuming Global is the name of your global script
		print(Global.ammo)
		# Queue the ammo object for deletion
		queue_free()
