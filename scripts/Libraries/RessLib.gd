extends Node

const Rock: Dictionary = {
	"name": "Rock",
	"local_position": Vector2(0, 0),
	"placeable": [ConstLib.DIRT, ConstLib.SAND],
	"spawn_rate": 25,
	"biome": ["Mountain", "Plain", "River", "Forest"],
	"textures": [
		"res://assets/ressources/rock_01_16x16.png",
		"res://assets/ressources/rock_02_16x16.png",
		"res://assets/ressources/rock_03_16x16.png"
	],
	"tile_size": 1,
	"collision": {
		"active": false,
	},
	"area": {
		"tres_path": "res://scenes/Ressources/AreaShape/RockArea.tres",
		"local_position": Vector2(8, 8)
	},
	"tools": ["hand"],
	"drop": 			["Stone"],
	"drop_quantity": 	[1],
	"lucky_drop": 		[2],
	"drop_rate": 		[100]
}

const BigRock: Dictionary = {
	"name": "Big Rock",
	"local_position": Vector2(-16, -22),
	"placeable": [ConstLib.DIRT],
	"spawn_rate": 12,
	"biome": ["Mountain", "Plain"],
	"textures": [
		"res://assets/ressources/big_rock_32x32.png"
	],
	"tile_size": 2,
	"collision": {
		"active": true,
		"tres_path": "res://scenes/Ressources/CollisionShape/BigRockCollision.tres",
		"local_position": Vector2(0, 4),
		"rotation_degrees": 90
	},
	"area": {
		"tres_path": "res://scenes/Ressources/AreaShape/BigRockArea.tres",
		"local_position": Vector2(0, -4)
	},
	"tools": ["pickaxe"],
	"drop": 			["Stone", "Coal"],
	"drop_quantity": 	[2, 1],
	"lucky_drop": 		[3, 0],
	"drop_rate": 		[100, 10]
}

const BigRockCoal: Dictionary = {
	"name": "Big Rock Coal",
	"local_position": Vector2(-16, -22),
	"placeable": [ConstLib.DIRT],
	"spawn_rate": 5,
	"biome": ["Mountain", "Plain"],
	"textures": [
		"res://assets/ressources/big_rock_coal_32x32.png"
	],
	"tile_size": 2,
	"collision": {
		"active": true,
		"tres_path": "res://scenes/Ressources/CollisionShape/BigRockCollision.tres",
		"local_position": Vector2(0, 4),
		"rotation_degrees": 90
	},
	"area": {
		"tres_path": "res://scenes/Ressources/AreaShape/BigRockArea.tres",
		"local_position": Vector2(0, -4)
	},
	"tools": ["pickaxe"],
	"drop": 			["Stone", "Coal"],
	"drop_quantity": 	[1, 2],
	"lucky_drop": 		[0, 3],
	"drop_rate": 		[75, 100]
}

const BigRockIron: Dictionary = {
	"name": "Big Rock Iron",
	"local_position": Vector2(-16, -22),
	"placeable": [ConstLib.DIRT],
	"spawn_rate": 4,
	"biome": ["Mountain", "Plain"],
	"textures": [
		"res://assets/ressources/big_rock_iron_32x32.png"
	],
	"tile_size": 2,
	"collision": {
		"active": true,
		"tres_path": "res://scenes/Ressources/CollisionShape/BigRockCollision.tres",
		"local_position": Vector2(0, 4),
		"rotation_degrees": 90
	},
	"area": {
		"tres_path": "res://scenes/Ressources/AreaShape/BigRockArea.tres",
		"local_position": Vector2(0, -4)
	},
	"tools": ["pickaxe"],
	"drop": 			["Stone", "Iron Ore"],
	"drop_quantity": 	[1, 2],
	"lucky_drop": 		[0, 2],
	"drop_rate": 		[75, 100]
}

const Bush: Dictionary = {
	"name": "Bush",
	"local_position": Vector2(-8, -10),
	"placeable": [ConstLib.DIRT],
	"spawn_rate": 35,
	"biome": ["Forest", "Plain"],
	"textures": [
		"res://assets/ressources/bush_01_16x16.png",
		"res://assets/ressources/bush_02_16x16.png"
	],
	"tile_size": 1,
	"collision": {
		"active": false,
	},
	"area": {
		"tres_path": "res://scenes/Ressources/AreaShape/BushArea.tres",
		"local_position": Vector2(0, -2)
	},
	"tools": ["hand"],
	"drop": 			["Tree Branch", "Cut Grass"],
	"drop_quantity": 	[1, 1],
	"lucky_drop": 		[2, 2],
	"drop_rate": 		[100, 50]
}

const RedBerriesBush: Dictionary = {
	"name": "Red Berries Bush",
	"local_position": Vector2(-8, -10),
	"placeable": [ConstLib.DIRT],
	"spawn_rate": 30,
	"biome": ["Forest", "Plain"],
	"textures": [
		"res://assets/ressources/red_berries_bush_16x16.png"
	],
	"tile_size": 1,
	"collision": {
		"active": false,
	},
	"area": {
		"tres_path": "res://scenes/Ressources/AreaShape/BushArea.tres",
		"local_position": Vector2(0, -2)
	},
	"tools": ["hand"],
	"drop": 			["Tree Branch", "Cut Grass", "Red Berries"],
	"drop_quantity": 	[1, 1, 1],
	"lucky_drop": 		[2, 2, 3],
	"drop_rate": 		[25, 25, 100]
}

const Flower: Dictionary = {
	"name": "Flower",
	"local_position": Vector2(-8, -12),
	"placeable": [ConstLib.DIRT],
	"spawn_rate": 35,
	"biome": ["Forest", "Plain", "River"],
	"textures": [
		"res://assets/flowers/flower_01.png",
		"res://assets/flowers/flower_02.png",
		"res://assets/flowers/flower_03.png",
		"res://assets/flowers/flower_04.png",
		"res://assets/flowers/flower_05.png",
		"res://assets/flowers/flower_06.png",
		"res://assets/flowers/flower_07.png",
	],
	"tile_size": 1,
	"collision": {
		"active": false,
	},
	"area": {
		"tres_path": "res://scenes/Ressources/AreaShape/BushArea.tres",
		"local_position": Vector2(0, -4)
	},
	"tools": ["hand"],
	"drop": 			["Flower"],
	"drop_quantity": 	[1],
	"lucky_drop": 		[0],
	"drop_rate": 		[100]
}

const ENVS: Array = [
	Rock,
	BigRock,
	BigRockCoal,
	BigRockIron,
	Bush,
	RedBerriesBush,
	Flower
]

