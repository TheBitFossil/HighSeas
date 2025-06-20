extends Area2D

signal has_reached_goal(id)
	

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("reach_goal"):
		emit_signal("has_reached_goal", area)
