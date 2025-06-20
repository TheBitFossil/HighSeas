extends CanvasLayer
class_name HUD

signal tutorial_msg_closed()

@onready var hp: ProgressBar = %ProgressBar_Hp
@onready var crew: TextureProgressBar = %TextureProgressBar_Crew
@onready var tutorial_msg: Control = %Tutorial_Msg
@onready var infos: Control = %Infos

var tutorial_active : bool = true


func _ready() -> void:
	infos.hide()
	tutorial_msg.show()
	
	hp.max_value = Data.MAX_HP
	hp.value = Data.hp
	hp.step = .1
	
	crew.max_value = Data.MAX_CREW
	crew.value = Data.crew
	crew.step = 1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_to_target"):
		close_tutorial_msg()


func close_tutorial_msg():
	tutorial_active = false
	tutorial_msg.hide()
	infos.show()
	EvBus.emit_signal("tutorial_msg_closed")


func _on_health_changed(value : int):
	hp.value = value


func _on_crew_changed(value : int):
	crew.value = value
