extends Node

var util := preload("res://scripts/common/util.gd").new()


@export var character_name := ""
@export var dialogue_tree_script: GDScript = null
var dialogue_tree: DialogueTree = null


func set_dialogue_tree_script(path: String):
    if path.is_empty():
        dialogue_tree = null
    else:
        dialogue_tree = load(path).new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if dialogue_tree_script != null:
        dialogue_tree = dialogue_tree_script.new()
    $sprite.texture = util.create_circle_texture(50, Color.BLUE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
