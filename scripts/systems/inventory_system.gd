extends Node
class_name InventorySystem


@export var ALL_ITEMS: Dictionary

var inventory_node: Node
var panel: Node
var item_list: Node
var inventory_items: Array[String]


func on_ui_button_pressed():
    panel.visible = !panel.visible


func clear_ui():
    for child in item_list.get_children():
        child.queue_free()


func update_ui():
    clear_ui()
    var item_prefab = preload("res://prefabs/ui/inventory_item.tscn")
    var count := 0
    
    # Display the items
    for item_name in inventory_items:
        if !ALL_ITEMS.has(item_name):
            continue
        var item := item_prefab.instantiate()
        item.get_node("image").texture = ALL_ITEMS[item_name]
        item_list.add_child(item)
        count += 1

    # Display the empty spaces
    while count < 21:
        var item := item_prefab.instantiate()
        item_list.add_child(item)
        count += 1


func add_item(item_name: String):
    inventory_items.append(item_name)
    update_ui()


func remove_item(item_name: String):
    inventory_items.erase(item_name)
    update_ui()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    inventory_node = $/root/game_scene/camera/hud/inventory
    panel = inventory_node.get_node("panel")
    item_list = panel.get_node("item_list")
    update_ui()
    inventory_node.get_node("button").pressed.connect(on_ui_button_pressed)
