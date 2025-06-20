extends Node2D


@export var crew_value : int = 1


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("collect_crew"):
		body.collect_crew(crew_value)
