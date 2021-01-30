extends Node

const FILE_NAME = "res://save_data.save"

#Default Values
var position = Vector2() 
var health = 5 
var coins = 0
var coinOffset = 0
var storedIndex = 0
var coinSizeAux = 0
var spikesSizeAux = 0
var storedSpikeIndex = 0
var storedCoins = []
var storedSpikes = []

var storedData = {
	"storedSpikeIndex": storedSpikeIndex,
	"spikesSizeAux": spikesSizeAux,
	"coinSizeAux": coinSizeAux,
	"storedIndex": storedIndex,
	"coinOffset": coinOffset,
	"storedSpikes": storedSpikes,
	"storedCoins": storedCoins,
	"coins": coins,
	"pos_x": position.x,
	"pos_y": position.y,
	"current_health": health
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
