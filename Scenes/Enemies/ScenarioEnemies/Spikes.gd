extends Area2D

onready var spikes = ["res://Assets/Sprites/Enemies/ScenarioEnemies/Spike01.png", "res://Assets/Sprites/Enemies/ScenarioEnemies/Spike02.png", "res://Assets/Sprites/Enemies/ScenarioEnemies/Spike03.png"]

var spikeLife = 1

func _ready():
	randomize()
	var image_Selected = randi() % spikes.size()
	$Sprite.texture = load(spikes[image_Selected])


func _on_Spikes_body_entered(_body):
	get_tree().call_group("Gamecomponents", "hurt")


func _on_Spikes_area_entered(area):
	if area.is_in_group("Playerdamage"):
		spikeLife -= 1
		if spikeLife <= 0:
			queue_free()
