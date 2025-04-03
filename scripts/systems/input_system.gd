extends Node
class_name InputSystem

var event_system: EventSystem
var dialogue_system: DialogueSystem
var minigame_system: MinigameSystem
var actions_system: ActionsSystem


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
    "temp": {
        "dialogue-op1": KEY_1,
        "dialogue-op2": KEY_2,
        "dialogue-op3": KEY_3,
        "dialogue-op4": KEY_4,
        "dialogue-op5": KEY_5,
    }
}

var key_just_pressed := []
var key_just_released := []


func is_key_just_pressed(keycode: Key) -> bool:
    return key_just_pressed.find(keycode) != -1


func is_key_just_released(keycode: Key) -> bool:
    return key_just_released.find(keycode) != -1


func detect_movement() -> bool:
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

    event_system.emit("game::movement", { "directions": directions })
    return not directions.is_empty()


func detect_dialogue_start() -> bool:
    if is_key_just_pressed(key_bindings["interaction"]["dialogue"]):
        event_system.emit("game::dialogue-start", {})
        event_system.emit("game::movement", { "directions": [] })  # Stop movement if dialogue starts
        return true
    return false


func detect_dialogue_action() -> bool:
    if is_key_just_pressed(key_bindings["interaction"]["cancel"]):
        event_system.emit("game::dialogue-end", {})
    elif is_key_just_pressed(key_bindings["interaction"]["dialogue"]):
        event_system.emit("game::dialogue-continue", {})
    elif is_key_just_pressed(key_bindings["temp"]["dialogue-op1"]):
        event_system.emit("game::dialogue-choose", { "choice": 0 })
    elif is_key_just_pressed(key_bindings["temp"]["dialogue-op2"]):
        event_system.emit("game::dialogue-choose", { "choice": 1 })
    elif is_key_just_pressed(key_bindings["temp"]["dialogue-op3"]):
        event_system.emit("game::dialogue-choose", { "choice": 2 })
    elif is_key_just_pressed(key_bindings["temp"]["dialogue-op4"]):
        event_system.emit("game::dialogue-choose", { "choice": 3 })
    elif is_key_just_pressed(key_bindings["temp"]["dialogue-op5"]):
        event_system.emit("game::dialogue-choose", { "choice": 4 })
    else:
        return false
    return true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/game_scene/event_system
    dialogue_system = $/root/game_scene/dialogue_system
    minigame_system = $/root/game_scene/minigame_system
    actions_system = $/root/game_scene/actions_system


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var actions := []
    # If minigame is active, no actions are performed
    # Minigame actions are managed by the minigame script
    if minigame_system.current_minigame != null:
        key_just_pressed = []
        key_just_released = []
        return

    if dialogue_system.in_dialogue():
        actions.push_back("[code]E[/code] Continue conversation")
        detect_dialogue_action()
    else:
        actions.push_back("[code]WASD[/code] Walk")
        var closest_npc := dialogue_system.get_closest_npc()
        if closest_npc != null:
            actions.push_back("[code]E[/code] Talk to " + closest_npc.character_name)
        detect_dialogue_start() or detect_movement()  # Detect movement iff dialogue doesn't start

    actions_system.update_action_list(actions)

    key_just_pressed = []
    key_just_released = []


func _input(event) -> void:
    if event is InputEventKey and not event.is_echo():
        (key_just_pressed if event.pressed else key_just_released).append(event.keycode)
