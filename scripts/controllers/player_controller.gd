extends CharacterBody2D

var util = preload("res://scripts/common/util.gd").new()
var event_system


var lsid_movement := 0
var speed := 500.0

func on_movement(event):
    var displacement := Vector2.ZERO
    for direction in event["directions"]:
        if direction == "up":
            displacement.y -= 1.0
        elif direction == "left":
            displacement.x -= 1.0
        elif direction == "down":
            displacement.y += 1.0
        elif direction == "right":
            displacement.x += 1.0
    self.velocity = displacement.normalized() * speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    event_system = $/root/scene/event_system
    $sprite.texture = util.create_white_circle_texture(50)
    lsid_movement = event_system.add_listener("input::movement", on_movement)

func _exit_tree():
    event_system.remove_listener(lsid_movement)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _physics_process(delta):
    move_and_slide()
