extends CanvasLayer

@onready var hp: ProgressBar = %ProgressBar_Hp
@onready var crew: TextureProgressBar = %TextureProgressBar_Crew


func _ready() -> void:
	hp.max_value = Data.MAX_HP
	hp.value = Data.hp
	hp.step = .1
	
	crew.max_value = Data.MAX_CREW
	crew.value = Data.crew
	crew.step = 1


func _on_health_changed(value : int):
	hp.value = value


func _on_crew_changed(value : int):
	crew.value = value
