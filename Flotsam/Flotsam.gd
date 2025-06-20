extends Node2D

@export var ship_health : int = 20
#todo add ship health


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("collect_flotsam"):
		if body.collect_flotsam(ship_health):
			call_deferred("queue_free")
