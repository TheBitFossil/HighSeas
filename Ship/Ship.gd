extends CharacterBody2D
class_name Player

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
var can_take_damage : bool = true
var has_left_screen : bool = false

@onready var anim_trails: AnimatedSprite2D = $AnimatedSprite2D
@onready var mouse_marker: Node2D = %MouseMarker
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_cool_down_timer: Timer = %DamageCoolDown


func _ready() -> void:
	speed = default_speed
	rot_speed = default_rot_speed


func _input(event: InputEvent) -> void:
	if not has_controls_enabled:
		if event.is_action_pressed("move_to_target"):
			#TODO: make sure that the game is over here
			print("Ship does not have controls, how do I make sure that the mouse still works?")
			pass
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
		mouse_marker.show()
		
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
			mouse_marker.set_pos(target)
			move_and_slide()
		else:
			mouse_marker.hide()
			velocity = Vector2.ZERO
	
	trail_animation(velocity)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		hit_rock()

	if Data.hp <= (Data.MAX_HP / 2) - 5: #TODO: remove magic numbers, add a real value when ship is repaired
		$AnimPlayer_Damage.play("damaged")
	else:
		$AnimPlayer_Damage.play("repaired")


func hit_rock():
	if not can_take_damage:
		return
	
	can_take_damage = false
	damage_cool_down_timer.start()
	#TODO: this is for ALL Collisions regardless, need to check SPECIFIC for a Rock if needed
	%HitRockVFX.set_emitting(true)
	Data.player_hit_rock()
	animation_player.play("hit_rock")
	EvBus.emit_signal("camera_shake")


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
	EvBus.emit_signal("lured_in", siren_target)


func resist_siren_success():
	is_drawn_in = false
	#TODO: remove dependancy here, this is not really needed
	siren_target.player_resist_siren_song()
	siren_target = null
	speed = default_speed
	rot_speed = default_rot_speed
	enable_controls()


func resist_siren_failed():
	is_drawn_in = false
	siren_target = null
	speed = default_speed
	rot_speed = default_rot_speed
	enable_controls()


func get_siren_pos() -> Vector2:
	if siren_target != null:
		return siren_target.global_position
	return Vector2.ZERO


func take_damage(val : int):
	Data.remove_hp(val)


func collect_crew(val : int) -> bool:
	Data.add_crew(val)
	return true


func trail_animation(velocity):
	if velocity.length() > 0:
		anim_trails.play("idle")
		anim_trails.show()
	else:
		anim_trails.stop()
		anim_trails.hide()


func collect_flotsam(ship_health) -> bool:
	Data.add_hp(ship_health)
	return true


func start_whirl():
	if not can_take_damage:
		return
		
	animation_player.play("hit_whirl")
	#Loose Crew
	Data.remove_crew()
	#Loose Health
	Data.remove_hp(Data.enter_whirl_damage)
	damage_cool_down_timer.start()


func _on_damage_cool_down_timeout() -> void:
	can_take_damage = true
	print("Can take damage again!")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	has_left_screen = true
	print("Left Screen")
	EvBus.emit_signal("left_screen")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if has_left_screen:
		print("Enter Screen")
		EvBus.emit_signal("enter_screen")
