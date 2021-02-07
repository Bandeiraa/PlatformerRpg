extends Area2D

onready var parent = get_parent()

#DAMAGE TAKEN
func _on_DamageTakenArea2D_area_entered(_area):
	parent.idleCall()
	parent.animator.play("DmgTakenAnim")
	parent.get_node("AnimatedSprite").offset = Vector2(-8, 0)
	parent.hurt()
