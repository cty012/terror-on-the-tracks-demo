extends Area2D

var event_system: EventSystem


@export var index := 0


func _on_body_entered(body: Node) -> void:
    if body.name == "player":
        event_system.emit("game::switch-car", { "index": index })


func _ready() -> void:
    event_system = $/root/game_scene/event_system
    body_entered.connect(_on_body_entered)
