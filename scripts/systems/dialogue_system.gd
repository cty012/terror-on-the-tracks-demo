extends Node
class_name DialogueSystem

var event_system


var player
var npc_in_range := []
var npc_in_dialogue
var lsid_dialogue_detect

# Helper
func get_closest_npc() -> Node:
    var closest_npc: Node = null
    var min_distance = INF
    
    for npc in npc_in_range:
        var distance = player.global_position.distance_to(npc.global_position)
        if distance < min_distance:
            min_distance = distance
            closest_npc = npc

    return closest_npc

func in_dialogue() -> bool:
    return npc_in_dialogue != null

# Player starts a dialogue with an NPC
func on_dialogue_start(event):
    # Skip if already in dialogue
    if in_dialogue():
        print("Already talking to " + npc_in_dialogue.name)
        return

    # Skip if nobody to talk to
    if npc_in_range.is_empty():
        print("Nobody to talk to")
        return

    # Otherwise talk with the closest NPC
    npc_in_dialogue = get_closest_npc()
    print("Talking to " + npc_in_dialogue.name)
    # TODO: ui

func on_dialogue_finish(event):
    if in_dialogue():
        print("Finished talking to " + npc_in_dialogue.name)
    npc_in_dialogue = null
    # TODO: ui

# Automatically called when an NPC announces that the player is inside/outside its dialogue range
func on_dialogue_detect(event):
    var idx = npc_in_range.find(event["npc"])
    if idx != -1:
        npc_in_range.remove_at(idx)
    if event["in-range"]:
        npc_in_range.append(event["npc"])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system
    player = $/root/scene/player
    lsid_dialogue_detect = event_system.add_listener("game::dialogue-detect", on_dialogue_detect)
    lsid_dialogue_detect = event_system.add_listener("game::dialogue-start", on_dialogue_start)
    lsid_dialogue_detect = event_system.add_listener("game::dialogue-finish", on_dialogue_finish)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
