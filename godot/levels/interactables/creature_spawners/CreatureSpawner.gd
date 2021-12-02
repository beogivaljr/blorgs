class_name CreatureSpawner
extends StaticBody

export(GlobalConstants.SpellIds) var summon_spell_id = GlobalConstants.SpellIds.SUMMON_ASCENDING_PORTAL


func on_spell_selected(spell_id):
	if spell_id == summon_spell_id:
		_set_touch_highlight_visible(true)
	else:
		_set_touch_highlight_visible(false)


func on_spell_started(_spell_id):
	on_spell_selected(null)


func _set_touch_highlight_visible(is_visible):
	$HighlightMeshInstance.visible = is_visible
