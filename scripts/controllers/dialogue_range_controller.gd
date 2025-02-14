extends Area2D

var data = preload("res://scripts/common/data.gd").new()
var event_system


var npc

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system
    npc = get_parent()
    self.body_entered.connect(on_body_entered)
    self.body_exited.connect(on_body_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func on_body_entered(body):
    if body.name == data.PLAYER_NAME:
        event_system.emit("game::dialogue-detect", { "npc": npc, "in-range": true })

func on_body_exited(body):
    if body.name == data.PLAYER_NAME:
        event_system.emit("game::dialogue-detect", { "npc": npc, "in-range": false })
