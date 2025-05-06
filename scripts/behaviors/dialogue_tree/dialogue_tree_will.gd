extends DialogueTree

var talked = false
var current = "welcome"
var tree = {
   "welcome": {
        "speech": "You encounter a quiet, stoic scientist, Will Dalton, sitting in the dining car.",
        "choices": [],
        "result": "intro",
    },
    "intro": {
        "speech": "\"Hello...\"",
        "choices": [
            {
                "speech": "\"Was Mr. Barnes close to you?\"",
                "result": "sad",
            },
            {
                "speech": "\"Hey, do you know anything about the man who died, Mr. Barnes?\"",
                "result": "shame",
            },
            {
                "speech": "\"You’re very quiet for a man who is on a train with a murderer.\"",
                "result": "bothered",
            },
        ],
    },
    "sad": {
        "speech": "\"No, not particularly... He was a great business man, smart enough to invest in our invention, the telephone. Too bad he died before he could see the end product.\"",
        "choices": [],
        "result": "end",
        "sus":-25
    },
    "shame": {
        "speech": "\"All I know is that man was interested in investing in our invention, the telephone. A shame he died, we could have used that extra money.\"",
        "choices": [],
        "result": "end",
    },
    "bothered": {
        "speech": "\"And you are quite a nosy young man. I would prefer if you would leave me alone now.\"",
        "choices": [],
        "result": "end",
        "sus":25
    },
    "end": {
        "speech": "Will doesn't seem like he wants to say any more as he turns to look out the window.",
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
