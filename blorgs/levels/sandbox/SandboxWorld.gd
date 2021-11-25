extends BaseWorld
## Script inherited from Base World because it will contain some common
## This will be very handy because the Level Manager won't have to know
## exactly which level it is managing.


onready var player = $Player


func _ready() -> void:
	player.setup($Navigation, _get_interactables())
	world_input_handler.connect("on_clicked", self, "_handle_world_click")


func _get_interactables():
	var interactables = []
	var children = get_children()
	for child in children:
		if (
			child is Gate
			or child is Elevator
			or child is MagicButton
			):
			interactables.append(child)
	return interactables


func set_active_spell_id(spell_id):
	player.set_active_spell_id(spell_id)


func _handle_world_click(_event, intersection):
	if not intersection.empty():
		var node = intersection.collider
		var location = intersection.position
		player.cast_spell(node, location)


func _on_spell_started(spell_id):
	._on_spell_started(spell_id)


func _on_spell_done(succeded, interactable, spell_id):
	if spell_id == GlobalConstants.SpellIds.TOGGLE_GATE:
		# TODO: Get interactable name and toggle active ou inactive
		# its respective navmesh
		pass
	._on_spell_done(succeded, interactable, spell_id)
