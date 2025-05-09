extends Area2D
class_name MinigameTrigger

var minigame_system: MinigameSystem


enum ReplayMode {
    ALWAYS_REPLAYABLE,
    REPLAYABLE_ON_MINIGAME_LOSE,
    NEVER_REPLAYABLE,
}

@export var minigame_name: String = ""
@export var minigame_node: Node = null
@export var replay_mode: ReplayMode = ReplayMode.ALWAYS_REPLAYABLE
@export var callback_on_minigame_end: Script

var playable: bool = true
var callback: MinigameTriggerCallback = null


func _on_body_entered(body: Node) -> void:
    if body.name == "player":
        minigame_system.on_minigame_trigger_entered(self)


func _on_body_exited(body: Node) -> void:
    if body.name == "player":
        minigame_system.on_minigame_trigger_exited(self)


func on_minigame_end(win: bool) -> void:
    match replay_mode:
        ReplayMode.ALWAYS_REPLAYABLE:
            playable = true
        ReplayMode.REPLAYABLE_ON_MINIGAME_LOSE:
            playable = !win
        ReplayMode.NEVER_REPLAYABLE:
            playable = false
    if callback != null:
        callback.on_minigame_end(self, win)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    minigame_system = $/root/game_scene/minigame_system
    callback = callback_on_minigame_end.new()
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
