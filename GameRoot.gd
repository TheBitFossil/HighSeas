extends Node2D
class_name GameRoot


@onready var ship: CharacterBody2D = %Ship
@onready var camera_2d: Node2D = %Camera
@onready var goal: Area2D = %Goal
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var mash_button_module: Control = %MashButton_Module
@onready var hud: HUD = %HUD
@onready var out_of_screen_feedback: CenterContainer = %OutOfScreenFeedback
@onready var out_of_screen_feedback_timer: Timer = %OutOfScreenFeedbackTimer



func _ready() -> void:
	EvBus.tutorial_msg_closed.connect(_on_tutorial_msg_closed)
	EvBus.restart_game.connect(_on_restart_game)
	EvBus.mash_button_success.connect(_on_mash_button_success)
	EvBus.mash_button_failed.connect(_on_mash_button_failed)
	EvBus.lured_in.connect(_on_ship_lured_in)
	EvBus.game_over.connect(_on_game_over)
	EvBus.left_screen.connect(_on_left_screen)
	EvBus.enter_screen.connect(_on_enter_screen)
	
	audio_stream_player.set_playing(true)
	Data.reset_hud_stats()
	hud.init_stats()
	
	get_tree().paused = false


func _on_left_screen():
	#show UI
	out_of_screen_feedback.show()
	#start damage timer
	out_of_screen_feedback_timer.start()
	#show text
	$HUD/OutOfScreenFeedback/RichTextLabel.show()


func _on_enter_screen():
	#hide UI
	out_of_screen_feedback.hide
	#stop timer
	out_of_screen_feedback_timer.stop()
	#hide text
	$HUD/OutOfScreenFeedback/RichTextLabel.hide()


func _on_ship_lured_in(siren):
	camera_2d.lure_in_mode_active(siren)
	hud.enable_mash_button()


"""
	func _on_ui_countdown_timeout():
	ship.enable_controls()
	camera_2d.activate_scroll()
"""


func _on_tutorial_msg_closed()-> void:
	ship.enable_controls()
	camera_2d.activate_scroll()


func _on_mash_button_success():
	ship.enable_controls()
	ship.resist_siren_success()
	
	camera_2d.lure_in_mode_deactived()
	
	mash_button_module.set_disabled()
	mash_button_module.reset_idx()


func _on_mash_button_failed():
	ship.enable_controls()
	ship.resist_siren_failed()
	
	camera_2d.lure_in_mode_deactived()
	
	mash_button_module.set_disabled()
	mash_button_module.reset_idx()


func _on_restart_game():
	Data.reset_hud_stats()
	get_tree().reload_current_scene()


func _on_game_over():
	#show hud
	hud.show_game_over_screen()
	ship.disable_controls()
	EvBus.emit_signal("camera_static")
	$AudioStreamPlayer.stop()
	get_tree().paused = true
