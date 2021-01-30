extends KinematicBody2D

var motion = Vector2()
var sliding 

const SPEED = 80
const JUMP_SPEED = 350
const GRAVITY = 25
const FLOOR_DIRECTION = Vector2.UP

signal animation
signal death
signal took_damage

func _physics_process(_delta):
	apply_gravity()
	jump()
	move()
	animate()
	sliding = move_and_slide(motion, FLOOR_DIRECTION) #Motion = Linear Velocity
	
	
func move():
	if Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
		motion.x = -SPEED #Negative Speed <<<<
	elif Input.is_action_pressed("Right") and not Input.is_action_pressed("Left"):
		motion.x = SPEED #Positive Speed >>>>
	else:
		motion.x = 0
		
		
func jump():
	if Input.is_action_pressed("Jump") and is_on_floor():
		motion.y -= JUMP_SPEED
		#print(motion)
		
		
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


func _on_Level_death_animation():
	emit_signal("death")


func _on_Level_damage_taken():
	emit_signal("took_damage")
