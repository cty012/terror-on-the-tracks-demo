extends DialogueTree

var talked = false
var current = "welcome"
var tree = {
   "welcome": {
        "speech": "You encounter Amelia Brown, the young woman who found the dead body. She's trying her best to cope with her recent traumatic experiences.",
        "choices": [],
        "result": "intro",
    },
    "intro": {
        "speech": "\"Oh hi... um... sorry... I’m not really up for chatting right now\"",
        "choices": [
            {
                "speech": "\"Why? Are you hurt?\"",
                "result": "blood",
            },
            {
                "speech": "\"It was only a little blood…\"",
                "result": "crying",
            },
            {
                "speech": "\"That’s okay, I understand that it's been difficult. Let me know if I can help you with anything.\"",
                "result": "relief",
            },
        ],
    },
    "relief": {
        "speech": "\"Thank you sir, I am just really frightened. I’ve never seen a dead body before.\"",
        "choices": [],
        "result": "end",
        "sus":-25
    },
    "blood": {
        "speech": "\"No... I just... there was so much blood... I think I'm going to be sick.\"",
        "choices": [],
        "result": "end",
    },
    "crying": {
        "speech": "Amelia doesn't even respond to you. She quickly turns away and it's clear to you that she's holding back tears.",
        "choices": [],
        "result": "end",
        "sus":25
    },
    "end": {
        "speech": "Amelia looks like she just wants to go back to pacing the halls. It's probably best that you don't ask any more questions for now.",
        "choices": [],
        "result": null,
    },
}


func reset():
    match talked:
        false:
            current = "welcome"
        true:
            current = "end"

func has_ended():
    talked = true
    return current == null;


func get_speech():
    return tree[current]["speech"]

func get_sus():
    if tree[current].has("sus"):
        return tree[current]["sus"]
    else:
        return 0

func get_choices():
    return tree[current]["choices"].map(func (choice): return choice["speech"])


func next():
    if tree[current].has("result"):
        current = tree[current]["result"]


func choose(index: int):
    current = tree[current]["choices"][index]["result"]
