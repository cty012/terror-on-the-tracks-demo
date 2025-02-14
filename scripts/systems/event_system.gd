extends Node
class_name EventSystem
## Event System
## Description: Manages listening and emitting events.
##
## Events are useful for decoupling systems and controllers. To listen
## to a event:
## > func callback(event):
## >     # process the event
## > listener_id = event_system.add_listener("event-type", callback)
##
## To stop listening to an event:
## > event_system.remove_listener(listener_id)
##
## To emit an event:
## > event_system.emit("event-type", event)


var listeners := {}
var listener_id_counter := 0  # Starts from 1
var listener_map := {}


func emit(event_type: String, event) -> void:
    if event_type in listeners:
        for listener_id in listeners[event_type].keys():
            listeners[event_type][listener_id].call(event)


func add_listener(event_type: String, callback: Callable) -> int:
    listener_id_counter += 1
    if event_type not in listeners:
        listeners[event_type] = {}
    listeners[event_type][listener_id_counter] = callback
    listener_map[listener_id_counter] = event_type
    return listener_id_counter


func remove_listener(listener_id: int) -> void:
    # 0 is not used
    if listener_id == 0:
        return

    if listener_id in listener_map:
        var event_type = listener_map[listener_id]
        if event_type in listeners and listener_id in listeners[event_type]:
            listeners[event_type].erase(listener_id)
        listener_map.erase(listener_id)
