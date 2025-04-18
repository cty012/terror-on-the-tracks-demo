extends Node
class_name TimerSystem

var game_state_system: GameStateSystem


@export var time_limit_in_seconds: float
var time_remaining: float
var ui_timer: Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    game_state_system = $/root/game_scene/game_state_system
    time_remaining = time_limit_in_seconds
    ui_timer = $/root/game_scene/camera/hud/timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    time_remaining -= delta
    if time_remaining < 0:
        # Out of time
        time_remaining = 0
        game_state_system.game_over({
            "win": false,
            "msg": "Time's up, you failed",
        })

    var time_remaining_int: int = ceil(time_remaining)
    var minutes_remaining := time_remaining_int / 60
    var seconds_remaining := time_remaining_int % 60
    ui_timer.text = str(minutes_remaining).pad_zeros(2) + " : " + str(seconds_remaining).pad_zeros(2)
