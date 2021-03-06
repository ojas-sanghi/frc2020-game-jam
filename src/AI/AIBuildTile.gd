extends Position2D

export var id: int
export var build_order := 1
export (Enums.game_buildings) var building_to_build = Enums.game_buildings.Shield

var built := false
var player_data: PlayerData
var building_name

func _ready() -> void:
	player_data = PlayersManager.players[id - 1]
	building_name = Enums.game_buildings.keys()[building_to_build]

func can_afford_tile():
	if player_data.can_afford_building(building_name):
		return true

func build_tile():
	if built:
		return false

	if can_afford_tile():
		built = true

		var building_id := BuildingsManager.get_next_id()
		Signals.emit_signal("game_building_placed", building_id, id, building_name, position)
		RPC.send_game_building_placed(building_id, building_name, position)

		return true
