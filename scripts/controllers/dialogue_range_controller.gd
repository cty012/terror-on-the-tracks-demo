extends Area2D

var data := preload("res://scripts/common/data.gd").new()
var event_system: EventSystem


var npc: CharacterBody2D


func _on_body_entered(body: Node) -> void:
    if body.name == "player":
        event_system.emit("game::dialogue-detect", { "npc": npc, "in-range": true })


func _on_body_exited(body: Node) -> void:
    if body.name == "player":
        event_system.emit("game::dialogue-detect", { "npc": npc, "in-range": false })


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system
    npc = get_parent()
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
