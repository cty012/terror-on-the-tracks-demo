extends Node
class_name MinigameSystem


var player: CharacterBody2D
var default_camera: Camera2D
var current_minigame: Node = null
var current_minigame_trigger: MinigameTrigger = null


func start_minigame_with_trigger(trigger: MinigameTrigger) -> void:
    # Must not have a currently active minigame
    if current_minigame != null:
        return

    # Use the provided minigame, or closest minigame if not provided
    current_minigame_trigger = trigger
    start_minigame(current_minigame_trigger.minigame_node)


func start_minigame(node: Node) -> void:
    # Must not have a currently active minigame
    if current_minigame != null:
        return

    if node == null:
        return

    current_minigame = node

    # Switch the camera and start the minigame
    var cameras = current_minigame.find_children("", "Camera2D")
    if not cameras.is_empty():
        cameras[0].make_current()
        current_minigame.start()


func end_minigame(win: bool) -> void:
    current_minigame = null
    if current_minigame_trigger != null:
        current_minigame_trigger.on_minigame_end(win)
    default_camera.make_current()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    player = $/root/game_scene/player
    default_camera = $/root/game_scene/camera


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if current_minigame != null:
        current_minigame.run(delta)
