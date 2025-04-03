extends Node
class_name MinigameSystem

var event_system: EventSystem


var default_camera: Camera2D
var current_minigame: Node = null
var lsid_minigame_start := 0
var lsid_minigame_end := 0


func on_minigame_start(event):
    # Must not have a currently active minigame
    if current_minigame != null:
        return

    current_minigame = event["node"]
    var cameras = current_minigame.find_children("", "Camera2D")
    if not cameras.is_empty():
        cameras[0].make_current()
        current_minigame.start()


func on_minigame_end(event):
    current_minigame = null
    if event["win"]:
        print("You win the minigame")
    else:
        print("You lose the minigame")
    default_camera.make_current()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/game_scene/event_system
    default_camera = $/root/game_scene/camera
    lsid_minigame_start = event_system.add_listener("game::minigame::start", on_minigame_start)
    lsid_minigame_end = event_system.add_listener("game::minigame::end", on_minigame_end)


func _exit_tree() -> void:
    event_system.remove_listener(lsid_minigame_start)
    event_system.remove_listener(lsid_minigame_end)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if current_minigame != null:
        current_minigame.run(delta)
