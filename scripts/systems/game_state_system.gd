extends Node
class_name GameStateSystem


# -1: Game has not ended
# 0: Game won
# 1: Game lost
var game_state := -1
var game_over_scene: PackedScene


func game_over(data):
    if game_state != -1:
        return
    game_state = 0 if data["win"] else 1
    var new_scene = game_over_scene.instantiate()
    print("Initializing data...")
    new_scene.init(data)
    get_tree().root.add_child(new_scene)
    get_tree().current_scene.queue_free()
    get_tree().current_scene = new_scene


func _ready() -> void:
    game_over_scene = preload("res://scenes/game_over.tscn")
