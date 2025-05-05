extends Node
class_name Minigame


# This function is called once when the minigame starts
func start():
    pass


# This function is called every frame when the minigame is active
func run(delta: float):
    # If the player wins, use this to end the game:
    #     event_system.emit("game::minigame-end", { "win": true })
    # If the player fails or gives up, use this to end the game:
    #     event_system.emit("game::minigame-end", { "win": false })
    pass
