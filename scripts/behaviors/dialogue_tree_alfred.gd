extends DialogueTree


var current = "welcome"
var tree = {
    "welcome": {
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
        "speech": "On Canvas, obviously.",
        "choices": [],
        "result": "more-q",
    },
    "favorite-game": {
        "speech": "My favorite game is Horror in the Classroom.",
        "choices": [],
        "result": "more-q",
    },
    "end": {
        "speech": "Hope you have a wonderful day!",
        "choices": [],
        "result": null,
    },
}


func reset():
    current = "welcome"


func has_ended():
    return current == null;


func get_speech():
    return tree[current]["speech"]


func get_choices():
    return tree[current]["choices"].map(func (choice): return choice["speech"])


func next():
    if tree[current].has("result"):
        current = tree[current]["result"]


func choose(index: int):
    current = tree[current]["choices"][index]["result"]
