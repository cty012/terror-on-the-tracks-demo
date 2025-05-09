extends Node
class_name MinigameSystem

var event_system: EventSystem


var player: CharacterBody2D
var default_camera: Camera2D
var current_minigame: Node = null
var current_minigame_trigger: MinigameTrigger = null
var minigame_triggers_in_range: Array[MinigameTrigger] = []
var lsid_minigame_start := 0
var lsid_minigame_end := 0


func get_closest_playable_minigame_trigger() -> MinigameTrigger:
    var closest_minigame_trigger: MinigameTrigger = null
    var min_distance = INF

    for minigame_trigger in minigame_triggers_in_range:
        # Skip if not playable
        if !minigame_trigger.playable:
            continue
        # Otherwise check if they are closer
        var distance = player.global_position.distance_to(minigame_trigger.global_position)
        if distance < min_distance:
            min_distance = distance
            closest_minigame_trigger = minigame_trigger

    return closest_minigame_trigger


func on_minigame_started(event):
    # Must not have a currently active minigame
    if current_minigame != null:
        return

    # Use the provided minigame, or closest minigame if not provided
    current_minigame_trigger = event.get("trigger", null)
    current_minigame = event.get("node", null)
    if current_minigame == null:
        if current_minigame_trigger == null:
            current_minigame_trigger = get_closest_playable_minigame_trigger()
        if current_minigame_trigger != null:
            current_minigame = current_minigame_trigger.minigame_node

    if current_minigame == null:
        return

    # Switch the camera and start the minigame
    var cameras = current_minigame.find_children("", "Camera2D")
    if not cameras.is_empty():
        cameras[0].make_current()
        current_minigame.start()


func on_minigame_ended(event):
    current_minigame = null
    if current_minigame_trigger != null:
        current_minigame_trigger.on_minigame_end(event["win"])
    default_camera.make_current()


func on_minigame_trigger_entered(minigame_trigger: Area2D):
    minigame_triggers_in_range.append(minigame_trigger)


func on_minigame_trigger_exited(minigame_trigger: Area2D):
    minigame_triggers_in_range.erase(minigame_trigger)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/game_scene/event_system
    player = $/root/game_scene/player
    default_camera = $/root/game_scene/camera
    lsid_minigame_start = event_system.add_listener("game::minigame-start", on_minigame_started)
    lsid_minigame_end = event_system.add_listener("game::minigame-end", on_minigame_ended)


func _exit_tree() -> void:
    event_system.remove_listener(lsid_minigame_start)
    event_system.remove_listener(lsid_minigame_end)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if current_minigame != null:
        current_minigame.run(delta)
