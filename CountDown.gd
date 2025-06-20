""" 
	Count Down module which shows seconds on screen
	->Grab the signal to know when the count down is ready
"""
extends Control

signal countdown_timeout()

@export var is_active: bool = false

@onready var timer: Timer = %Timer
@export var counter := 3
@onready var label: Label = %Label
var idx : int


func _ready() -> void:
	if is_active:
		start_count_down()


func start_count_down():
	idx = counter
	
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	label.text = str(idx)


func _on_timer_timeout():
	idx -= 1
	label.text = str(idx)
	
	if idx == 0:
		label.text = str("GO!")
		timer.start()
	elif idx < 0:
		reset_count_down()
	else:
		timer.start()


func reset_count_down():
	emit_signal("countdown_timeout")
	idx = counter
	label.hide()
	label.text = str(idx)
