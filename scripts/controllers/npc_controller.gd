extends Node

var util := preload("res://scripts/common/util.gd").new()


@export var character_name := ""
@export var dialogue_tree_script: GDScript = null
@export var movement_script: GDScript = null

var dialogue_tree: DialogueTree = null
var movement: Movement = null


func set_dialogue_tree_script(path: String):
    if path.is_empty():
        dialogue_tree = null
    else:
        dialogue_tree = load(path).new()


func set_movement_script(path: String):
    if path.is_empty():
        movement = null
    else:
        movement = load(path).new()
        movement.start(self)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if dialogue_tree_script != null:
        dialogue_tree = dialogue_tree_script.new()
    if movement_script != null:
        movement = movement_script.new()
        movement.start(self)
    $sprite.texture = util.create_circle_texture(50, Color.BLUE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if movement != null:
        movement.update(delta)
