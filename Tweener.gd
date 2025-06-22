extends Node2D

@onready var message_label: RichTextLabel = $MessageLabel
@export var offset_top_right : Vector2 = Vector2(200.0, 200.0)
@export var duration : float = 3.0


func show_message_floating_up(msg : String):
	var tween := get_tree().create_tween()
	tween.tween_property(message_label, "position", position - offset_top_right, duration)
	message_label.text = msg
	await tween.finished.connect(queue_free)
