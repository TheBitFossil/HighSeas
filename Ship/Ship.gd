extends CharacterBody2D

signal lured_in()

@export var default_speed := 200.0
@export var lured_speed := 50.0		#when lured by siren
var speed : float

@export var default_rot_speed := 5.0 
@export var lured_rot_speed := 2.0 	#when lured by siren
var rot_speed : float

var is_drawn_in : bool = false
var has_controls_enabled: bool = false
var target : Vector2 = Vector2.ZERO
var siren_target : Siren = null


var health := 50.0
@export var max_health := 100.0

@onready var anim_trails: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	speed = default_speed
	rot_speed = default_rot_speed


func _input(event: InputEvent) -> void:
	if not has_controls_enabled:
		return
		
	if event.is_action_pressed("move_to_target") and not is_drawn_in:
		target = get_mouse_target()


func get_mouse_target() -> Vector2:
	return get_global_mouse_position()


func get_siren()-> Vector2:
	return Vector2.ZERO


func _physics_process(delta: float) -> void:
	if is_drawn_in:
		target = get_siren_pos()
	
	if target != Vector2.ZERO:
		# Cal dir vec towards the target
		var direction := position.direction_to(target)
		
		# Smooth rotate towards
		var angle_to_target := direction.angle()
		rotation = lerp_angle(rotation, angle_to_target, rot_speed * delta)
	
		# Movement
		velocity = direction * speed
		
		var dist = position.distance_to(target)
		# Stay within distance
		if dist > 10:
			move_and_slide()
		else:
			velocity = Vector2.ZERO
	
	trail_animation(velocity)

# Called from reaching Goal Area
func reached_goal():
	disable_controls()


func enable_controls():
	has_controls_enabled = true


func disable_controls():
	has_controls_enabled = false


func get_lured_by_siren(antagonist : Siren):
	is_drawn_in = true
	siren_target = antagonist
	speed = lured_speed
	rot_speed = lured_rot_speed
	disable_controls()
	emit_signal("lured_in")


func resist_siren_success():
	is_drawn_in = false
	siren_target.resist_siren_song()
	siren_target = null
	speed = default_speed
	rot_speed = default_rot_speed
	enable_controls()


func resist_siren_fail():
	take_damage()


func get_siren_pos() -> Vector2:
	if siren_target != null:
		return siren_target.global_position
	return Vector2.ZERO


func take_damage():
	health -= 2


func trail_animation(velocity):
	if velocity.length() > 0:
		anim_trails.play("idle")
		anim_trails.show()
	else:
		anim_trails.stop()
		anim_trails.hide()


func collect_flotsam(ship_health) -> bool:
	if (health + ship_health) > max_health:
		health = max_health
	else:
		health += ship_health
	return true
