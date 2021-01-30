extends Node2D

func _on_Area2D_body_entered(_body):
	get_tree().call_group("Gamecomponents", "increase_coins")
	queue_free()
