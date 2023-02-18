extends Node


const CHUNK_SIZE: int = 32	# Chunk size: 32*32
const CHUNK_DIST: int = 7
const CHUNK_START_DIST: int = 1

func chunk_start(chunk_center: Vector2) -> Vector2:
	return Vector2(chunk_center.x - CHUNK_SIZE / 2, chunk_center.y - CHUNK_SIZE / 2)

func chunk_end(chunk_center: Vector2) -> Vector2:
	return Vector2(chunk_center.x + CHUNK_SIZE / 2, chunk_center.y + CHUNK_SIZE / 2)
