extends Node
class_name InputSystem

var event_system
var dialogue_system


# Dictionary storing custom key bindings
var key_bindings := {
    "movement": {
        "up": KEY_W,
        "left": KEY_A,
        "down": KEY_S,
        "right": KEY_D,
    },
    "interaction": {
        "dialogue": KEY_E,
        "collect": KEY_F,
        "cancel": KEY_ESCAPE,
    },
}

var key_just_pressed := []
var key_just_released := []

func is_key_just_pressed(keycode: Key) -> bool:
    return key_just_pressed.find(keycode) != -1

func is_key_just_released(keycode: Key) -> bool:
    return key_just_released.find(keycode) != -1

func detect_movement():
    var directions := []
    for direction in key_bindings["movement"]:
        if Input.is_key_pressed(key_bindings["movement"][direction]):
            directions.append(direction)

    ## Cannot move in opposite directions
    if "up" in directions and "down" in directions:
        directions.erase("up")
        directions.erase("down")
    if "left" in directions and "right" in directions:
        directions.erase("left")
        directions.erase("right")

    #if not directions.is_empty():
    event_system.emit("game::movement", {
            "directions": directions,
        })

func detect_dialogue():
    if dialogue_system.in_dialogue():
        if is_key_just_pressed(key_bindings["interaction"]["cancel"]):
            event_system.emit("game::dialogue-finish", {})
    else:
        if is_key_just_pressed(key_bindings["interaction"]["dialogue"]):
            event_system.emit("game::dialogue-start", {})

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system
    dialogue_system = $/root/scene/dialogue_system

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if not dialogue_system.in_dialogue():
        detect_movement()
    detect_dialogue()
    key_just_pressed = []
    key_just_released = []

func _input(event):
    if event is InputEventKey and not event.is_echo():
        (key_just_pressed if event.pressed else key_just_released).append(event.keycode)
