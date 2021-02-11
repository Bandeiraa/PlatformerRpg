extends Area2D

onready var parent = get_parent()

#CHASE HIM
func _on_ChaseArea2D_body_entered(_body):
	parent.current_Body_Position()
	parent.IdleWalk()
	parent.animator.play("Walk")


func _on_ChaseArea2D_body_exited(body):
	get_parent().get_node("AlertArea2D")._on_AlertArea2D_body_entered(body)
