extends Node2D
class_name Siren

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_player_detector_area_entered(area: Area2D) -> void:
	if area.has_method("get_lured_by_siren"):
		area.get_lured_by_siren(global_position)


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.has_method("get_lured_by_siren"):
		body.get_lured_by_siren(self)


func resist_siren_song():
	animation_player.play("hide")
