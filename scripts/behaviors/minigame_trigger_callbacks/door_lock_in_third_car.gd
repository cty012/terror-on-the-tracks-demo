extends MinigameTriggerCallback


func on_minigame_end(trigger: MinigameTrigger, win: bool):
    if win:
        trigger.get_parent().queue_free()
