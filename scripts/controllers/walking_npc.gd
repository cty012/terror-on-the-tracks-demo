extends CharacterBody2D

var util := preload("res://scripts/common/util.gd").new()

const SPEED = 2.0

enum MV_STATE {UP, LEFT, DOWN, RIGHT}

var state = MV_STATE.UP
var time_count = 0
var contact_flag = false

@onready var rangenode = get_node("dialogue_range")

@export var character_name := ""

func get_dialogue_tree() -> Dictionary:
    return {
        "_start": "welcome",
        "welcome": {
            "character-name": character_name,
            "speech": "Welcome to GSD 405! I am the professor of this course. How can I help you?",
            "choices": [
                {
                    "speech": "Where can I find the syllabus?",
                    "result": "syllabus",
                },
                {
                    "speech": "What is your favorite game?",
                    "result": "favorite-game",
                },
            ],
        },
        "more-q": {
            "character-name": character_name,
            "speech": "Any more questions?",
            "choices": [
                {
                    "speech": "Where can I find the syllabus?",
                    "result": "syllabus",
                },
                {
                    "speech": "What is your favorite game?",
                    "result": "favorite-game",
                },
                {
                    "speech": "No.",
                    "result": "end",
                },
            ],
        },
        "syllabus": {
            "character-name": character_name,
            "speech": "On Canvas, obviously.",
            "choices": [],
            "result": "more-q",
        },
        "favorite-game": {
            "character-name": character_name,
            "speech": "My favorite game is Horror in the Classroom.",
            "choices": [],
            "result": "more-q",
        },
        "end": {
            "character-name": character_name,
            "speech": "Hope you have a wonderful day!",
            "choices": [],
            "result": "_end",
        },
    }

func patrol() -> void:
    var displacement := Vector2.ZERO
    if (!rangenode.contact_state()):
        time_count += 1
        
        if (time_count % 150 <= 120):
        
            match state:
                MV_STATE.UP:
                    displacement.y -= 1.0
                MV_STATE.DOWN:
                    displacement.y += 1.0
                MV_STATE.LEFT:
                    displacement.x -= 1.0
                MV_STATE.RIGHT:
                    displacement.x += 1.0
                    
            move_and_collide(displacement.normalized() * SPEED)
        
        if (time_count % 150 == 0):
            time_count = 0
            if (state == MV_STATE.RIGHT):
                state = MV_STATE.UP
            else:
                state += 1
    else:
        pass
    

   

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $sprite.texture = util.create_circle_texture(50, Color.BLUE)
    state = MV_STATE.UP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    patrol()
    pass
