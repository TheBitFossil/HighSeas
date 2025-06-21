extends Node

var has_reached_goal : bool = false

const MAX_HP : float = 100.0
var hp : float = 40.0

const  MAX_CREW : float = 5
var crew : int = 3

# Stats
var crew_collected : int = 0
var crew_lost : int = 0
var flotsam_collected : int = 0
var siren_defeated : int = 0
var siren_lost : int = 0
var oil_hit : int = 0
var time_taken_seconds : int = 0



func reach_goal():
	has_reached_goal = true


func remove_hp(val : int):
	hp -= abs(val)
	if hp <= 0:
		EvBus.emit_signal("game_over")
	
	EvBus.emit_signal("health_changed")


func add_hp(val : int):
	hp += abs(val)
	if hp >= MAX_HP:
		hp = MAX_HP
	EvBus.emit_signal("health_changed")


func reset_goal():
	has_reached_goal = false


func add_crew(val : int):
	crew += val
	if crew > MAX_CREW:
		crew = MAX_CREW
	EvBus.emit_signal("crew_changed", crew)
	crew_collected += 1


func remove_crew():
	crew -= 1
	if crew <= 0:
		crew = 0
	EvBus.emit_signal("crew_changed", crew)
	crew_lost += 1


func add_flotsam():
	flotsam_collected += 1


func add_oil():
	oil_hit += 1

func add_siren_defeat():
	siren_defeated += 1

func add_siren_lost():
	siren_lost += 1
