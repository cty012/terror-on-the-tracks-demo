extends ProgressBar

var event_system: EventSystem
var game_state_system: GameStateSystem


var sus_value := 0  # 0 to 100
var lsid_sus_change := 0


func on_sus_change(event):
    sus_value = min(max(sus_value + event["amount"], 0), 100)
    self.value = sus_value
    if sus_value >= 100:
        game_state_system.game_over({
            "win": false,
            "msg": "You are detected"
        })


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/game_scene/event_system
    game_state_system = $/root/game_scene/game_state_system
    lsid_sus_change = event_system.add_listener("game::sus-change", on_sus_change)


func _exit_tree() -> void:
    event_system.remove_listener(lsid_sus_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
