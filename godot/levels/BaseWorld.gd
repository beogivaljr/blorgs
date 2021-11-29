class_name BaseWorld
extends Spatial

signal spell_started(spell_id)
signal spell_done(succeded)

onready var _world_input_handler = $WorldInputHandler
const _SPELLS = GlobalConstants.SpellIds
var _active_spell = null setget set_active_spell_id
var _players: Dictionary
var _active_creature_spawner_per_creature: Dictionary
var _active_player_per_creature: Dictionary
var _active_character: BaseCharacter


func _ready():
	_world_input_handler.connect("on_dragged", $GameCamera, "pan_camera")


func set_active_spell_id(spell_id):
	_active_spell = spell_id


func attempt_to_cast_spell_on(node, location):
	var spell = _active_spell
	if (
		spell == _SPELLS.SUMMON_ASCENDING_PORTAL
		and node is CreatureSpawner
		and node.summon_spell_id == _active_spell
	):
		_cast_summon_ascending_spell(node)
	elif (
		spell == _SPELLS.SUMMON_DESCENDING_PORTAL
		and node is CreatureSpawner
		and node.summon_spell_id == _active_spell
	):
		_cast_summon_descending_spell(node)
	elif (
		spell == _SPELLS.DESTROY_SUMMON
		and _active_character is Creature
#		and not node
#		and not location
	):
		_disassemble_creature()
	else:
		# Not a valid target
		return
	emit_signal("spell_started", _active_spell)


# Creature spawner
func _cast_summon_ascending_spell(creature_spawner: CreatureSpawner):
	if _active_character is Creature:
		_active_character.destroy()
	push_error("TODO: Destroy dissaasembled creatures")
	_spawn_and_setup_creature(creature_spawner)
	call_deferred("emit_signal", "spell_done", [true])


func _cast_summon_descending_spell(creature_spawner: CreatureSpawner):
	pass


func _disassemble_creature():
	var creature = _active_character as Creature
	_active_character = _active_player_per_creature[creature.name]
	_active_player_per_creature.erase(creature.name)
	_active_creature_spawner_per_creature.erase(creature.name)
	creature.disassemble()
	call_deferred("emit_signal", "spell_done", [true])


func _spawn_and_setup_creature(creature_spawner: CreatureSpawner):
	var creature = preload("res://players/creatures/Creature.tscn").instance()
	creature.connect("spell_started", self, "_on_spell_started")
	creature.connect("spell_done", self, "_on_spell_done")
	add_child(creature, true)
	creature.global_transform = creature_spawner.global_transform
	creature.setup($Navigation)
	_active_player_per_creature[creature.name] = _active_character
	_active_creature_spawner_per_creature[creature.name] = creature_spawner
	_active_character = creature


func _on_spell_started(spell_id):
	emit_signal("spell_started", spell_id)


func _on_spell_done(spell_id):
	emit_signal("spell_done", spell_id)


func _on_KillYArea_body_entered(body):
	pass
