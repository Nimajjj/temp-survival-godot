extends Node


const WATER: int = 13	# 12: water_sand; 13: wated_grass
const DIRT: int = 8
const SAND: int = 9	
const STONE: int = 18 # 11
const WALL: Array = [
	{	# full wall
		"left": 19,
		"mid": 20,
		"right": 21,
		"alone": 22
	},
	{	# demi wall
		"left": 23,
		"mid": 24,
		"right": 25,
		"alone": 26
	}
]

const VALID_WALL_TILE: Array = [
	Vector2(0, 2), Vector2(1, 0), Vector2(5, 2),	# left
	Vector2(2, 2), Vector2(2, 0), Vector2(6, 2), Vector2(2, 4), Vector2(3, 4),	# mid
	Vector2(1, 2), Vector2(7, 2), Vector2(3, 0),	# right
	Vector2(0, 0), Vector2(4, 2),	# alone
]


const WATER_CAP: float = -25.0
const SAND_CAP: float = -20.0
const DIRT_CAP: float = 25.0
const ROCK_CAP: float = 10000.0
const IRON_CAP: float = 65.0
const COAL_CAP: float = 60.0

const FOREST_CAP: float = 10.0	# 35.0
const FLOWER_CAP: float = 50.0


const MOUNTAIN_COLOR: Color = Color(0.1, 0.1, 0.1, 0.5)
const FOREST_COLOR: Color = Color(0.0, 0.3, 0.0, 0.5)
const PLAIN_COLOR: Color = Color(0.0, 0.6, 0.0, 0.5)
const RIVER_COLOR: Color = Color(0.0, 0.0, 0.5, 0.5)
const FLOWERED_MOUNTAIN_COLOR: Color = Color(0.2, 0.2, 0.2, 0.5)
const FLOWERED_FOREST_COLOR: Color = Color(0.0, 0.4, 0.0, 0.5)
const FLOWERED_PLAIN_COLOR: Color = Color(0.0, 0.7, 0.0, 0.5)
const FLOWERED_RIVER_COLOR: Color = Color(0.0, 0.0, 0.6, 0.5)
