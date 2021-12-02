extends Spatial

signal platform_activated(node_name)
signal platform_deactivated(node_name)

const _ANIMATION_NAME = "Activate"

export(GlobalConstants.SpellIds) var unlock_spell_id = GlobalConstants.SpellIds.PRESS_SQUARE_BUTTON 

onready var is_active = false setget _set_is_active, _get_is_active
onready var navigtion_pivot: Spatial = $NavPivot
onready var _animation_player = $AnimationPlayer
var _arrow_mesh: MeshInstance


func activate(button_name):
	_animation_player.play(_ANIMATION_NAME)


func deactivate(button_name):
	_animation_player.play_backwards(_ANIMATION_NAME)


func on_spell_selected(spell_id):
	if spell_id == unlock_spell_id and not _get_is_active():
		_set_platform_direction_highlight_visible(true)
	else:
		_set_platform_direction_highlight_visible(false)


func on_spell_started(_spell_id):
	on_spell_selected(null)


func _set_platform_direction_highlight_visible(is_visible):
	if not _arrow_mesh:
		_arrow_mesh = MeshInstance.new()
		_arrow_mesh.mesh = preload("res://levels/interactables/arrow.obj")
		add_child(_arrow_mesh)
		for material_index in range(_arrow_mesh.get_surface_material_count()):
			_arrow_mesh.set_surface_material(material_index, preload("res://levels/interactables/highlight_material.tres"))
		_arrow_mesh.transform.origin = Vector3.ZERO
		_arrow_mesh.transform = _arrow_mesh.transform.scaled(Vector3(2, 2, 2))
		if unlock_spell_id == GlobalConstants.SpellIds.PRESS_ROUND_BUTTON:
			_arrow_mesh.rotate_x(PI / 3.0)
		else:
			_arrow_mesh.translate(Vector3(0, 0, 1))
	_arrow_mesh.visible = is_visible


func _get_is_active():
	return is_active


func _set_is_active(value):
	push_error("Cannot set this variable directly, use activate() instead.")


func _on_AnimationPlayer_animation_finished(anim_name):
	if _get_is_active():
		is_active = false
		emit_signal("platform_deactivated", self.name)
	else:
		is_active = true
		emit_signal("platform_activated", self.name)
