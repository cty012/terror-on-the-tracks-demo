extends Button

var dialogue_system: DialogueSystem


var index := -1


func _on_button_pressed() -> void:
    dialogue_system.choose_dialogue(index)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    dialogue_system = $/root/game_scene/dialogue_system
    pressed.connect(_on_button_pressed)
