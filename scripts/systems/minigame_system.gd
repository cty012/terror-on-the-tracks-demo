extends Node

var event_system: EventSystem


var default_camera: Camera2D
var is_minigame_active := false
var lsid_minigame_start := 0
var lsid_minigame_end := 0


func on_minigame_start(event):
    print("Minigame start")
    is_minigame_active = true
    var cameras = event["node"].find_children("", "Camera2D")
    if not cameras.is_empty():
        cameras[0].make_current()
        event["node"].start()


func on_minigame_end(event):
    print("Minigame end")
    is_minigame_active = false
    default_camera.make_current()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system
    default_camera = $/root/scene/camera
    lsid_minigame_start = event_system.add_listener("game::minigame::start", on_minigame_start)
    lsid_minigame_end = event_system.add_listener("game::minigame::end", on_minigame_end)


func _exit_tree() -> void:
    event_system.remove_listener(lsid_minigame_start)
    event_system.remove_listener(lsid_minigame_end)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
