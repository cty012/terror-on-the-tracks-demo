extends Node
class_name ActionsSystem


var actions := []
var action_list


func update_action_list(new_actions):
    # Check if the old and new actions are the same
    if actions == new_actions:
        return
    actions = new_actions

    # Clear existing choices
    for child in action_list.get_children():
        child.queue_free()

    var action_prefab = preload("res://prefabs/ui/action_label.tscn")
    for action_test in actions:
        var action := action_prefab.instantiate()
        action.text = action_test
        action_list.add_child(action)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    action_list = $/root/game_scene/camera/hud/action_list
