extends Node

var event_system: EventSystem
var input_system: InputSystem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/game_scene/event_system
    input_system = $/root/game_scene/input_system


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
