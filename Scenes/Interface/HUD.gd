extends CanvasLayer

var level = 1

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
	playerLevel.text = "Level: " + str(level)
	expProgress.text = "0/10"
	
	
func update_GUI(lives_left):
	healthBar.value = lives_left
	updateTween.interpolate_property(healthUnder, "value", healthUnder.value, lives_left, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	updateTween.start()
	
	
func update_COIN(coins):
	coinCount.text = str(coins)


func update_EXP(exp_taken):
	expBar.value += exp_taken
	expProgress.text = str(expBar.value) + "/" + str(expBar.max_value)
	if expBar.value >= expBar.max_value:
		level += 1
		playerLevel.text = "Level: " + str(level)
		expBar.value = 0
		expBar.max_value = (10 * level) * 1.5 
		expProgress.text = str(expBar.value) + "/" + str(expBar.max_value)
	#updateTweenExp.interpolate_property(expUnder, "value", expUnder, exp_taken, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	#updateTweenExp.start()
