extends Resource


@export var SETTINGS = {
	"addons/terrain_voxel/chunk_size": {
		"value": Vector3i(16, 16, 16),
		"type": TYPE_VECTOR3I,
		"hint": PROPERTY_HINT_NONE,
	},
	"addons/terrain_voxel/generate_frequency": {
		"value": 0.05,
		"type": TYPE_FLOAT,
		"hint": PROPERTY_HINT_NONE,
	},
	"addons/terrain_voxel/distance_of_rendering_in_editor": {
		"value": 4,
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_RANGE,
		"hint_string": "0,10000,1",
	},
}


func _init() -> void:
	pass
