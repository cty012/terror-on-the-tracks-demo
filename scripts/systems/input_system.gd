extends Node
class_name InputSystem

var event_system: EventSystem
var proximity_system: ProximitySystem
var dialogue_system: DialogueSystem
var inventory_system: InventorySystem
var minigame_system: MinigameSystem
var actions_system: ActionsSystem


# Dictionary storing custom key bindings
const KEY_BINDINGS := {
    "movement": {
        "up": KEY_W,
        "left": KEY_A,
        "down": KEY_S,
        "right": KEY_D,
    },
    "interaction": {
        "interact": KEY_E,
        "collect": KEY_F,
        "cancel": KEY_ESCAPE,
    },
}
const ACTION_WALK := "[color=orange]WASD[/color] Walk"
const ACTION_START_DIALOGUE := "[color=orange]E[/color] Talk to [color=green]{name}[/color]"
const ACTION_CONTINUE_DIALOGUE := "[color=orange]E[/color] Continue conversation"
const ACTION_PICK_UP_ITEM := "[color=orange]F[/color] Pick up [color=yellow]{name}[/color]"
const ACTION_PLAY_MINIGAME := "[color=orange]E[/color] Play minigame: {name}"

var key_just_pressed := []
var key_just_released := []


func is_key_just_pressed(keycode: Key) -> bool:
    return key_just_pressed.find(keycode) != -1


func is_key_just_released(keycode: Key) -> bool:
    return key_just_released.find(keycode) != -1


func detect_minigame(actions: Array[String]) -> bool:
    # Check if there is a minigame trigger nearby
    var closest_minigame_trigger := proximity_system.get_closest_node_with_condition("minigame-trigger", func (minigame_trigger): return minigame_trigger.playable)
    if closest_minigame_trigger == null:
        return false
    actions.push_back(ACTION_PLAY_MINIGAME.format({ "name": closest_minigame_trigger.minigame_name }))

    # Check if user pressed the key to interact
    if !is_key_just_pressed(KEY_BINDINGS["interaction"]["interact"]):
        return false

    # Start the dialogue
    minigame_system.start_minigame_with_trigger(closest_minigame_trigger)
    event_system.emit("game::movement", { "directions": [] })  # Stop movement if dialogue starts
    return true


func detect_dialogue_start(actions: Array[String]) -> bool:
    # Check if there is an NPC nearby
    var closest_npc := proximity_system.get_closest_node_with_condition("npc", func (npc): return npc.dialogue_tree != null)
    if closest_npc == null:
        return false
    actions.push_back(ACTION_START_DIALOGUE.format({ "name": closest_npc.character_name }))

    # Check if user pressed the key to interact
    if !is_key_just_pressed(KEY_BINDINGS["interaction"]["interact"]):
        return false

    # Start the dialogue
    dialogue_system.start_dialogue(closest_npc)
    event_system.emit("game::movement", { "directions": [] })  # Stop movement if dialogue starts
    return true


func detect_item(actions: Array[String]) -> bool:
    # Check if there is an item nearby
    var closest_item: Item = proximity_system.get_closest_node_with_condition("item", func (node): return node.collectible)
    if closest_item == null:
        return false
    actions.push_back(
        ACTION_PICK_UP_ITEM.format({
            "name": closest_item.item_name,
        })
    )

    # Check if user pressed the key to collect
    if !is_key_just_pressed(KEY_BINDINGS["interaction"]["collect"]):
        return false

    # Pick up the item
    inventory_system.add_item(closest_item.item_name)
    closest_item.queue_free()
    return true


func detect_movement(actions: Array[String]) -> bool:
    actions.push_back(ACTION_WALK)

    var directions := []
    for direction in KEY_BINDINGS["movement"]:
        if Input.is_key_pressed(KEY_BINDINGS["movement"][direction]):
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


func detect_dialogue_action() -> bool:
    if is_key_just_pressed(KEY_BINDINGS["interaction"]["cancel"]):
        dialogue_system.end_dialogue()
    elif is_key_just_pressed(KEY_BINDINGS["interaction"]["interact"]):
        dialogue_system.next_dialogue()
    else:
        return false
    return true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/game_scene/event_system
    proximity_system = $/root/game_scene/proximity_system
    dialogue_system = $/root/game_scene/dialogue_system
    inventory_system = $/root/game_scene/inventory_system
    minigame_system = $/root/game_scene/minigame_system
    actions_system = $/root/game_scene/actions_system


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var actions: Array[String] = []

    # If minigame is active, no actions are performed
    # Minigame actions are managed by the minigame script
    if minigame_system.current_minigame != null:
        key_just_pressed = []
        key_just_released = []
        return

    if dialogue_system.in_dialogue():
        actions.push_back(ACTION_CONTINUE_DIALOGUE)
        detect_dialogue_action()
    else:
        var interacting = detect_minigame(actions) or detect_dialogue_start(actions)
        detect_item(actions)
        if !interacting:
            detect_movement(actions)

    actions_system.update_action_list(actions)

    key_just_pressed = []
    key_just_released = []


func _input(event) -> void:
    if event is InputEventKey and not event.is_echo():
        (key_just_pressed if event.pressed else key_just_released).append(event.keycode)
