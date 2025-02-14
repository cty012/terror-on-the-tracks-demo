extends Control


func update_speech(dialogue) -> void:
    self.get_node("speech_panel/character_name").text = dialogue["character-name"]
    self.get_node("speech_panel/character_speech").text = dialogue["speech"]

    # Clear existing choices
    for child in $choice_list.get_children():
        child.queue_free()

    # Add new choices
    var item_prefab = preload("res://prefabs/ui/dialogue_choice.tscn")
    for i in range(len(dialogue["choices"])):
        var item := item_prefab.instantiate()
        item.index = i
        item.text = dialogue["choices"][i]["speech"]
        $choice_list.add_child(item)
