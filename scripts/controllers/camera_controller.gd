extends Camera2D

var data = preload("res://scripts/common/data.gd").new()
var event_system
var player


var target := Vector2.ZERO
var alpha := 8.0
var lsid_switch_car

# Focus the camera on the target car
func on_switch_car(event):
    target = Vector2(data.CAR_WIDTH * event["index"], 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system
    player = $/root/scene/player
    lsid_switch_car = event_system.add_listener("game::switch-car", on_switch_car)

func _exit_tree() -> void:
    event_system.remove_listener(lsid_switch_car)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    self.position.x = lerp(self.position.x, target.x, alpha * delta)
