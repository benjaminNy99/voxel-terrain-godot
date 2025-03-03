@tool
extends StaticBody3D
class_name VoxelChunk


var pos_chunk: Vector2i
var mesh_instance: MeshInstance3D
var array_mesh: ArrayMesh
var voxel: VoxelWorld

@onready var tool := SurfaceTool.new()
@onready var chunk_size: Vector3i = ProjectSettings.get_setting("addons/terrain_voxel/chunk_size")


func _init(pos_chunk: Vector2i, voxel_world: VoxelWorld) -> void:
	self.pos_chunk = pos_chunk
	self.voxel = voxel_world


func _ready() -> void:
	self.set_position_chunk()
	self.update_chunk()
	self.generate_mesh()


func set_position_chunk() -> void:
	var size = chunk_size
	var pos: Vector2i = self.pos_chunk * Vector2i(size.x, size.z)
	
	global_position = Vector3(pos.x, 0, pos.y)


func generate_mesh() -> void:
	self.tool.generate_normals(false)
	self.tool.commit(self.array_mesh)
	
	self.mesh_instance.set_mesh(self.array_mesh)
	add_child(self.mesh_instance)
	self.mesh_instance.create_trimesh_collision() # create collisions triangles


## Delete current mesh and create a mesh new [br]
## Using for update mesh when is updated
func update_chunk() -> void:
	var blocks = voxel.get_blocks(pos_chunk)
	
	if self.mesh_instance != null:
		self.mesh_instance.call_deferred("queue_free")
		self.mesh_instance = null
	
	self.array_mesh = ArrayMesh.new()
	self.mesh_instance = MeshInstance3D.new()
	self.tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var pos: Vector3i
	#var voxel
	for b in blocks:
		pos = b
		
		if blocks[b] != 0:
			#voxel = blocks[b]
			self.create_block(pos)


## create block if the face is visible
func create_block(pos: Vector3i) -> void:
	if voxel.is_block_visible(pos + Vector3i(0, 1, 0), pos_chunk): _create_face(BlockGlobal.TOP, pos) # top
	if voxel.is_block_visible(pos + Vector3i(0, -1, 0), pos_chunk): _create_face(BlockGlobal.DOWN, pos) # down
	if voxel.is_block_visible(pos + Vector3i(1, 0, 0), pos_chunk): _create_face(BlockGlobal.RIGHT, pos) # right
	if voxel.is_block_visible(pos + Vector3i(-1, 0, 0), pos_chunk): _create_face(BlockGlobal.LEFT, pos) # left
	if voxel.is_block_visible(pos + Vector3i(0, 0, 1), pos_chunk): _create_face(BlockGlobal.FRONT, pos) # front
	if voxel.is_block_visible(pos + Vector3i(0, 0, -1), pos_chunk): _create_face(BlockGlobal.BACK, pos) # back


## Create the face of a cube using triangles
func _create_face(orientation: Array, pos: Vector3i) -> void:
	var a = BlockGlobal.vertices[orientation[0]] + Vector3(pos)
	var b = BlockGlobal.vertices[orientation[1]] + Vector3(pos)
	var c = BlockGlobal.vertices[orientation[2]] + Vector3(pos)
	var d = BlockGlobal.vertices[orientation[3]] + Vector3(pos)
	
	self.tool.add_triangle_fan(([a, b, c]))
	self.tool.add_triangle_fan(([a, c, d]))
