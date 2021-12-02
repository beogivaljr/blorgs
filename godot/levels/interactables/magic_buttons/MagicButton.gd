class_name MagicButton
extends StaticBody

signal button_activated(node_name)
signal button_deactivated(node_name)

export(GlobalConstants.SpellIds) var unlock_spell_id = GlobalConstants.SpellIds.PRESS_SQUARE_BUTTON

const _BUTTON_ANIMATION_NAME = "PressDown"
const _LOCKED_SCALE = Vector3(1, 2, 1)
const _UNLOCKED_SCALE = Vector3(1, 1, 1)

var is_pressed = false
var target_locations = []
onready var navigtion_pivot: Spatial = $NavPivot
var _arrow_meshes = []
var _navigation_grid: GridMap
onready var _animation_player = $AnimationPlayer
onready var _collision_shape = $CollisionShape
onready var is_locked = _collision_shape.scale == _LOCKED_SCALE setget _set_is_locked, _get_is_locked


func _ready():
	set_lock(true)


func setup(navigation_grid: GridMap):
	_navigation_grid = navigation_grid


func press():
	_animation_player.play(_BUTTON_ANIMATION_NAME)


func release():
	_animation_player.play_backwards(_BUTTON_ANIMATION_NAME)


func set_lock(lock: bool):
	if lock:
		_collision_shape.scale = _LOCKED_SCALE
	else:
		_collision_shape.scale = _UNLOCKED_SCALE


func on_spell_selected(spell_id):
	if spell_id == unlock_spell_id and not is_pressed:
		_set_touch_highlight_visible(true)
		_set_platform_connection_highlight_visible(true)
	else:
		_set_touch_highlight_visible(false)
		_set_platform_connection_highlight_visible(false)


func on_spell_started(_spell_id):
	on_spell_selected(null)


func _set_touch_highlight_visible(is_visible):
	$HighlightMeshInstance.visible = is_visible


func _set_platform_connection_highlight_visible(is_visible):
	if _arrow_meshes.empty():
		for index in range(target_locations.size()):
			var arrow_mesh = MeshInstance.new()
			arrow_mesh.mesh = CapsuleMesh.new()
			(arrow_mesh.mesh as CapsuleMesh).radius = 0.1
			var new_mid_height = global_transform.origin.distance_to(target_locations[index])
			(arrow_mesh.mesh as CapsuleMesh).mid_height = new_mid_height / 2.0
			add_child(arrow_mesh)
			for material_index in range(arrow_mesh.get_surface_material_count()):
				arrow_mesh.set_surface_material(material_index, preload("res://levels/interactables/highlight_material.tres"))
			arrow_mesh.global_transform = global_transform.looking_at(target_locations[index], Vector3.UP)
			arrow_mesh.global_transform.origin = (target_locations[index] + global_transform.origin) / 2.0
			_arrow_meshes.append(arrow_mesh)
	for arrow_mesh in _arrow_meshes:
		arrow_mesh.visible = is_visible


func _set_is_locked(value):
	push_error("Cannot set this variable directly, use set_lock(bool) instead.")


func _get_is_locked():
	return is_locked


func _on_AnimationPlayer_animation_finished(animation_name):
	match animation_name:
		_BUTTON_ANIMATION_NAME:
			is_pressed = not is_pressed
			if is_pressed:
				emit_signal("button_activated", self.name)
			else:
				set_lock(true)
				emit_signal("button_deactivated", self.name)
		_:
			var error = "Node: " + name + " unhandled animation name"
			push_error(error)
