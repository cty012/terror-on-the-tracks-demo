extends CharacterBody2D

var util_texture = preload("res://scripts/common/util_texture.gd").new()


var movement_listener := 0
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
    var event_system = $/root/scene/event_system

    $sprite.texture = util_texture.create_white_circle_texture(50)
    movement_listener = event_system.add_listener("input::movement", on_movement)

func _exit_tree():
    var event_system = $/root/scene/event_system
    event_system.remove_listener(movement_listener)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _physics_process(delta):
    move_and_slide()
