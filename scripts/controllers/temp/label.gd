extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var scene = $/root/game_over_scene
    self.text = scene.data["msg"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
