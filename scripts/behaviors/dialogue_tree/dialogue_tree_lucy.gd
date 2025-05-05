extends DialogueTree

var talked = false
var current = "welcome"
var tree = {
   "welcome": {
        "speech": "You knock on one of the closed sleeping cabin doors.",
        "choices": [],
        "result": "intro",
    },
    "intro": {
        "speech": "\"I am quite busy with my research, so please only bother me if it is a very important matter.\"",
        "choices": [],
        "result": "end",
    },
    "end": {
        "speech": "It doesn't seem likely that Lucy knows or cares much about this case right now, and even if she did, she won't come out of her room right now. Best leave her to her research.",
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
