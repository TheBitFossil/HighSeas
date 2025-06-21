extends Node2D
class_name Siren

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var attack_cool_down_timer: Timer = %CoolDownTimer
@export var time_in_sec_to_attack : int = 2



func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.has_method("get_lured_by_siren"):
		body.get_lured_by_siren(self)
		start_attack_timer()


func start_attack_timer():
	attack_cool_down_timer.wait_time = time_in_sec_to_attack
	attack_cool_down_timer.start()


func stop_attack_timer():
	attack_cool_down_timer.stop()


func _process(delta: float) -> void:
	if attack_cool_down_timer.get_time_left():
		print("Running: ", attack_cool_down_timer.get_time_left())


func remove_crew():
	Data.remove_crew()
	start_attack_timer()


#Called from Player through Collision layer!
func player_resist_siren_song():
	anim_player.play("hide")
	Data.add_siren_defeat()
	stop_attack_timer()


func _on_cool_down_timer_timeout() -> void:
	if Data.crew <= 1:
		anim_player.play("hide")
		EvBus.emit_signal("mash_button_failed")
		Data.add_siren_defeat()
		stop_attack_timer()
	else:
		remove_crew()
