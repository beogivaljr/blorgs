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


func alert(title: String, text: String) -> AcceptDialog:
	var dialog = AcceptDialog.new()
	dialog.popup_exclusive = true
	dialog.dialog_text = text
	dialog.window_title = title
	dialog.connect("popup_hide", dialog, "queue_free")
	get_tree().current_scene.add_child(dialog)
	dialog.popup_centered_minsize(Vector2(200, 100))
	return dialog
