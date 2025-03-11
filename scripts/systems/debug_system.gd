extends Node

var event_system: EventSystem
var input_system: InputSystem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system
    input_system = $/root/scene/input_system


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if input_system.is_key_just_pressed(KEY_M):
        event_system.emit("game::minigame::start", {
            "node": $"/root/scene/minigame-lockpick",
        })
    elif input_system.is_key_just_pressed(KEY_N):
        event_system.emit("game::minigame::end", {})
    elif input_system.is_key_just_pressed(KEY_EQUAL):
        event_system.emit("game::sus-change", { "amount": 10 })
    elif input_system.is_key_just_pressed(KEY_MINUS):
        event_system.emit("game::sus-change", { "amount": -10 })
