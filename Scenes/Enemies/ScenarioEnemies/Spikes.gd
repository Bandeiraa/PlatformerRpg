extends Area2D

onready var spikes = ["res://Assets/Sprites/Enemies/ScenarioEnemies/Spike01.png", "res://Assets/Sprites/Enemies/ScenarioEnemies/Spike02.png", "res://Assets/Sprites/Enemies/ScenarioEnemies/Spike03.png"]

var spikeLife = 1
var spike_damage

func _ready():
	randomize()
	var image_Selected = randi() % spikes.size()
	$Sprite.texture = load(spikes[image_Selected])


func _on_Spikes_body_entered(_body):
	randomize()
	spike_damage = randi() % 20 + 1
	get_tree().call_group("Gamecomponents", "hurt", spike_damage)


func _on_Spikes_area_entered(area):
	if area.is_in_group("Playerdamage"):
		spikeLife -= 1
		if spikeLife <= 0:
			queue_free()
