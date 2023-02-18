extends Node


var ground_noise: OpenSimplexNoise
var ore_noise: OpenSimplexNoise
var forest_noise: OpenSimplexNoise
var details_noise: OpenSimplexNoise

var ysort: YSort

var player: KinematicBody2D
var fox: KinematicBody2D

var floor_tm: TileMap

var world_gen: Node2D
var user_interface: CanvasLayer
var hht_progress: Node2D
var hht = null

var debug_overlay: CanvasLayer

var consumable_engine: Node2D
var building_engine: Node2D
