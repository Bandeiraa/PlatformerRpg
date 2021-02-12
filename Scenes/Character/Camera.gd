extends Camera2D

var magnitude = 0
var timeleft = 0
var isShaking = false

func _ready():
	pass
	
func shake(newMagnitude, lifetime):
	if magnitude > newMagnitude: return
	
	magnitude = newMagnitude
	timeleft = lifetime
	
	if isShaking: return
	isShaking = true
	
	while timeleft > 0:
		var pos = Vector2()
		pos.x = rand_range(-magnitude, magnitude)
		pos.y = rand_range(-magnitude, magnitude)
		set_position(pos)
		
		timeleft -= get_process_delta_time()
		yield(get_tree(), "idle_frame")
		
	magnitude = 0
	isShaking = false
	set_position(Vector2(0, 0))
	pass
