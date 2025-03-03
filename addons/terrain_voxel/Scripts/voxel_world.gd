@tool
extends Node3D
class_name VoxelWorld


@export var seed: int = 0
@export var frecuency: float = 0.01
var distance_of_rendering: int

@onready var chunks := {}
@onready var noise := FastNoiseLite.new()
@onready var chunk_size: Vector3i = ProjectSettings.get_setting("addons/terrain_voxel/chunk_size")


func _ready() -> void:
	self.distance_of_rendering = ProjectSettings.get_setting("addons/terrain_voxel/distance_of_rendering_in_editor")
	
	self.noise.seed = self.seed
	self.noise.frequency = self.frecuency
	
	init_world()


func init_world() -> void:
	for x in range(-self.distance_of_rendering, self.distance_of_rendering):
		for z in range(-self.distance_of_rendering, self.distance_of_rendering):
			var pos_chunk = Vector2i(x, z)
			
			self.generate_chunk(pos_chunk)
			var chunk = VoxelChunk.new(pos_chunk, self)
			
			add_child(chunk)


func get_chunk(pos_chunk: Vector2i) -> Dictionary:
	return self.chunks[pos_chunk]


func generate_chunk(pos_chunk: Vector2i) -> void:
	var pos: Vector3i
	var result := {}
	
	for x in range(self.chunk_size.x):
		for z in range(self.chunk_size.z):
			for y in range(self.chunk_size.y):
				pos = Vector3i(x, y, z)
				result[pos] = self.get_block(pos, pos_chunk)
	
	self.chunks[pos_chunk] = result


func get_block(pos_block: Vector3i, pos_chunk: Vector2i) -> int:
	var pos = pos_chunk * Vector2i(self.chunk_size.x, self.chunk_size.z)
	var pos_blobal = pos_block + Vector3i(pos.x, 0, pos.y)
	
	var height = floor(
		self.chunk_size.y *
		(self.noise.get_noise_2d(pos_blobal.x, pos_blobal.z) + 1.0)
		/ 2.0
	)
	
	if pos_block.y <= height: return 1
	
	return 0 # air


func is_block_visible(pos: Vector3i, pos_chunk: Vector2i) -> bool:
	var blocks = self.get_chunk(pos_chunk)
	
	if blocks.get(pos):
		if blocks[pos] == 1: return false
	
	return true
