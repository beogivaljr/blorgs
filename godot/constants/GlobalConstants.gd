extends Node

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

enum CharacterTypes { NONE, A, B}

const RANDOM_NAMES = [
	"Blorgs",
	"BIRL",
	"Pindos",
	"Xureuns",
	"Shrudles",
	"Jureuns",
	"Mamaco",
	"foo",
	"bar",
	"baz",
	"Abacaxi",
	"Blob",
	"Bob",
	"Dinossauro",
	"Default",
	"Sem_nome",
	"Qualquercoisa",
	"AlgumaCoisa",
	"Banana",
	"Nome",
	"Aguacato",
	"XPTO",
	"Cringe",
	"EasterEgg",
	"Aleatorio",
	"sl",
	"Numsei",
	"AchoQueDeu",
	"asdf",
	"fdsa",
	"lololo",
	"Saint Louis",
	"funcao1",
	"feitico001",
	"minhamagia1",
	"coiso",
	"abc",
	"nome_aqui",
	"fazedora",
	"erfraier",
	"esqueci_o_nome",
	"qqr_coisa",
	"sinsalabim",
	"alakasan",
	"abra_kadabra",
	"pirilim_pim_pim",
	"accio",
	"wingardium_leviosa",
	"avada_kedavra",
	"la_mexi_ca_bum",
	"xyz",
	"faz",
	"fazer",
	"calcular",
	"hello",
	"world"
]


func alert(message: String, has_cancel_button: bool = false, ok_button_title = "Ok"):
	var popup = load("res://ui/alert/ConfirmationPopup.tscn").instance()
	popup.setup(message, has_cancel_button, ok_button_title)
	get_tree().current_scene.add_child(popup)
	return popup

const LEVEL_1_SOLUTION = "[ Object(Object,\"script\":Resource( \"res://data_objects/Spell.gd\"),\"id\":1,\"name_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellName.gd\"),\"function\":\"Bob\",\"parameter\":\"AlgumaCoisa\")\n,\"call_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellCall.gd\"),\"character_type\":1,\"param_node_name\":\"Gate\",\"param_location\":Vector3( -6.41005, 3, 3.85851 ))\n)\n, Object(Object,\"script\":Resource( \"res://data_objects/Spell.gd\"),\"id\":3,\"name_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellName.gd\"),\"function\":\"Aleatorio\",\"parameter\":\"Saint Louis\")\n,\"call_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellCall.gd\"),\"character_type\":1,\"param_node_name\":\"MagicSquareButton\",\"param_location\":Vector3( -4.40667, 0.800001, -2.28382 ))\n)\n, Object(Object,\"script\":Resource( \"res://data_objects/Spell.gd\"),\"id\":0,\"name_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellName.gd\"),\"function\":\"Aleatorio\",\"parameter\":\"coiso\")\n,\"call_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellCall.gd\"),\"character_type\":2,\"param_node_name\":\"StaticBody\",\"param_location\":Vector3( -3.16948, 1.52588e-05, -4.78983 ))\n)\n, Object(Object,\"script\":Resource( \"res://data_objects/Spell.gd\"),\"id\":0,\"name_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellName.gd\"),\"function\":\"Aleatorio\",\"parameter\":\"coiso\")\n,\"call_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellCall.gd\"),\"character_type\":1,\"param_node_name\":\"FloorGrid\",\"param_location\":Vector3( -9.14807, 0, -1.4683 ))\n)\n, Object(Object,\"script\":Resource( \"res://data_objects/Spell.gd\"),\"id\":3,\"name_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellName.gd\"),\"function\":\"Aleatorio\",\"parameter\":\"Saint Louis\")\n,\"call_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellCall.gd\"),\"character_type\":2,\"param_node_name\":\"MagicSquareButton2\",\"param_location\":Vector3( -1.27566, 0.800003, -2.36507 ))\n)\n, Object(Object,\"script\":Resource( \"res://data_objects/Spell.gd\"),\"id\":0,\"name_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellName.gd\"),\"function\":\"Aleatorio\",\"parameter\":\"coiso\")\n,\"call_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellCall.gd\"),\"character_type\":1,\"param_node_name\":\"StaticBody\",\"param_location\":Vector3( -3.10293, 3.05176e-05, -0.739503 ))\n)\n, Object(Object,\"script\":Resource( \"res://data_objects/Spell.gd\"),\"id\":0,\"name_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellName.gd\"),\"function\":\"Aleatorio\",\"parameter\":\"coiso\")\n,\"call_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellCall.gd\"),\"character_type\":2,\"param_node_name\":\"FloorGrid\",\"param_location\":Vector3( 12.2227, 1.90735e-06, -2.76238 ))\n)\n, Object(Object,\"script\":Resource( \"res://data_objects/Spell.gd\"),\"id\":2,\"name_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellName.gd\"),\"function\":\"Shrudles\",\"parameter\":\"hello\")\n,\"call_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellCall.gd\"),\"character_type\":1,\"param_node_name\":\"Elevator\",\"param_location\":Vector3( 6.97365, 0.100571, -6.76748 ))\n)\n, Object(Object,\"script\":Resource( \"res://data_objects/Spell.gd\"),\"id\":0,\"name_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellName.gd\"),\"function\":\"Aleatorio\",\"parameter\":\"coiso\")\n,\"call_dto\":Object(Object,\"script\":Resource( \"res://data_objects/SpellCall.gd\"),\"character_type\":1,\"param_node_name\":\"FloorGrid\",\"param_location\":Vector3( 12.6418, 3, -6.83972 ))\n)\n ]"
