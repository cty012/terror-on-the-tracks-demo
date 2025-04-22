extends Resource
class_name DialogueTree


# 0: start, 1: end
var state: int


## Reset to initial state (i.e. conversation starts over).
func reset() -> void:
    state = 0


## Check if the conversation has ended.
func has_ended() -> bool:
    return state == 1


## Returns the current speech (i.e. what the character is saying).
## Can assume speech hasn't ended.
func get_speech() -> String:
    if state == 0:
        return "I am walking. Don't ask me questions."
    else:
        return ""


## Returns the list of replies to the character's speech.
## If nothing to reply, return empty array.
##
## Each choice in the returned array is assigned an index.
## E.g. if the returned array is:
##     ["Hello.", "Hi.", "Good morning."]
## Then the choices have indices:
##     index 0: "Hello."
##     index 1: "Hi."
##     index 2: "Good morning."
func get_choices() -> Array[String]:
    return []


## Continues the conversation if nothing to reply.
## Can assume that there is indeed nothing to reply.
func next() -> void:
    state = 1


## Continues the conversation with the given reply.
## Can assume that the index always refers to a valid reply.
## See get_choices() for more information on index.
func choose(index: int) -> void:
    pass
