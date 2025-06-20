extends Control

signal mash_button_success()

@onready var MashButtonTimer: Timer = %MashButtonTimer
@onready var sprite: Sprite2D = %Sprite

var is_active : bool = false
var mash_button_idx : int = 0
var max_sprites : int
var idx : int



func _ready() -> void:
	max_sprites = sprite.vframes -5
	set_disabled()


func set_enabled():
	is_active = true
	show()


func set_disabled():
	is_active = false
	hide()

func reset_idx():
	idx = 0

func set_sprite(idx : int):
	sprite.frame = idx


func _input(event: InputEvent) -> void:
	if is_active:
		
		if event.is_action_pressed("move_to_target"):
			idx += 1
			MashButtonTimer.start()
			if idx > max_sprites:
				idx = max_sprites
				emit_signal("mash_button_success")
				set_disabled()
				reset_idx()
				
			set_sprite(idx)


func _on_mash_button_timer_timeout() -> void:
	idx -= 1
	if idx <= 0:
		idx = 0
	
	set_sprite(idx)
	MashButtonTimer.start()
