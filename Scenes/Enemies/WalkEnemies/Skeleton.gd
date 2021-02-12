extends KinematicBody2D

onready var animator = get_node("Animator")
onready var damagePopup = preload("res://DamagePopup.tscn")

signal dead

export (int) var skeleton_health = 5 
export (Vector2) var skeleton_velocity = Vector2(10, 0)

var playerPosition = Vector2.ZERO
var playerDamage = 0
var skeleton_damage

var deathKey = false
var key = false
var stateFlag = false

#IF EXISTENT, PERSIST UPGRADED SKELETONS(BASED ON GAME LEVEL)
func _ready():
	animator.play("Idle")
	Saved.loadData()
	skeleton_health = skeleton_health * Saved.storedData.currentGameLevel
	
	
#SKELETON MOVEMENT
func _physics_process(_delta):
	playerPosition = get_node("../..").get_child(0).get_position()
	var _sliding
	if key == true:
		_sliding = move_and_slide(-skeleton_velocity)
		
		
#FLAGS TO MOVE
func IdleWalk():
	key = true
	
	
#RECURSIVE CALL
func on_Animation_Finished():
	if deathKey == false:
		if stateFlag == true:
			IdleWalk()
			animator.play("Walk")
			stateFlag = false
		else:
			animator.play("AttackAnim")
			get_node("AttackArea2D").instance_Collider()
	else:
		print("Aqui")
		
		
func idleCall():
	key = false
	
	
#VERIFY PLAYER POSITION BASED ON SKELETON POSITION
func current_Body_Position():
	get_node("AttackArea2D").attack_area.position = Vector2(-30, 0)


#DAMAGE AND DEATH
func hurt():
	playerDamage = get_node("../..").get_child(0).player_damage
	skeleton_health -= playerDamage
	var text = damagePopup.instance()
	text.amount = playerDamage
	add_child(text)
	print(skeleton_health)
	if skeleton_health <= 0:
		deathKey = true
		#$AlertArea2D/CollisionShape2D.queue_free()
		#$ChaseArea2D/CollisionShape2D.queue_free()
		can_kill_enemy()
		
		
func can_kill_enemy():
	$DamageTakenArea2D/CollisionShape2D.queue_free()
	$CollisionShape2D.queue_free()
	randomize()
	var random_exp = randi() % 10 + 1
	emit_signal("dead", random_exp)
	animator.play("DeathAnim")
	yield(get_tree().create_timer(1.0), "timeout")
	queue_free()
	
	
func on_Death_Animation_Finished():
	queue_free()
