extends Node
class_name Minigame


# This function is called once when the minigame starts
func start() -> void:
    pass


# This function is called every frame when the minigame is active
func run(delta: float) -> void:
    pass


# Call this function to end the game
func end_minigame(win: bool) -> void:
    $/root/game_scene/minigame_system.end_minigame(win)
