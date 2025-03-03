@tool
extends Node


# vertices of a cube in 3 dimentions
const vertices = [
	Vector3(0,0,0), #0
	Vector3(1,0,0), #1
	Vector3(0,1,0), #2
	Vector3(1,1,0), #3
	Vector3(0,0,1), #4
	Vector3(1,0,1), #5
	Vector3(0,1,1), #6
	Vector3(1,1,1)  #7
]

const TOP = [2, 3, 7, 6]
const DOWN = [0, 4, 5, 1]
const LEFT = [6, 4, 0, 2]
const RIGHT = [3, 1, 5, 7]
const FRONT = [7, 5, 4, 6]
const BACK = [2, 0, 1, 3]


func generate_chunk() -> Dictionary:
	var pos: Vector3i
	var result := {}
	
	for x in range(self.chunk_size.x):
		for z in range(self.chunk_size.z):
			for y in range(self.chunk_size.y):
				pos = Vector3i(x, y, z)
				#result[pos] = self.get_block(pos, pos_chunk)
	
	return {}
