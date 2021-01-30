extends KinematicBody2D

onready var animator = get_node("Animator")
var skeleton_health = 5
var skeleton_velocity = Vector2(10, 0)
var leftKey = false
var rightKey = false

func _ready():
	animator.play("WalkAnim")
	
	
func _physics_process(_delta):
	var _sliding
	if leftKey == true:
		rightKey = false
		_sliding = move_and_slide(-skeleton_velocity)
	if rightKey == true:
		leftKey = false
		_sliding = move_and_slide(+skeleton_velocity)


func _on_Area2D_area_entered(_area):
	leftKey = false
	rightKey = false
	animator.play("DmgTakenAnim")
	skeleton_health -= 1
	if skeleton_health == 0:
		animator.play("DeathAnim")
		
		
func on_Animation_Finished():
	animator.play("WalkAnim")
	
	
func on_Death_Animation_Finished():
	queue_free()
	
	
func leftIdleWalk():
	leftKey = true
	
	
func rightIdleWalk():
	rightKey = true
	
	
func idleCall():
	leftKey = false
	rightKey = false
