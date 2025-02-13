extends Node
class_name InputSystem

var event_system


# Dictionary storing custom key bindings
var key_bindings := {
    "movement": {
        "up": KEY_W,
        "left": KEY_A,
        "down": KEY_S,
        "right": KEY_D,
    }
}

func detect_movement():
    var directions := []
    for direction in key_bindings["movement"]:
        if Input.is_key_pressed(key_bindings["movement"][direction]):
            directions.append(direction)

    ## Cannot move in opposite directions
    if "up" in directions and "down" in directions:
        directions.erase("up")
        directions.erase("down")
    if "left" in directions and "right" in directions:
        directions.erase("left")
        directions.erase("right")

    #if not directions.is_empty():
    event_system.emit("input::movement", {
            "directions": directions,
        })

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    detect_movement()
