extends Node

var util = preload("res://scripts/common/util.gd").new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $sprite.texture = util.create_circle_texture(50, Color.BLUE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
