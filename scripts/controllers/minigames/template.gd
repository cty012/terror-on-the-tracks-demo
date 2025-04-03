extends Node


## Minigame: Template
##
## Template file for creating new minigames.


var event_system: EventSystem
var input_system: InputSystem


# Define your variables and helper functions here


# This function is called once when the minigame starts
func start():
    pass


# This function is called every frame when the minigame is active
func run(delta: float):
    # If the player wins, use this to end the game:
    #     event_system.emit("game::minigame::end", { "win": true })
    # If the player fails or gives up, use this to end the game:
    #     event_system.emit("game::minigame::end", { "win": false })
    pass


# This function is called once when the game (not the minigame) starts
# Exclusively used for initializing variables that persist between different minigame sessions
func _ready() -> void:
    event_system = $/root/game_scene/event_system
    input_system = $/root/game_scene/input_system
    # Initialize your variables here
