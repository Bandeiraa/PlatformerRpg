extends Control

var changeScene
var can_click = false

func _ready():
	$ContinueButton.disabled = true
	var file = File.new()
	if(file.file_exists("res://save_data.save")):
		$ContinueButton.disabled = false
		$ContinueButton.set("custom_colors/font_color", Color(1, 1, 1, 1))
	else:
		$ContinueButton.set("custom_colors/font_color", Color(0.5, 0.5, 0.5, 1))
		
	
func _on_NewGame_pressed():
	var directory = Directory.new()
	directory.remove("res://save_data.save")
	changeScene = get_tree().change_scene("res://Scenes/Main/Level.tscn")


func _on_ContinueButton_pressed():
	changeScene = get_tree().change_scene("res://Scenes/Main/Level.tscn")
