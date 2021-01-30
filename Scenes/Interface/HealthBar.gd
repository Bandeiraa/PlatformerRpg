extends TextureProgress

var decreaseCount = 0
var key = false

func update_GUI(_currentHp):
	$Animator.play("DamageTaken")
	#value = currentHp * 20
	key = true
	
	
func _process(_delta):
	if key == true:
		decreaseCount += 1
		value -= 1
		if decreaseCount == 20:
			decreaseCount = 0
			key = false
