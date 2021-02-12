extends CanvasLayer

var level = 1
var key = false

onready var healthBar = get_node("Interface/HealthBar")
onready var healthUnder = get_node("Interface/HealthBarAux")

onready var expBar = get_node("ExpInterface/HealthBar")
onready var expUnder = get_node("ExpInterface/HealthBarAux")

onready var updateTweenExp = get_node("ExpInterface/UpdateTween")

onready var coinCount = get_node("Interface/CoinCount")
onready var playerLevel = get_node("ExpInterface/CoinCount")
onready var updateTween = get_node("Interface/UpdateTween")
onready var expProgress = get_node("ExpInterface/ExpProgress")

func _ready():
	Saved.loadData()
	level = Saved.storedData.currentPlayerLevel
	expBar.value = Saved.storedData.currentExpBarValue
	expBar.max_value = (10 * level) * 1.5 
	playerLevel.text = "Level: " + str(level)
	expProgress.text = str(expBar.value) + "/" + str(expBar.max_value)
	update_GUI(Saved.storedData.current_health)
	
func update_GUI(lives_left):
	healthBar.value = lives_left
	updateTween.interpolate_property(healthUnder, "value", healthUnder.value, lives_left, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	updateTween.start()
	
	
func update_COIN(coins):
	coinCount.text = str(coins)


func update_EXP(exp_taken):
	expBar.value += exp_taken
	print("Exp Atual: ", expBar.value)
	expProgress.text = str(expBar.value) + "/" + str(expBar.max_value)
	if expBar.value >= expBar.max_value:
		level += 1
		playerLevel.text = "Level: " + str(level)
		expBar.value = 0
		expBar.max_value = (10 * level) * 1.5 
		print("Valor maximo de nivel: ",expBar.max_value)
		expProgress.text = str(expBar.value) + "/" + str(expBar.max_value)
	#updateTweenExp.interpolate_property(expUnder, "value", expUnder, exp_taken, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#updateTweenExp.start()


func _on_Level_save_level_info():
	Saved.storedData.currentPlayerLevel = level
	print("Valor Salvo: ", expBar.value)
	Saved.storedData.currentExpBarValue = expBar.value
	Saved.storedData.current_health = healthBar.value
	Saved.save()


func _on_AnimatedSprite_sendGameover():
	$Animator.play("Gameover")


func _on_TryAgainButton_pressed():
	$Animator.play("FadeScreen")
	#var directory = Directory.new()
	Saved.storedData.currentPlayerLevel = 1
	Saved.storedData.coins = 0
	Saved.storedData.currentGameLevel = 1
	Saved.storedData.currentExpBarValue = 0
	Saved.storedData.current_health = 50
	Saved.storedData.player_damage = 1
	Saved.save()
	yield(get_tree().create_timer(0.7), "timeout")
	var _reload = get_tree().reload_current_scene()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_Player_hurt():
	$Animator.play("hurt")
