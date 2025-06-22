extends CenterContainer


func show_msg(msg : String):
	$RichTextLabel.text = msg


func _on_out_of_screen_feedback_timer_timeout() -> void:
	Data.remove_hp(Data.left_screen_damage)
	#start damage timer
	$OutOfScreenFeedbackTimer.start()
