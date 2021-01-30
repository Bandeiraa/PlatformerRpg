extends Node2D

var levelSize
var levelSizeAux
var lives = 100
var maxHealth = 100
var spikeDamage = 20
var coin = 0
var decreaseCount = 0
var currentLevel = 1
var aux = 0
var key = false; var auxKey = true
var coinsList = []
var spikesList = []
var file = File.new()


onready var spikes = get_node("Spikes")
onready var skeletons = get_node("Skeletons")
onready var coins = get_node("Coins")
onready var auto_save = get_node("AutoSave")

onready var spikesInstanced = preload("res://Scenes/Enemies/ScenarioEnemies/Spikes.tscn")
onready var coinsInstanced = preload("res://Scenes/Environments/Coin.tscn")
onready var skeletonsInstanced = preload("res://Scenes/Enemies/WalkEnemies/Skeleton.tscn")

signal damage_taken
signal death_animation

func _ready():
	auto_save.start()
	add_to_group("Gamecomponents")
	levelSize = Vector2(5000 * currentLevel, 0)
	levelSizeAux = Vector2(5000 * currentLevel, 0)
	if(file.file_exists("res://save_data.save")):
		loadPlayerPosition()
		loadCoinsPosition()
		loadSpikesPosition()
		lives = Saved.storedData.health
		coin = Saved.storedData.coins
		update_GUI()
	else:
		randomize()
		spawnCoins()
		spawnSpikes()
		spawnSkeletons()
		
		
#SPAWN OBJECTS
func spawnCoins():
	var coinList = [1, 2, 4, 5, 8, 10]
	var coins_Spawner = randi() % coinList.size() * currentLevel
	var coinsOffset = levelSize.x/coinList[coins_Spawner]
	Saved.storedData.coinOffset = coinsOffset
	Saved.save()
	for j in coinList[coins_Spawner]:
		var coinSpawn = coinsInstanced.instance()
		coins.add_child(coinSpawn)
		coinSpawn.position = Vector2(coinsOffset * (j + 1), 154)
		coinsList.append(coinSpawn.position)
		
		
func spawnSpikes():
	var spikes_Spawner = (randi() % 15 * currentLevel) + 1 
	var spikesOffset = levelSize.x/spikes_Spawner
	for i in spikes_Spawner:
		var spikeSpawn = spikesInstanced.instance()
		spikes.add_child(spikeSpawn)
		spikeSpawn.position = Vector2(spikesOffset * i, 184)
		spikesList.append(spikeSpawn.position)
		
		
func spawnSkeletons():
	var skeletons_Spawner = (randi() % 10 * currentLevel) + 1
	var skeletonsOffset = levelSize.x/skeletons_Spawner
	for i in skeletons_Spawner:
		var skeletonSpawn = skeletonsInstanced.instance()
		skeletons.add_child(skeletonSpawn)
		skeletonSpawn.position = Vector2(skeletonsOffset * (i + 1), 160)
		print(skeletonSpawn.position)
		

#LOAD FUNCTIONS
func loadPlayerPosition():
	Saved.loadData()
	var playerPosition = Vector2(Saved.storedData.pos_x, Saved.storedData.pos_y)
	$Player.set_position(playerPosition)
	
	
func loadCoinsPosition():
	var coinSizeAux
	var currentCoinSize
	var coinOffset
	coinsList = Saved.storedData.storedCoins
	Saved.storedData.storedIndex += 1
	Saved.save()
	if Saved.storedData.storedIndex <= 1:
		coinSizeAux = coinsList.size()
		currentCoinSize = coinsList.size()
		Saved.storedData.coinSizeAux = coinSizeAux
		Saved.save()
	else:
		currentCoinSize = coinsList.size()
	Saved.loadData()
	coinOffset = levelSize.x/Saved.storedData.coinSizeAux
	print("Coin Offset", coinOffset)
	print("Current Coin Size: ", currentCoinSize)
	print("Level Size: ", levelSize.x)
	for _i in range (levelSize.x, levelSize.x - (coinOffset * currentCoinSize), -coinOffset):
		levelSize.x -= coinOffset
		var coinSpawn = coinsInstanced.instance()
		coins.add_child(coinSpawn)
		coinSpawn.position = Vector2(levelSize.x, 154)
		print(coinSpawn.position)
	
	
func loadSpikesPosition():
	spikesList = Saved.storedData.storedSpikes
	Saved.storedData.storedSpikeIndex += 1
	Saved.save()
	var spikeSizeAux
	var currentSpikeSize
	var spikeOffset
	if Saved.storedData.storedSpikeIndex <= 1:
		spikeSizeAux = spikesList.size()
		currentSpikeSize = spikesList.size()
		Saved.storedData.spikesSizeAux = spikeSizeAux
		Saved.save()
	else:
		currentSpikeSize = spikesList.size()
	Saved.loadData()
	spikeOffset = levelSizeAux.x/Saved.storedData.spikesSizeAux
	for _j in range (levelSizeAux.x, levelSizeAux.x - (spikeOffset * currentSpikeSize), -spikeOffset):
		levelSizeAux.x -= spikeOffset
		var spikeSpawn = spikesInstanced.instance()
		spikes.add_child(spikeSpawn)
		spikeSpawn.position = Vector2(levelSizeAux.x, 184)
		
		
#UPDATE INTERFACE HUD
func update_GUI():
	get_tree().call_group("GUI", "update_GUI", lives, coin)
	
	
#DAMAGE TAKEN
func hurt():
	lives -= spikeDamage
	update_GUI()
	emit_signal("damage_taken")
	if lives <= 0:
		emit_signal("death_animation")
		
		
#GAME OVER SCREEN
func game_over():
	if(file.file_exists("res://save_data.save")):
		var directory = Directory.new()
		directory.remove("res://save_data.save")
	get_tree().quit()


#AUTOSAVE DATA ON EVERY 10 SECONDS
func _on_AutoSave_timeout():
	var player_position = $Player.get_position()
	print("Saved! current position: ", player_position)
	Saved.storedData.pos_x = player_position.x
	Saved.storedData.pos_y = 164
	Saved.storedData.coins = coin
	Saved.storedData.health = lives
	Saved.storedData.storedCoins = coinsList
	Saved.storedData.storedSpikes = spikesList
	Saved.save()
	
	
#INCREASE COINS COUNT
func increase_coins():
	if coinsList.empty() == true:
		pass
	else:
		coinsList.remove(0)
		coin += randi() % 7 + 3
		update_GUI()
		print(coinsList)
