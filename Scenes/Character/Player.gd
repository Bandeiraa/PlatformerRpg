extends KinematicBody2D

#onready var joystick = get_parent().get_node("HUD").get_node("Joystick/Joystick_button")#get_node("Joystick")#.get_node("HUD").
onready var damagePopup = preload("res://DamagePopup.tscn")
var motion = Vector2()
var sliding 

var player_damage = 1
var level = 1
var total_lvl_exp = 10
var current_exp = 0

export var life = 100
var statusList = [player_damage, life]

const SPEED = 80
const JUMP_SPEED = 350
const GRAVITY = 25
const FLOOR_DIRECTION = Vector2.UP

signal hurt
signal animation
signal death
signal took_damage

func _ready():
	Saved.loadData()
	life = Saved.storedData.current_health
	player_damage = Saved.storedData.player_damage
	
	
func _physics_process(_delta):
	apply_gravity()
	jump()
	move()
	animate()
	sliding = move_and_slide(motion, FLOOR_DIRECTION) #Motion = Linear Velocity
	#Vector2(joystick.get_value().x * 100, motion.y)
	
	
func move():
	if Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
		motion.x = -SPEED #Negative Speed <<<<
	elif Input.is_action_pressed("Right") and not Input.is_action_pressed("Left"):
		motion.x = SPEED #Positive Speed >>>>
	else:
		#motion.x = joystick.get_value().x
		motion.x = 0
		
		
func jump():
	if Input.is_action_pressed("Jump") and is_on_floor():
		motion.y -= JUMP_SPEED
		print(motion)
		
		
func apply_gravity():
	if is_on_floor() and motion.y > 0:
		motion.y = 0
	else:
		motion.y += GRAVITY
		
	
func animate():
	emit_signal("animation", motion) #Call Signal Function on Animated Sprite Scene


func _on_AnimatedSprite_kill_process():
	set_physics_process(false)


func _on_AnimatedSprite_revive_process():
	set_physics_process(true)


func _on_Level_damage_taken():
	emit_signal("took_damage")
	
	
func on_exp_received(exp_received):
	print(exp_received)
	current_exp += exp_received 
	total_lvl_exp = (10 * level) * 1.5
	if total_lvl_exp <= current_exp:
		level_up()
		
		
func level_up():
	randomize()
	var statusChoosen = randi() % statusList.size()
	if statusList[statusChoosen] <= 1:
		player_damage += randi() % 3 + 1
	else:
		life += 5
	level += 1
	Saved.storedData.currentPlayerLevel = level
	Saved.storedData.player_damage = player_damage
	Saved.storedData.current_health = life
	Saved.save()
	current_exp = 0
	print("Upou! Nível atual: ", level)
	print("Vida atual: ", life)
	print("Ataque atual: ", player_damage)
	
	
func hurt(damage):
	$Animator.play("DamageTaken")
	position -= Vector2(3, 0)
	emit_signal("hurt")
	$Camera.shake(25, 0.2)
	life -= damage
	var text = damagePopup.instance()
	text.amount = damage
	add_child(text)
	print("Perdeu ", damage, " de vida! Vida atual: ", life)
	get_tree().call_group("GUI", "update_GUI", life)
	if life <= 0:
		emit_signal("death")


func _on_SendAttackDamage():
	print("Ataque causado: ", player_damage)
	return player_damage
	

func _on_AnimatedSprite_sendGameover():
	$CollisionShape2D.queue_free()
