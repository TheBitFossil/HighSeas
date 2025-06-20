extends Node2D

@export var is_scrolling : bool = false
@export var speed := 200.0
@onready var camera_2d: Camera2D = $Camera2D


var default_zoom := Vector2(.8, .8)
var siren_zoom := Vector2(1.1, 1.1)
var goal_zoom := Vector2(1.3, 1.3)

enum CAMERA_STATES { STATIC, FOLLOW }
@export var cam_state : CAMERA_STATES = CAMERA_STATES.STATIC 


func _ready() -> void:
	camera_zoom_reset()
	EvBus.has_reached_goal.connect(_on_has_reached_goal)


func _on_has_reached_goal()->void:
	camera_2d.zoom = goal_zoom
	deactivate_scroll()


func _physics_process(delta: float) -> void:
	if cam_state == CAMERA_STATES.STATIC:
		return
	elif cam_state == CAMERA_STATES.FOLLOW:
		global_position.y -= speed * delta


func activate_scroll():
	cam_state = CAMERA_STATES.FOLLOW


func deactivate_scroll():
	cam_state = CAMERA_STATES.STATIC


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
