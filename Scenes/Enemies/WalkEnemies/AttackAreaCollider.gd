extends Area2D

onready var rootParent = get_node("../..")

func _on_AttackAreaCollider_body_entered(_body):
	randomize()
	rootParent.skeleton_damage = randi() % 3 + 1
	get_tree().call_group("Player", "hurt", rootParent.skeleton_damage)
