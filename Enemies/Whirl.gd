extends Node2D




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("start_whirl"):
		body.start_whirl()
		EvBus.emit_signal("camera_static")
	
		await get_tree().create_timer(2.0).timeout
		$AnimationPlayer.play("fade_out")
		EvBus.emit_signal("camera_follow")
