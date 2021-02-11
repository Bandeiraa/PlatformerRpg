extends Area2D

onready var collider = preload("res://Scenes/Enemies/WalkEnemies/CollisionShape2D.tscn")
onready var attack_area = get_node("AttackAreaCollider")
onready var parent = get_parent()

var collision

func _on_AttackArea2D_body_entered(_body):
	parent.animator.play("AttackAnim")
	parent.idleCall()
	instance_Collider()


func _on_AttackArea2D_body_exited(_body):
	parent.stateFlag = true
	
	
#SPAWN AND REMOVE ATTACK COLLIDER
func instance_Collider():
	parent.get_node("AttackDuration").start()
	yield(get_tree().create_timer(0.5), "timeout")
	collision = collider.instance()
	attack_area.add_child(collision)
	
	
func remove_Collider():
	for n in attack_area.get_children():
		attack_area.remove_child(n)
		pass


func _on_AttackDuration_timeout():
	remove_Collider()
