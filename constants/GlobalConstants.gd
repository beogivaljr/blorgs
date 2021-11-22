extends Node

const CHARACTERS = 'ABCDEFGHIJKLMNOPQRSTUVXYZ0123456789'
const CONNECTION_CODE_LENGTH = 6

enum SpellIds {
	MOVE_TO,
	TOGGLE_GATE,
	USE_ELEVATOR,
	PRESS_SQUARE_BUTTON,
	PRESS_ROUND_BUTTON,
	SUMMON_ASCENDING_PORTAL,
	SUMMON_DESCENDING_PORTAL,
	DESTROY_SUMMON,
}
