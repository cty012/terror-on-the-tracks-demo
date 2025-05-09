extends DialogueTree

var talked = false
var current = "welcome"
var tree = {
    "welcome": {
        "speech": "You encounter an antsy scientist, Thomas Clark, sitting in the dining car.",
        "choices": [],
        "result": "intro",
    },
    "intro": {
        "speech": "\"Hello my good sir! Do you need anything? Perhaps a coffee, or a pen? Perhaps even a hug? Forgive me, sir, the current events have me on edge just a bit.\"",
        "choices": [
            {
                "speech": "\"No... I am good, but if you do not mind me asking why are you riled up?\"",
                "result": "nerves",
            },
            {
                "speech": "\"No worries Thomas, I know there is a lot going on right now with the murder of Mr. Barnes and the approaching expo.\"",
                "result": "distracted",
            },
            {
                "speech": "\"Why are you so nervous, Thomas? Do you have something to feel guilty about?\"",
                "result": "bothered",
            },
        ],
    },
    "nerves": {
        "speech": "\"Well, for one, there’s a murderer on this very train! Two, this is my very first expo! I have a lot of pressure on showcasing our innovation, the telephone.\"",
        "choices": [],
        "result": "end",
    },
    "distracted": {
        "speech": "\"Yes, it is true that this is my first time attending this prestigious celebration of worldwide innovation showcasing our innovation, the telephone, and it is already starting off horrifically.\"",
        "choices": [],
        "result": "end",
        "sus":-25
    },
    "bothered": {
        "speech": "\"W-What? No! I-I just... I didn’t do anything, why are you accusing me? I promise it was not me!\"",
        "choices": [],
        "result": "shaken",
    },
    "shaken": {
        "speech": "Thomas starts fidgeting even more and is clearly visibly shaken by your accusation.",
        "choices": [],
        "result": "end",
        "sus":25
    },
    "end": {
        "speech": "It doesn't seem like you'll get much more out of Thomas now as he starts to mumble to himself worrying.",
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
