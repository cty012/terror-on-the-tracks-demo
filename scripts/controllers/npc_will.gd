extends Node

var util := preload("res://scripts/common/util.gd").new()


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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $sprite.texture = util.create_circle_texture(50, Color.BLUE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
