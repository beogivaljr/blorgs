extends Control


onready var next_level_button = $VBoxContainer/NextLevelButton
onready var try_again_button = $VBoxContainer/TryAgainButton

func setup(won):
	$VBoxContainer/WonLabel.visible = won
	$VBoxContainer/NextLevelButton.visible = won
	$VBoxContainer/LostLabel.visible = not won
	$VBoxContainer/TryAgainButton.visible = not won
