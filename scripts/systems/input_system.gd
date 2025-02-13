extends Node


# Dictionary storing custom key bindings
var key_bindings := {
    "movement": {
        "up": KEY_W,
        "left": KEY_A,
        "down": KEY_S,
        "right": KEY_D,
    }
}

func detect_movement(_delta):
    var event_system = $"/root/scene/event_system"

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

    if not directions.is_empty():
        event_system.emit("input::movement", {
                "directions": directions,
                "_delta": _delta
            })

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    detect_movement(_delta)
