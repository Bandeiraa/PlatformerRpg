extends CanvasLayer

onready var healthBar = get_node("Interface/HealthBar")
onready var healthUnder = get_node("Interface/HealthBarAux")
onready var coinCount = get_node("Interface/CoinCount")
onready var updateTween = get_node("Interface/UpdateTween")

func update_GUI(lives_left, coins):
	healthBar.value = lives_left
	coinCount.text = str(coins)
	updateTween.interpolate_property(healthUnder, "value",healthUnder.value, lives_left, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	updateTween.start()
