extends Button

var event_system: EventSystem


var index := 1


func _on_button_pressed() -> void:
    event_system.emit("game::dialogue-choose", { "choice": index })


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system
    pressed.connect(_on_button_pressed)
