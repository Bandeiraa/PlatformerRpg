extends Area2D

onready var parent = get_parent()
 
#STAY IN ALERT
func _on_AlertArea2D_body_entered(_body):
	parent.current_Body_Position()
	parent.animator.play("GlareAnim")
	parent.idleCall()


func _on_AlertArea2D_body_exited(_body):
	parent.animator.play("WalkAnim")
