extends Node
class_name DialogueSystem

var event_system: EventSystem


var player: CharacterBody2D
var npc_in_range := []
var npc_in_dialogue: CharacterBody2D
var ui_dialogue: Control
var dialogue_tree: Dictionary  ## Actually a graph, not a tree
var state: String

var lsid_dialogue_detect := 0
var lsid_dialogue_start := 0
var lsid_dialogue_end := 0
var lsid_dialogue_continue := 0
var lsid_dialogue_choose := 0


# Helper
func get_closest_npc() -> CharacterBody2D:
    var closest_npc: CharacterBody2D = null
    var min_distance = INF

    for npc in npc_in_range:
        var distance = player.global_position.distance_to(npc.global_position)
        if distance < min_distance:
            min_distance = distance
            closest_npc = npc

    return closest_npc


func in_dialogue() -> bool:
    return npc_in_dialogue != null


func update_speech(dialogue) -> void:
    ui_dialogue.get_node("speech_panel/character_name").text = dialogue["character-name"]
    ui_dialogue.get_node("speech_panel/character_speech").text = dialogue["speech"]
    var choice_list = ui_dialogue.get_node("choice_list")

    # Clear existing choices
    for child in choice_list.get_children():
        child.queue_free()

    # Add new choices
    var item_prefab = preload("res://prefabs/ui/dialogue_choice.tscn")
    for i in range(len(dialogue["choices"])):
        var item := item_prefab.instantiate()
        item.index = i
        item.text = dialogue["choices"][i]["speech"]
        choice_list.add_child(item)


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
    npc_in_dialogue = get_closest_npc()

    # Update UI
    dialogue_tree = npc_in_dialogue.get_dialogue_tree()
    state = dialogue_tree["_start"]
    update_speech(dialogue_tree[state])
    ui_dialogue.visible = true


func on_dialogue_end(event) -> void:
    npc_in_dialogue = null

    # Update UI
    ui_dialogue.visible = false


func on_dialogue_continue(event) -> void:
    if not dialogue_tree[state]["choices"].is_empty():
        return
    state = dialogue_tree[state]["result"]
    if state == "_end":
        on_dialogue_end({})
    else:
        update_speech(dialogue_tree[state])


func on_dialogue_choose(event) -> void:
    var i: int = event["choice"]
    if i < 0 or i >= len(dialogue_tree[state]["choices"]):
        return
    state = dialogue_tree[state]["choices"][i]["result"]
    # TODO: execute effects
    update_speech(dialogue_tree[state])


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system
    player = $/root/scene/player
    ui_dialogue = $/root/scene/camera/hud/dialogue
    on_dialogue_end({})
    lsid_dialogue_detect = event_system.add_listener("game::dialogue-detect", on_dialogue_detect)
    lsid_dialogue_start = event_system.add_listener("game::dialogue-start", on_dialogue_start)
    lsid_dialogue_end = event_system.add_listener("game::dialogue-end", on_dialogue_end)
    lsid_dialogue_continue = event_system.add_listener("game::dialogue-continue", on_dialogue_continue)
    lsid_dialogue_choose = event_system.add_listener("game::dialogue-choose", on_dialogue_choose)


func _exit_tree() -> void:
    event_system.remove_listener(lsid_dialogue_detect)
    event_system.remove_listener(lsid_dialogue_start)
    event_system.remove_listener(lsid_dialogue_end)
    event_system.remove_listener(lsid_dialogue_continue)
    event_system.remove_listener(lsid_dialogue_choose)
