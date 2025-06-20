extends CanvasLayer




@onready var mash_button_module: Control = %MashButton_Module
@onready var song_by_keys: VBoxContainer = $Action_Event_Resist_Siren_Song/Song_By_Keys














func enable_mash_button():
	#song_by_keys.show()
	mash_button_module.set_enabled()
