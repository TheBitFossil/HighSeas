extends CanvasLayer
class_name HUD

signal tutorial_msg_closed()

@onready var progress_bar_hp: TextureProgressBar = %ProgressBar_Hp
@onready var health_text: RichTextLabel = %Health_Text
@onready var crew_container : HBoxContainer = %Crew
@onready var crew_array: Array[TextureProgressBar]
@onready var anim_infos: AnimationPlayer = %Anim_Infos
@onready var infos: Control = %Infos

@onready var goal_button: Button = %Goal_Button

#Screens
@onready var mash_button_module: Control = %MashButton_Module
@onready var game_over: Control = %Game_Over
@onready var tutorial_msg: Control = %Tutorial_Msg
@onready var reached_goal_msg: Control = %ReachedGoal_Msg

var tutorial_active : bool = true
var has_reached_goal : bool = false


func init_stats():
	update_health()
	update_stats()

	#Init CrewProgressBar
	for child in crew_container.get_children():
		child.max_value = 1
		child.value = 0
		child.step = 1
		crew_array.append(child)

	update_crew()


func _ready() -> void:
	EvBus.has_reached_goal.connect(_on_has_reached_goal)
	EvBus.crew_changed.connect(_on_crew_changed)
	EvBus.health_changed.connect(_on_health_changed)
	
	infos.hide()
	tutorial_msg.show()
	
	progress_bar_hp.max_value = Data.MAX_HP
	progress_bar_hp.step = 1

	init_stats()



func update_health():
	var msg : String = "%s / %s" % [roundi(Data.hp), roundi(Data.MAX_HP)]
	health_text.text = msg
	
	progress_bar_hp.value = Data.hp


func enable_mash_button():
	#song_by_keys.show()
	mash_button_module.set_enabled()



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_to_target") :
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


func _on_health_changed():
	progress_bar_hp.value = Data.hp
	update_health()
	health_changed_shake_ui()


func _on_crew_changed(value : int):
	var idx = Data.crew
	
	#Reset might not be needed
	for c in crew_array:
		c.value = 0
		
	for i in idx:
		crew_array[i].value = 1
	
	crew_changed_shake_ui()


func crew_changed_shake_ui():
	anim_infos.play("loose_crew")
func health_changed_shake_ui():
	anim_infos.play("loose_health")


func _on_has_reached_goal():
	infos.hide()
	reached_goal_msg.show()
	has_reached_goal = true
	update_stats()


func update_stats():
	$ReachedGoal_Msg/Panel/VBoxContainer2/Crew_Rescue/RT_Crew.text = str(Data.crew_collected) 
	$ReachedGoal_Msg/Panel/VBoxContainer2/Crew_Lost/RT_Crew_Lost.text = str(Data.crew_lost) 
	$ReachedGoal_Msg/Panel/VBoxContainer2/Flotsam/RT_Flotsam.text = str(Data.flotsam_collected) 
	$ReachedGoal_Msg/Panel/VBoxContainer2/Siren_Defeated/RT_Siren_Def.text = str(Data.siren_defeated) 
	$ReachedGoal_Msg/Panel/VBoxContainer2/Siren_Lost/RT_Siren_Lost.text = str(Data.siren_lost) 
	$ReachedGoal_Msg/Panel/VBoxContainer2/Oil_Hit/RT_Oil.text = str(Data.oil_hit) 
	$ReachedGoal_Msg/Panel/VBoxContainer2/Time_Taken/RT_Time_Taken.text = str(Data.time_taken_seconds)


func update_crew():
	for i in Data.crew:
		crew_array[i].value = 1


func show_game_over_screen():
	mash_button_module.hide()
	tutorial_msg.hide()
	reached_goal_msg.hide()
	infos.hide()
	
	game_over.show()


func _on_button_quit_pressed() -> void:
	EvBus.emit_signal("game_over")
	#TODO:give control to gameRoot
	get_tree().quit()


func _on_button_retry_pressed() -> void:
	EvBus.emit_signal("restart_game")


func _on_goal_button_pressed() -> void:
	EvBus.emit_signal("restart_game")
