extends Area2D

onready var collider = preload("res://Scenes/Character/PlayerAttackCollider.tscn")
var collision

func _ready():
	add_to_group("Playerdamage")


func _on_AnimatedSprite_attack():
	yield(get_tree().create_timer(0.2), "timeout")
	collision = collider.instance()
	add_child(collision)
	position = Vector2(-31, 0)
	
	
func _on_AnimatedSprite_rightAttack():
	yield(get_tree().create_timer(0.2), "timeout")
	collision = collider.instance()
	add_child(collision)
	position = Vector2(10, 0)


func _on_AnimatedSprite_attackFinished():
	if get_child_count() >= 1:
		remove_child(collision)
