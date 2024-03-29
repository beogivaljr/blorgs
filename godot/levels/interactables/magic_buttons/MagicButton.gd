class_name MagicButton
extends StaticBody

signal button_activated(node_name)
signal button_deactivated(node_name)

export(GlobalConstants.SpellIds) var unlock_spell_id = GlobalConstants.SpellIds.PRESS_SQUARE_BUTTON

const _BUTTON_ANIMATION_NAME = "PressDown"
const _LOCKED_SCALE = Vector3(1, 2, 1)
const _UNLOCKED_SCALE = Vector3(1, 1, 1)

var is_pressed = false
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
	else:
		_set_touch_highlight_visible(false)


func on_spell_started(_spell_id):
	on_spell_selected(null)


func set_color(color: Color):
	var mesh = $ButtonMesh.mesh
	var new_material = (mesh.surface_get_material(0) as SpatialMaterial).duplicate()
	new_material.albedo_color = color
	mesh.surface_set_material(0, new_material)


func _set_touch_highlight_visible(is_visible):
	$HighlightMeshInstance.visible = is_visible


func _set_is_locked(_value):
	push_error("Cannot set this variable directly, use set_lock(bool) instead.")


func _get_is_locked():
	return is_locked


func _on_AnimationPlayer_animation_started(animation_name):
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
