extends Node

var event_system


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if Input.is_key_pressed(KEY_1):
        event_system.emit("game::switch-car", { "index": 0 })
    elif Input.is_key_pressed(KEY_2):
        event_system.emit("game::switch-car", { "index": 1 })
