extends CanvasLayer
class_name HUD

signal tutorial_msg_closed()

@onready var hp: ProgressBar = %ProgressBar_Hp
@onready var crew: TextureProgressBar = %TextureProgressBar_Crew
@onready var tutorial_msg: Control = %Tutorial_Msg
@onready var infos: Control = %Infos
@onready var reached_goal_msg: Control = %ReachedGoal_Msg

var tutorial_active : bool = true
var has_reached_goal : bool = false


func _ready() -> void:
	EvBus.has_reached_goal.connect(_on_has_reached_goal)
	
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
		if tutorial_active:
			close_tutorial_msg()
		if has_reached_goal:
			close_goal_msg()


func close_tutorial_msg():
	tutorial_active = false
	tutorial_msg.hide()
	infos.show()
	EvBus.emit_signal("tutorial_msg_closed")


func close_goal_msg():
	reached_goal_msg.hide()
	has_reached_goal = false
	EvBus.emit_signal("restart_game")


func _on_health_changed(value : int):
	hp.value = value


func _on_crew_changed(value : int):
	crew.value = value


func _on_has_reached_goal():
	infos.hide()
	reached_goal_msg.show()
	has_reached_goal = true
