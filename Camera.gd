extends Node2D

@export var is_scrolling : bool = false
@export var speed := 200.0
@onready var camera_2d: Camera2D = $Camera2D


var default_zoom := Vector2(.8, .8)
var siren_zoom := Vector2(1.1, 1.1)


func _ready() -> void:
	camera_zoom_reset()


func _physics_process(delta: float) -> void:
	if not is_scrolling:
		return
		
	global_position.y -= speed * delta


func activate_scroll():
	is_scrolling = true


func deactivate_scroll():
	is_scrolling = false


func camera_zoom_siren():
	camera_2d.zoom = siren_zoom


func camera_zoom_reset():
	camera_2d.zoom = default_zoom


func lure_in_mode_active():
	deactivate_scroll()
	camera_zoom_siren()


func lure_in_mode_deactived():
	camera_zoom_reset()
	await get_tree().create_timer(2.0).timeout
	activate_scroll()
