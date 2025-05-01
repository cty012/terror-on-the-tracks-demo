extends DialogueTree

var talked = false
var current = "welcome"
var tree = {
   "welcome": {
        "speech": "You encounter Victoria Watson, an old woman passing time in the dining car with an air of self-importance.",
        "choices": [],
        "result": "intro",
    },
    "intro": {
        "speech": "\"Oh Dear, thank goodness I am not Mr.Barnes. I am too wealthy to die this way!\"",
        "choices": [
            {
                "speech": "\"For certain, we are too important to die in our night robes.\"",
                "result": "dressed",
            },
            {
                "speech": "\"You are a very coldhearted woman.\"",
                "result": "offended",
            },
            {
                "speech": "\"Thankfully, no one else died.\"",
                "result": "idc",
            },
        ],
    },
    "dressed": {
        "speech": "\"This is why I am always dressed to impress.\"",
        "choices": [],
        "result": "end",
        "sus":-25
    },
    "offended": {
        "speech": "\"How dare you insult your elders!\"",
        "choices": [],
        "result": "end",
        "sus":25
    },
    "idc": {
        "speech": "\"This is a bother as it is! I can't sleep worrying that some scoundrel is after me and my riches.\"",
        "choices": [],
        "result": "end",
    },
    "end": {
        "speech": "Whatever it is Victoria is doing now seems more important to her than helping you figure out what happened. It's probably best to look elsewhere for now.",
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
