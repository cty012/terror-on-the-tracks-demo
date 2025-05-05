extends DialogueTree

var talked = false
var current = "welcome"
var event_system: EventSystem

var tree = {
    "welcome": {
        "speech": "You encounter an old scientist, Alfred Miller, sitting in the dining car and stirring his coffee thoughtfully.",
        "choices": [],
        "result": "intro",
    },
    "intro": {
        "speech": "\"Quite an unsettling morning, isn’t it? Certainly more excitement than I bargained for.\"",
        "choices": [
            {
                "speech": "\"Yes, what a tragic loss. He was a great fellow investor.\"",
                "result": "piqued",
            }
        ],
    },
    "piqued": {
        "speech": "\"Fellow Investor? Interesting. Well, when the time comes, I've got a knack for getting things one might need.\"",
        "choices": [],
        "result": "poke",
        "sus": 25
    },
    "poke": {
        "speech": "You notice as Alfred winks at you and starts to smile.",
        "choices": [],
        "result": "detective",
    },
    "detective": {
        "speech": "\"Let me know if I can be of help to you ... Detective.\"",
        "choices": [
            {
                "speech": "\"Detective? I'm not quite sure what you mean.\"",
                "result": "advice",
            }
        ],
    },
    "advice": {
        "speech": "\"When you get as old as me, you learn a few things about people. Don't worry, I won't be sharing secrets anytime soon.\"",
        "choices": [],
        "result": "end",
        "sus":-25
    },
    "end": {
        "speech": "It may be useful to come back to Alfred if you need something later. There must be more to find around the train.",
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
    
