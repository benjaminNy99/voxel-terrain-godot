@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass


func _enable_plugin() -> void:
	var resource_settings = preload("res://addons/terrain_voxel/settings.gd").new()
	var settings = resource_settings.SETTINGS
	
	for key in resource_settings.SETTINGS.keys():
		if not ProjectSettings.has_setting(key):
			ProjectSettings.set_setting(key, settings[key].value)
		
		ProjectSettings.add_property_info({
			"name": key,
			"type": settings[key].type,
			"hint": settings[key].hint,
			"hint_string": settings[key].hint_string if settings[key].has("hint_string") else "",
		})


func _disable_plugin() -> void:
	var resource_settings = preload("res://addons/terrain_voxel/settings.gd").new()
	
	for key in resource_settings.SETTINGS.keys():
		var setting = resource_settings.SETTINGS[key]
		if ProjectSettings.has_setting(key):
			ProjectSettings.clear(key)
