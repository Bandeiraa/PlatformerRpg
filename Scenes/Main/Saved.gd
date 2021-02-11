extends Node

const FILE_NAME = "res://save_data.save"

#Default Values
var position = Vector2() 
var key = false
var health = 5 
var coins = 0
var currentGameLevel = 1
var currentPlayerLevel = 1
var currentExpBarValue = 0
var coinOffset = 0
var storedIndex = 0
var coinSizeAux = 0
var spikesSizeAux = 0
var storedSpikeIndex = 0
var storedSkeletonIndex = 0
var storedCoins = []
var storedSpikes = []
var storedSkeletons = []

var storedData = {
	"key": key,
	"currentExpBarValue": currentExpBarValue,
	"currentPlayerLevel": currentPlayerLevel,
	"storedSkeletonIndex": storedSkeletonIndex,
	"storedSpikeIndex": storedSpikeIndex,
	"spikesSizeAux": spikesSizeAux,
	"coinSizeAux": coinSizeAux,
	"storedIndex": storedIndex,
	"coinOffset": coinOffset,
	"storedSpikes": storedSpikes,
	"storedCoins": storedCoins,
	"storedSkeletons": storedSkeletons,
	"coins": coins,
	"pos_x": position.x,
	"pos_y": position.y,
	"current_health": health,
	"currentGameLevel": currentGameLevel
}

func save():
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(storedData))
	file.close()
	
	
func loadData():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			storedData = data
		else:
			printerr("Error")
	else:
		printerr("No saved data!")
