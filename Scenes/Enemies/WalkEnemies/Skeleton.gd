extends KinematicBody2D

onready var animator = get_node("Animator")
onready var attack_area = get_node("AttackArea2D/AttackAreaCollider")
onready var collider = preload("res://Scenes/Enemies/WalkEnemies/CollisionShape2D.tscn")

signal dead

export (int) var skeleton_health = 5
export (Vector2) var skeleton_velocity = Vector2(10, 0)

var playerPosition = Vector2.ZERO
var collision
var skeleton_damage
var leftKey = false
var rightKey = false
var stateFlag = false

#SKELETON MOVEMENT
func _physics_process(_delta):
	playerPosition = get_node("../..").get_child(0).get_position()
	var _sliding
	if leftKey == true:
		rightKey = false
		_sliding = move_and_slide(-skeleton_velocity)
	if rightKey == true:
		leftKey = false
		_sliding = move_and_slide(+skeleton_velocity)


#SKELETON DAMAGE TAKEN AREA
func _on_Area2D_area_entered(_area):
	idleCall()
	animator.play("DmgTakenAnim")
	skeleton_health -= 1
	$AnimatedSprite.offset = Vector2(-8, 0)
	if skeleton_health == 0:
		$CollisionArea2D/CollisionShape2D.queue_free()
		randomize()
		var random_exp = randi() % 10 + 1
		emit_signal("dead", random_exp)
		animator.play("DeathAnim")
		
		
#ENEMY BODY ENTERED(STAY IN ALERT)
func _on_Area2D_body_entered(_body):
	current_Body_Position()
	animator.play("GlareAnim")
	idleCall()
	
	
#ENEMY BODY ENTERED(CHASE HIM)
func _on_ChaseArea2D_body_entered(_body):
	current_Body_Position()
	animator.play("Walk")
	
	
#ENEMY BODY ENTERED(ATTACK HIM)
func _on_AttackArea2D_body_entered(_body):
	animator.play("AttackAnim")
	if playerPosition <= position:
		$AnimatedSprite.offset = Vector2(-18, -2.6)
		idleCall()
		instance_Collider()
	else:
		$AnimatedSprite.offset = Vector2(3, -2.6)
		idleCall()
		instance_Collider()
		
		
func _on_AttackDuration_timeout():
	remove_Collider()
	
	
func _on_AttackAreaCollider_body_entered(_body):
	randomize()
	skeleton_damage = randi() % 10 + 1
	get_tree().call_group("Gamecomponents", "hurt", skeleton_damage)
	
	
#ENEMY BODY EXITED(CALL IDLE ANIM)
func _on_Area2D_body_exited(_body):
	animator.play("WalkAnim")
	
	
#ENEMY BODY EXITED CHASE AREA(BACK TO ALERT STATE)
func _on_ChaseArea2D_body_exited(body):
	_on_Area2D_body_entered(body)
	
	
func _on_AttackArea2D_body_exited(_body):
	stateFlag = true
	
	
func on_Animation_Finished():
	if stateFlag == true:
		animator.play("Walk")
		stateFlag = false
	else:
		#$AnimatedSprite.offset = Vector2(-18, -2.6)
		animator.play("AttackAnim")
		instance_Collider()
	
	
func on_Death_Animation_Finished():
	queue_free()
	
	
func leftIdleWalk():
	leftKey = true
	
	
func rightIdleWalk():
	rightKey = true
	
	
func idleCall():
	leftKey = false
	rightKey = false


func current_Body_Position():
	if playerPosition <= position:
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.offset = Vector2(-10, 0)
		attack_area.position = Vector2(-30, 0)
		leftIdleWalk()
	else:
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.offset = Vector2(-2.5, 0)
		attack_area.position = Vector2(30, 0)
		rightIdleWalk()
		
		
func instance_Collider():
	$AttackDuration.start()
	yield(get_tree().create_timer(0.5), "timeout")
	collision = collider.instance()
	attack_area.add_child(collision)
	
	
func remove_Collider():
	for n in attack_area.get_children():
		attack_area.remove_child(n)
		pass
