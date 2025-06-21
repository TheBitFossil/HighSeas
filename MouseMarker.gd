extends Node2D

var is_active := false
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func set_pos(pos : Vector2):
	is_active = true
	global_position = pos
	if not animation_player.is_playing():
		animation_player.play("idle")
