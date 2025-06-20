extends Node2D

@onready var ui: CanvasLayer = %UI
@onready var mash_button_module: Control = %MashButton_Module

@onready var ship: CharacterBody2D = %Ship
@onready var camera_2d: Node2D = %Camera
@onready var goal: Area2D = %Goal


func _ready() -> void:
	ship.lured_in.connect(_on_ship_lured_in)
	#ui.countdown_timeout.connect(_on_ui_countdown_timeout)
	#TODO: Add the count_down_module if needed
	mash_button_module.mash_button_success.connect(_on_mash_button_success)
	
	EvBus.tutorial_msg_closed.connect(_on_tutorial_msg_closed)
	EvBus.restart_game.connect(_on_restart_game)
	

func _on_ship_lured_in():
	camera_2d.lure_in_mode_active()
	ui.enable_mash_button()

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


func _on_restart_game():
	get_tree().reload_current_scene()
