extends Node2D

var coin = 0
var decreaseCount = 0
var aux = 0
var key = false; var auxKey = true
var coinsList = []
var spikesList = []
var skeletonsList = []
var file = File.new()

onready var spikes = get_node("Spikes")
onready var skeletons = get_node("Skeletons")
onready var coins = get_node("Coins")
onready var auto_save = get_node("AutoSave")

onready var spikesInstanced = preload("res://Scenes/Enemies/ScenarioEnemies/Spikes.tscn")
onready var coinsInstanced = preload("res://Scenes/Environments/Coin.tscn")
onready var skeletonsInstanced = preload("res://Scenes/Enemies/WalkEnemies/Skeleton.tscn")

func _ready():
	loadData()
	auto_save.start()
	add_to_group("Gamecomponents")
	if(file.file_exists("res://save_data.save")):
		loadPlayerPosition()
		loadCoinsPosition()
		loadSpikesPosition()
		loadSkeletonsPosition()
		#lives = Saved.storedData.health
		coin = Saved.storedData.coins
	else:
		randomize()
		spawnCoins()
		spawnSpikes()
		spawnSkeletons()
		
		
#SPAWN OBJECTS
func spawnCoins():
	var levelSize = Vector2(5000 * Saved.storedData.currentGameLevel, 0)
	var coinList = [1, 2, 4, 5, 8, 10]
	var coins_Spawner = randi() % coinList.size() * Saved.storedData.currentGameLevel
	var coinsOffset = levelSize.x/coinList[coins_Spawner]
	Saved.storedData.coinOffset = coinsOffset
	Saved.save()
	for j in coinList[coins_Spawner]:
		var coinSpawn = coinsInstanced.instance()
		coins.add_child(coinSpawn)
		coinSpawn.position = Vector2(coinsOffset * (j + 1), 154)
		coinsList.append(coinSpawn.position)
		
		
func spawnSpikes():
	var levelSize = Vector2(5000 * Saved.storedData.currentGameLevel, 0)
	var spikes_Spawner = (randi() % 15 * Saved.storedData.currentGameLevel) + 1 
	var spikesOffset = levelSize.x/spikes_Spawner
	for i in spikes_Spawner:
		var spikeSpawn = spikesInstanced.instance()
		spikes.add_child(spikeSpawn)
		spikeSpawn.position = Vector2(spikesOffset * i, 184)
		spikesList.append(spikeSpawn.position)
		
		
func spawnSkeletons():
	var levelSize = Vector2(5000 * Saved.storedData.currentGameLevel, 0)
	var skeletonList = [4, 5, 8, 10]
	var skeletons_Spawner = (randi() % skeletonList.size() * Saved.storedData.currentGameLevel)
	var skeletonsOffset = levelSize.x/skeletonList[skeletons_Spawner]
	for i in skeletonList[skeletons_Spawner]:
		var skeletonSpawn = skeletonsInstanced.instance()
		skeletons.add_child(skeletonSpawn)
		skeletonSpawn.position = Vector2(skeletonsOffset * (i + 1), 160)
		skeletonsList.append(skeletonSpawn.position)
		print(skeletonSpawn.position)
		skeletonSpawn.connect("dead", self, "skeletonExp")

#LOAD FUNCTIONS
func loadPlayerPosition():
	Saved.loadData()
	var playerPosition = Vector2(Saved.storedData.pos_x, Saved.storedData.pos_y)
	$Player.set_position(playerPosition)
	
	
func loadCoinsPosition():
	var levelSize = Vector2(5000 * Saved.storedData.currentGameLevel, 0)
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
	for _i in range (levelSize.x, levelSize.x - (coinOffset * currentCoinSize), -coinOffset):
		levelSize.x -= coinOffset
		var coinSpawn = coinsInstanced.instance()
		coins.add_child(coinSpawn)
		coinSpawn.position = Vector2(levelSize.x, 154)
	
	
func loadSpikesPosition():
	var levelSize = Vector2(5000 * Saved.storedData.currentGameLevel, 0)
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
	spikeOffset = levelSize.x/Saved.storedData.spikesSizeAux
	for _j in range (levelSize.x, levelSize.x - (spikeOffset * currentSpikeSize), -spikeOffset):
		levelSize.x -= spikeOffset
		var spikeSpawn = spikesInstanced.instance()
		spikes.add_child(spikeSpawn)
		spikeSpawn.position = Vector2(levelSize.x, 184)
		
		
func loadSkeletonsPosition():
	var levelSize = Vector2(5000 * Saved.storedData.currentGameLevel, 0)
	skeletonsList = Saved.storedData.storedSkeletons
	Saved.storedData.storedSkeletonIndex += 1
	Saved.save()
	var skeletonSizeAux
	var currentSkeletonsSize
	var skeletonOffset
	if Saved.storedData.storedSkeletonIndex <= 1:
		skeletonSizeAux = skeletonsList.size()
		currentSkeletonsSize = skeletonsList.size()
		Saved.storedData.spikesSizeAux = skeletonSizeAux
		Saved.save()
	else:
		currentSkeletonsSize = skeletonsList.size()
	Saved.loadData()
	skeletonOffset = levelSize.x/Saved.storedData.spikesSizeAux
	levelSize.x += skeletonOffset
	for _j in range (levelSize.x, levelSize.x - (skeletonOffset * currentSkeletonsSize), -skeletonOffset):
		levelSize.x -= skeletonOffset
		var skeletonSpawn = skeletonsInstanced.instance()
		skeletons.add_child(skeletonSpawn)
		skeletonSpawn.position = Vector2(levelSize.x, 160)
		print(skeletonSpawn.position)
	pass
	

	
	
#GAME OVER SCREEN
func game_over():
	if(file.file_exists("res://save_data.save")):
		var directory = Directory.new()
		directory.remove("res://save_data.save")
	get_tree().quit()


#AUTOSAVE DATA ON EVERY 10 SECONDS
func _on_AutoSave_timeout():
	var player_position = $Player.get_position()
	#print("Saved! current position: ", player_position)
	Saved.storedData.pos_x = player_position.x
	Saved.storedData.pos_y = 164
	Saved.storedData.coins = coin
	#Saved.storedData.health = lives
	Saved.storedData.storedCoins = coinsList
	Saved.storedData.storedSpikes = spikesList
	Saved.storedData.storedSkeletons = skeletonsList
	Saved.save()
	#print("Coins: ", coin)
	
	
#INCREASE COINS COUNT
func increase_coins():
	if coinsList.empty() == true:
		pass
	else:
		coinsList.remove(0)
		coin += randi() % 7 + 3
		get_tree().call_group("GUI", "update_COIN", coin)
		
		
func skeletonExp(exp_received):
	$Player.on_exp_received(exp_received)
	update_EXP(exp_received)
	
	
func update_EXP(exp_received):
	get_tree().call_group("GUI", "update_EXP", exp_received)


func loadData():
	Saved.loadData()
