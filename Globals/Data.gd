extends Node

var has_reached_goal : bool = false

const MAX_HP : float = 1
var hp : int = 1

const  MAX_CREW : float = 5
var crew : int = 5



func reach_goal():
	has_reached_goal = true


func reset_goal():
	has_reached_goal = false


func add_crew(val : int):
	crew += val
	if crew > MAX_CREW:
		crew = MAX_CREW
	EvBus.emit_signal("crew_changed", crew)


func remove_crew():
	crew -= 1
	if crew <= 0:
		crew = 0
	EvBus.emit_signal("crew_changed", crew)
