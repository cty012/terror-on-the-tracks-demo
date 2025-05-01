extends Node
class_name DialogueSystem

var event_system: EventSystem
var game_state_system: GameStateSystem
var sus_bar: ProgressBar

var player: CharacterBody2D
var npc_in_range: Array[CharacterBody2D] = []
var npc_in_dialogue: CharacterBody2D
var ui_dialogue: Control
var dialogue_tree: Dictionary  ## Actually a graph, not a tree
var state: String

var lsid_dialogue_detect := 0
var lsid_dialogue_start := 0
var lsid_dialogue_end := 0
var lsid_dialogue_next := 0
var lsid_dialogue_choose := 0


# Helper
func get_closest_talkable_npc() -> CharacterBody2D:
    var closest_npc: CharacterBody2D = null
    var min_distance = INF

    for npc in npc_in_range:
        # Skip if cannot talk to npc
        if npc.dialogue_tree == null:
            continue
        # Otherwise check if they are closer
        var distance = player.global_position.distance_to(npc.global_position)
        if distance < min_distance:
            min_distance = distance
            closest_npc = npc

    return closest_npc


func in_dialogue() -> bool:
    return npc_in_dialogue != null


func update_speech(character_name: String, dialogue_tree: DialogueTree) -> void:
    ui_dialogue.get_node("speech_panel/character_name").text = character_name
    ui_dialogue.get_node("speech_panel/character_speech").text = dialogue_tree.get_speech()
    var choice_list = ui_dialogue.get_node("choice_list")

    # Clear existing choices
    for child in choice_list.get_children():
        child.queue_free()

    # Add new choices
    var item_prefab = preload("res://prefabs/ui/dialogue_choice.tscn")
    var choices = dialogue_tree.get_choices()
    for i in range(len(choices)):
        var item := item_prefab.instantiate()
        item.index = i
        item.text = choices[i]
        choice_list.add_child(item)

func update_sus(dialogue_tree: DialogueTree) -> void:
    event_system.emit("game::sus-change", { "amount": dialogue_tree.get_sus() })

# Automatically called when an NPC announces that the player is inside/outside its dialogue range
func on_dialogue_detect(event) -> void:
    var idx = npc_in_range.find(event["npc"])
    if idx != -1:
        npc_in_range.remove_at(idx)
    if event["in-range"]:
        npc_in_range.append(event["npc"])


# Player starts a dialogue with an NPC
func on_dialogue_start(event) -> void:
    # Skip if already in dialogue
    if in_dialogue():
        return

    # Skip if nobody to talk to
    if npc_in_range.is_empty():
        return

    # Otherwise talk with the closest NPC
    npc_in_dialogue = get_closest_talkable_npc()
    if npc_in_dialogue == null:
        return
    npc_in_dialogue.dialogue_tree.reset()

    # Update UI
    update_speech(npc_in_dialogue.character_name, npc_in_dialogue.dialogue_tree)
    ui_dialogue.visible = true


func on_dialogue_end(event) -> void:
    npc_in_dialogue = null

    # Update UI
    ui_dialogue.visible = false
    
    if (sus_bar.get_sus_value() >= 100):
        game_state_system.game_over({
        "win": false,
        "msg": "You were detected, you failed."
        })


func on_dialogue_next(event) -> void:
    npc_in_dialogue.dialogue_tree.next()
    if npc_in_dialogue.dialogue_tree.has_ended():
        on_dialogue_end({})
    else:
        update_speech(npc_in_dialogue.character_name, npc_in_dialogue.dialogue_tree)
        update_sus(npc_in_dialogue.dialogue_tree)


func on_dialogue_choose(event) -> void:
    var choice = clamp(event["choice"], 0, len(npc_in_dialogue.dialogue_tree.get_choices()) - 1)
    npc_in_dialogue.dialogue_tree.choose(choice)
    if npc_in_dialogue.dialogue_tree.has_ended():
        on_dialogue_end({})
    else:
        update_speech(npc_in_dialogue.character_name, npc_in_dialogue.dialogue_tree)
        update_sus(npc_in_dialogue.dialogue_tree)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/game_scene/event_system
    game_state_system = $/root/game_scene/game_state_system
    sus_bar = $/root/game_scene/camera/hud/sus_meter
    player = $/root/game_scene/player
    ui_dialogue = $/root/game_scene/camera/hud/dialogue
    on_dialogue_end({})
    lsid_dialogue_detect = event_system.add_listener("game::dialogue-detect", on_dialogue_detect)
    lsid_dialogue_start = event_system.add_listener("game::dialogue-start", on_dialogue_start)
    lsid_dialogue_end = event_system.add_listener("game::dialogue-end", on_dialogue_end)
    lsid_dialogue_next = event_system.add_listener("game::dialogue-next", on_dialogue_next)
    lsid_dialogue_choose = event_system.add_listener("game::dialogue-choose", on_dialogue_choose)


func _exit_tree() -> void:
    event_system.remove_listener(lsid_dialogue_detect)
    event_system.remove_listener(lsid_dialogue_start)
    event_system.remove_listener(lsid_dialogue_end)
    event_system.remove_listener(lsid_dialogue_next)
    event_system.remove_listener(lsid_dialogue_choose)
