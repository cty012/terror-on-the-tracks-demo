extends ProgressBar

var event_system: EventSystem


var sus_value := 0  # 0 to 100
var lsid_sus_change := 0


func on_sus_change(event):
    sus_value = min(max(sus_value + event["amount"], 0), 100)
    self.value = sus_value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system
    lsid_sus_change = event_system.add_listener("game::sus-change", on_sus_change)


func _exit_tree() -> void:
    event_system.remove_listener(lsid_sus_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
