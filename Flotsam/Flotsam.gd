extends Node2D

@export var ship_health : int = 20
#todo add ship health
@export var _is_dangerous := false

@export var explosion_prefab : PackedScene = preload("res://Enemies/VFX_Explosion.tscn")
@export var tweener : PackedScene = preload("res://FloatingMessage.tscn")
var path : Node

var speed : float = 50.0
var is_moving : bool = false


func _ready() -> void:
	path = get_tree().get_first_node_in_group("Explosions")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.has_method("collect_flotsam"):
		return
		
	if _is_dangerous:
		if body.has_method("take_damage"):
			body.take_damage(ship_health)
			Data.add_oil()
			
			var new_explosion = explosion_prefab.instantiate()
			new_explosion.position = global_position
			path.add_child(new_explosion)
			new_explosion.play()
			EvBus.emit_signal("camera_shake")
			#var f_msg = tweener.instantiate()
			#f_msg.position = global_position
			#path.add_child(f_msg)
			#f_msg.show_message_floating_up('[color="Red"]%s Damage Taken[/color]' % [ship_health])
			await get_tree().create_timer(.2).timeout
			call_deferred("queue_free")
	else:
		if body.collect_flotsam(ship_health):
			Data.add_flotsam()
			
			#var f_msg = tweener.instantiate()
			#f_msg.position = global_position
			#path.add_child(f_msg)
			#f_msg.show_message_floating_up('[color="Green"] +1 Flotsam [/color]')
			await get_tree().create_timer(.2).timeout
			call_deferred("queue_free")


func _physics_process(delta: float) -> void:
	if is_moving:
		position.y += speed * delta
