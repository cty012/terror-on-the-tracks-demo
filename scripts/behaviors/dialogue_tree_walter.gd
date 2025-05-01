extends DialogueTree

var talked = false
var current = "welcome"
var tree = {
   "welcome": {
        "speech": "You encounter Walter Grimm, a gentleman who is currently in the baggage car for some reason.",
        "choices": [],
        "result": "intro",
    },
    "intro": {
        "speech": "\"Terrible business, this whole affair with Mr. Barnes. I was completely unaware that anything bad happened till the morning, how tragic on the eve of the innovation expo.\"",
        "choices": [
            {
                "speech": "\"Wow, you slept through all the screaming. You must be a deep sleeper indeed.\"",
                "result": "baby",
            },
            {
                "speech": "\"Really strange how you slept through the chaos, it seems like everyone heard the screaming.\"",
                "result": "play dumb",
            },
            {
                "speech": "\"Unfortunate timing indeed. This expo was supposed to be a great celebration.\"",
                "result": "excited",
            },
        ],
    },
    "excited": {
        "speech": "\"Yes, such a promising event! I know him and I were both very excited to witness the showcase of the telephone. A shame it had to be like this.\"",
        "choices": [],
        "result": "end",
        "sus":-25
    },
    "baby": {
        "speech": "\"Exactly, you understand me. My mum always said I slept like a baby, especially when I am in the midst of a dream.\"",
        "choices": [],
        "result": "end",
    },
    "play dumb": {
        "speech": "\"Hmm... not everyone sleeps lightly, sir. I assure you, I have no idea what transpired until I was already dressed.\"",
        "choices": [],
        "result": "end",
        "sus":25
    },
    "end": {
        "speech": "Walter seems finished with the conversation, as if you both have better things you could be doing now. You may as well oblige.",
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
