extends Node2D

@export var ship_health : int = 20
#todo add ship health
@export var _is_dangerous := false

var speed : float = 50.0
var is_moving : bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.has_method("collect_flotsam"):
		return
		
	if _is_dangerous:
		if body.has_method("take_damage"):
			body.take_damage(ship_health)
			Data.add_oil()
			call_deferred("queue_free")
	else:
		if body.collect_flotsam(ship_health):
			Data.add_flotsam()
			call_deferred("queue_free")


func _physics_process(delta: float) -> void:
	if is_moving:
		position.y += speed * delta
