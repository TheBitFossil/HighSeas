extends Control

@onready var MashButtonTimer: Timer = %MashButtonTimer
@onready var mash_button_progress: TextureProgressBar = %TextureProgressBar


var is_active : bool = false
var mash_button_idx : int = 0
var max_button_hits : int = 10
@export var amount_to_increase : int = 1
@export var amount_to_decrease : int = 3


func _ready() -> void:
	set_disabled()
	mash_button_progress.value = 0
	mash_button_progress.max_value = max_button_hits
	mash_button_progress.step = 1


func set_enabled():
	is_active = true
	show()


func set_disabled():
	is_active = false
	hide()


func reset_idx():
	mash_button_idx = 0


func _input(event: InputEvent) -> void:
	if not is_active:
		return
		
	if event.is_action_pressed("move_to_target"):
		mash_button_idx += amount_to_increase
		
		if mash_button_idx > max_button_hits:
			mash_button_idx = max_button_hits
			EvBus.emit_signal("mash_button_success")
			set_disabled()
			reset_idx()
		else:
			mash_button_progress.value = mash_button_idx
			MashButtonTimer.start()


func _on_mash_button_timer_timeout() -> void:
	mash_button_progress.value = mash_button_idx
	mash_button_idx -= amount_to_decrease
	if mash_button_idx <= 0:
		mash_button_idx = 0
		print("Button Mash: ", mash_button_idx)
	MashButtonTimer.start()
