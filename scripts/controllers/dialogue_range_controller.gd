extends Area2D

var data := preload("res://scripts/common/data.gd").new()
var event_system: EventSystem
var proximity_system: ProximitySystem


var npc: CharacterBody2D


func contact_state() -> bool:
    return proximity_system.has_detect_node("npc", self)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/game_scene/event_system
    proximity_system = $/root/game_scene/proximity_system
    npc = get_parent()
    proximity_system.register_node("npc", self, npc)
