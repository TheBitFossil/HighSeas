extends CanvasLayer

signal countdown_timeout()


@onready var timer: Timer = %Timer
@export var counter := 3
@onready var label: Label = %Label
var idx : int

@onready var mash_button_module: Control = %MashButton_Module
@onready var song_by_keys: VBoxContainer = $Action_Event_Resist_Siren_Song/Song_By_Keys


func _ready() -> void:
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


func enable_mash_button():
	#song_by_keys.show()
	mash_button_module.set_enabled()
