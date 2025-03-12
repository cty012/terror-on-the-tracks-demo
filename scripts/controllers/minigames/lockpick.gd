extends Node


## Minigame: Lockpicking
##
## Rules:
## There are four pins (progress bars) to be aligned at a certain
## range (randomly generated). Press down A, S, D, F to raise the
## pin, and release them to drop the pin. You will know a pin is
## aligned if it turns green.
##
## Note that the pin will only be raised if the player press down the
## corresponding key AND all other pins on its left are aligned.
##
## Once all pins are aligned (i.e. turned green), use the SPACE key to
## open the lock.
##
## Press N to give up and return to the main game.


var event_system: EventSystem
var input_system: InputSystem


var pins: Array[ProgressBar]
var keys := [KEY_A, KEY_S, KEY_D, KEY_F]
var targets := []

var incorrect_style: StyleBox
var correct_style: StyleBox

var inc_speed := 30.0
var dec_speed := 20.0
var holding_inc_speed := 10.0
var holding_dec_speed := 3.0


func is_in_range(pin, target):
    return pin.value > target and pin.value < target + 20.0


# All minigame controllers need this
# Called on minigame enabled
func start():
    targets = []
    # Reset progress bar values
    for pin in pins:
        pin.value = 0
        pin.add_theme_stylebox_override("fill", incorrect_style)
        # Generate target values
        targets.append(randf_range(20.0, 80.0))


# All minigame controllers need this too
# Called every frame after the minigame is enabled
func run(delta: float):
    # Check if player gives up
    if input_system.is_key_just_pressed(KEY_N):
        event_system.emit("game::minigame::end", { "win": false })

    # Push the pins
    var previous_locks_correct = true
    for i in range(4):
        if is_in_range(pins[i], keys[i]):
            if previous_locks_correct and Input.is_key_pressed(keys[i]):
                pins[i].value += holding_inc_speed * delta
            else:
                pins[i].value -= holding_dec_speed * delta
            pins[i].add_theme_stylebox_override("fill", correct_style)
        else:
            if previous_locks_correct and Input.is_key_pressed(keys[i]):
                pins[i].value += inc_speed * delta
            else:
                pins[i].value -= dec_speed * delta
            pins[i].add_theme_stylebox_override("fill", incorrect_style)
            previous_locks_correct = false

    # Check if SPACE is pressed
    if input_system.is_key_just_pressed(KEY_SPACE):
        if previous_locks_correct:
            event_system.emit("game::minigame::end", { "win": true })


func _ready() -> void:
    event_system = $/root/scene/event_system
    input_system = $/root/scene/input_system
    pins.append($pin1)
    pins.append($pin2)
    pins.append($pin3)
    pins.append($pin4)
    incorrect_style = preload("res://styleboxes/pin-red.tres")
    correct_style = preload("res://styleboxes/pin-green.tres")
