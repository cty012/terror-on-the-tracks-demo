extends CharacterBody2D


var texture = load("res://scripts/common/texture.gd").new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    self.get_node("body").texture = texture.create_white_circle_texture(50)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
