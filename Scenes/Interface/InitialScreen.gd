extends Control

var changeScene
var can_click = false
var social_media

func _ready():
	var file = File.new()
	if(file.file_exists("res://save_data.save")):
		$ContinueButton.hide()
	else:
		$ContinueButton.hide()
		
	
func _on_NewGame_pressed():
	var directory = Directory.new()
	directory.remove("res://save_data.save")
	$Animator.play("SceneTransition")
	yield(get_tree().create_timer(0.7), "timeout")
	changeScene = get_tree().change_scene("res://Scenes/Main/Level.tscn")
	

func _on_ContinueButton_pressed():
	$Animator.play("SceneTransition")
	yield(get_tree().create_timer(0.7), "timeout")
	changeScene = get_tree().change_scene("res://Scenes/Main/Level.tscn")


func _on_TwitterButton_pressed():
	social_media = OS.shell_open("https://twitter.com/Siskinho2")


func _on_InstagramButton_pressed():
	social_media = OS.shell_open("https://www.instagram.com/davi_bandeira_96/")


func _on_TwitchButton_pressed():
	social_media = OS.shell_open("https://www.twitch.tv/davibandeiraa")


func _on_YoutubeButton_pressed():
	social_media = OS.shell_open("https://www.youtube.com/channel/UCvyBHlurg_4RiSZtu0sOkZA")


func _on_ConfigButton_pressed():
	pass # Replace with function body.
