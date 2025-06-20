extends CanvasLayer

@onready var hp: ProgressBar = %HProgressBar_HP
@onready var crew: ProgressBar = %HProgressBar_Crew


func _ready() -> void:
	hp.max_value = health
	hp.value = health


func _on_health_changed(value : int):
	hp.value = value

func _on_crew_changed(value : int):
	crew.value = value
