extends Node
class_name Minigame

var minigame_system: MinigameSystem


# This function is called once when the minigame starts
func start() -> void:
    pass


# This function is called every frame when the minigame is active
func run(delta: float) -> void:
    pass


# Call this function to end the game
func end_minigame(win: bool) -> void:
    minigame_system.end_minigame(win)


func _ready() -> void:
    minigame_system = $/root/game_scene/minigame_system
