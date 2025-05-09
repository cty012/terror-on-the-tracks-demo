extends Node
class_name Item

var proximity_system: ProximitySystem
var inventory_system: InventorySystem


@export var item_name: String
@export var collectible := true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    proximity_system = $/root/game_scene/proximity_system
    inventory_system = $/root/game_scene/inventory_system
    proximity_system.register_node("item", self)
