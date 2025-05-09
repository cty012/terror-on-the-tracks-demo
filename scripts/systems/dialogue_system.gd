extends Node
class_name DialogueSystem

var event_system: EventSystem
var proximity_system: ProximitySystem
var game_state_system: GameStateSystem
var sus_bar: ProgressBar

var player: CharacterBody2D
var ui_dialogue: Control
var npc_in_dialogue: CharacterBody2D = null


func in_dialogue() -> bool:
    return npc_in_dialogue != null


func update_image(npc_image: Texture2D) -> void:
    ui_dialogue.get_node("npc-image").texture = npc_image


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


# Player starts a dialogue with an NPC
func start_dialogue(npc: CharacterBody2D) -> void:
    # Skip if already in dialogue
    if in_dialogue():
        return

    # Talk with the closest NPC
    npc_in_dialogue = npc
    if npc_in_dialogue == null:
        return
    npc_in_dialogue.dialogue_tree.reset()

    # Update UI
    update_image(npc_in_dialogue.character_image)
    update_speech(npc_in_dialogue.character_name, npc_in_dialogue.dialogue_tree)
    ui_dialogue.visible = true


func end_dialogue() -> void:
    npc_in_dialogue = null

    # Update UI
    ui_dialogue.visible = false
    update_image(null)
    
    if (sus_bar.get_sus_value() >= 100):
        game_state_system.game_over({
            "win": false,
            "msg": "You were detected, you failed."
        })


func next_dialogue() -> void:
    npc_in_dialogue.dialogue_tree.next()
    if npc_in_dialogue.dialogue_tree.has_ended():
        end_dialogue()
    else:
        update_speech(npc_in_dialogue.character_name, npc_in_dialogue.dialogue_tree)
        update_sus(npc_in_dialogue.dialogue_tree)


func choose_dialogue(choice: int) -> void:
    if choice < 0 or choice >= len(npc_in_dialogue.dialogue_tree.get_choices()):
        return
    npc_in_dialogue.dialogue_tree.choose(choice)
    if npc_in_dialogue.dialogue_tree.has_ended():
        end_dialogue()
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
    end_dialogue()
