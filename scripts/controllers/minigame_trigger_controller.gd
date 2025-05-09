extends Area2D
class_name MinigameTrigger

var proximity_system: ProximitySystem
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
    proximity_system = $/root/game_scene/proximity_system
    minigame_system = $/root/game_scene/minigame_system
    callback = callback_on_minigame_end.new()
    proximity_system.register_node("minigame-trigger", self, self)
