extends DialogueTree

var talked = false
var current = "welcome"
var tree = {
   "welcome": {
        "speech": "You encounter the train attendant busy with one of his tasks.",
        "choices": [],
        "result": "intro",
    },
    "intro": {
        "speech": "\"Hello sir, how can I help you?\"",
        "choices": [
            {
                "speech": "\"Certainly! Here you go. Let me know if anything seems out of place.\"",
                "result": "duty",
            },
            {
                "speech": "\"Is everything okay with the cargo? I want to make sure nothing valuable is missing.\"",
                "result": "checking",
            },
            {
                "speech": "\"I need the cargo list immediately. Hand it over now!\"",
                "result": "taken aback",
            },
        ],
    },
    "duty": {
        "speech": "\"Certainly! Here you go. Let me know if anything seems out of place.\"",
        "choices": [],
        "result": "end",
        "sus":-25
    },
    "taken aback": {
        "speech": "\"That is a very odd request, but I guess you can take a look.\"",
        "choices": [],
        "result": "end",
        "sus":25
    },
    "checking": {
        "speech": "\"The cargo inventory seems to be in order, but here is the list if you would like to double check.\"",
        "choices": [],
        "result": "end",
    },
    "end": {
        "speech": "The train attendant has let you take a copy of the cargo inventory list. It may come in handy later.",
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
