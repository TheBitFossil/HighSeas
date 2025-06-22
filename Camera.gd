extends Node2D

@export var is_scrolling : bool = false
@export var speed := 200.0
@onready var camera_2d: Camera2D = $Camera2D

var default_zoom := Vector2(.8, .8)
var siren_zoom := Vector2(1.1, 1.1)
var goal_zoom := Vector2(1.3, 1.3)

enum CAMERA_STATES { STATIC, FOLLOW }
@export var cam_state : CAMERA_STATES = CAMERA_STATES.STATIC 
var camera_targets : Array = []
@export var camera_multitarget_zoom_speed : float = 3.0
var player : Player = null


func _ready() -> void:
	camera_zoom_reset()
	EvBus.has_reached_goal.connect(_on_has_reached_goal)
	#EvBus.camera_static.connect(_on_camera_static)
	#EvBus.camera_follow.connect(_on_camera_follow)
	EvBus.camera_shake.connect(_on_camera_shake)
	
	player = get_tree().get_first_node_in_group("Player")
	add_target(player)

func _on_has_reached_goal()->void:
	camera_2d.zoom = goal_zoom
	deactivate_scroll()


func _physics_process(delta: float) -> void:
	if cam_state == CAMERA_STATES.STATIC:
		return
	elif cam_state == CAMERA_STATES.FOLLOW:
		global_position.y -= speed * delta


func add_target(t):
	if not t in camera_targets:
		camera_targets.append(t)


func multi_cam_pos():
	if !camera_targets:
		return
	
	var pos = Vector2.ZERO
	for target in camera_targets:
		pos += target.global_position
	pos /= camera_targets.size()
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", pos, camera_multitarget_zoom_speed)


func reset_multi_cam_pos():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", player.global_position, camera_multitarget_zoom_speed)


func clear_targets():
	#TODO: Make clean here
	#if t in camera_targets:
		#camera_targets.erase(t)
	camera_targets.clear()
	camera_targets.append(player)


func _on_camera_shake():
	var tween = create_tween()
	tween.set_parallel(false)

	var strength := 4.0
	var duration := 0.05
	var cycles := 7

	for i in cycles:
		var direction := Vector2.ZERO
		if i % 2 == 0:
			direction = Vector2.LEFT
		else:
			direction = Vector2.RIGHT
		
		tween.tween_property(camera_2d, "offset", direction * strength, duration).as_relative()
	
	tween.tween_property(camera_2d, "offset", Vector2.ZERO, duration)



func activate_scroll():
	cam_state = CAMERA_STATES.FOLLOW


func deactivate_scroll():
	cam_state = CAMERA_STATES.STATIC

#TODO: Rework whole camera zooming. this got out of hand

func camera_zoom_siren():
	var tween = get_tree().create_tween().parallel()
	tween.tween_property(camera_2d, "zoom", siren_zoom, camera_multitarget_zoom_speed).set_trans(Tween.TRANS_CUBIC)


func camera_zoom_reset():
	var tween = get_tree().create_tween().parallel()
	tween.tween_property(camera_2d, "zoom", default_zoom, camera_multitarget_zoom_speed).set_trans(Tween.TRANS_CUBIC)


func lure_in_mode_active(target):
	deactivate_scroll()
	#Multi Cam Start
	add_target(target)
	#Move in position
	multi_cam_pos()
	camera_zoom_siren()


func lure_in_mode_deactived():
	clear_targets()
	camera_zoom_reset()
	reset_multi_cam_pos()
	
	await get_tree().create_timer(2.0).timeout
	activate_scroll()

"""
	Deprecated ? 
	func _on_camera_static(activate_zoom : bool):
		if activate_zoom:
			#TODO: make zoom for different engagements
			camera_zoom_siren()
			multi_cam_pos()
		
		deactivate_scroll()


	func _on_camera_follow():
	camera_zoom_reset()
	reset_multi_cam_pos()
	activate_scroll()
"""
