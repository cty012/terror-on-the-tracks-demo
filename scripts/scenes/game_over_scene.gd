extends Node
class_name GameOverScene


"""
Format of `data`:
{
    "win" (bool): win or lose,
    "msg" (string): message to display,
}
"""

var data
var restart_btn: Button
var quit_btn: Button


func init(_data):
    data = _data
    
    
func _on_restart():
    get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_quit():
    get_tree().quit()


func _ready():
    restart_btn = $/root/game_over_scene/restart/button
    quit_btn = $/root/game_over_scene/quit/button
    restart_btn.pressed.connect(_on_restart)
    quit_btn.pressed.connect(_on_quit)
