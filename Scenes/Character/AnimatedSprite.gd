extends AnimatedSprite

signal kill_process
signal revive_process
signal attack
signal rightAttack
signal attackFinished

var key = false
var deathKey = false
onready var animationPlayer = get_node("AnimationPlayer")
onready var damageAnimator = get_node("Animator")

func _on_Player_Animate(motion):
	if deathKey == false:
		if Input.is_action_just_pressed("Attack"): #ATTACK
			key = true
			randomAttack()
			animationPlayer.play("IdleCall(Attack)")
			emit_signal("kill_process")
			if is_flipped_h() == true:
				emit_signal("attack")
			else:
				emit_signal("rightAttack")
		if motion.y < 0:  #JUMP ^^^
			key = true
			play("Jump")
			animationPlayer.play("IdleCall(Jump)")
		elif motion.x > 0 and key == false: #RIGHT >>>
			set_flip_h(false)
			play("Run")
		elif motion.x < 0 and key == false: #LEFT <<<
			set_flip_h(true)
			play("Run")
		else:
			if key == false:
				play("Idle")
			

func on_Jump_Finished():
	key = false
	play("Idle")
	emit_signal("attackFinished")
	emit_signal("revive_process")
	
	
func randomAttack():
	randomize()
	var randomValue = randi() % 2 + 1
	play("Attack0" + str(randomValue))
	

func _on_Player_death():
	emit_signal("kill_process")
	play("Death")
	animationPlayer.play("DeathFinished")
	deathKey = true
	
	
func game_Over():
	get_tree().call_group("Gamecomponents", "game_over")


func _on_Player_took_damage():
	damageAnimator.play("DamageTaken")
