extends Node2D

var can_deal_damage : bool = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not can_deal_damage:
		return
		
	if body.has_method("start_whirl"):
		can_deal_damage = false
		body.start_whirl()
	
		await get_tree().create_timer(2.0).timeout
		$AnimationPlayer.play("fade_out")
