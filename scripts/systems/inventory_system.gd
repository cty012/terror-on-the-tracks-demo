extends Node

class_name InventorySystem


var inventory: Node


func on_button_pressed():
    var panel = inventory.get_node("panel")
    panel.visible = !panel.visible


func clear():
    var item_list = inventory.get_node("panel/item-list")
    for child in item_list.get_children():
        child.queue_free()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    inventory = $/root/scene/camera/hud/inventory
    inventory.get_node("button").pressed.connect(on_button_pressed)
