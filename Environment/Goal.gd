extends Area2D

signal has_reached_goal(id)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("reached_goal"):
		body.reached_goal()
		EvBus.emit_signal("has_reached_goal")
