extends Node
class_name ProximitySystem


# Dictionary[String, Array[Node]]
var nodes_in_range: Dictionary


func add_node(type: String, node: Node):
    nodes_in_range.get_or_add(type, []).append(node)


func remove_node(type: String, node: Node):
    if nodes_in_range.has(type):
        nodes_in_range[type].erase(node)


# Register the node
# When the player is in range/out of range the node is automatically added/removed
func register_node(type: String, node: Node):
    node.body_entered.connect(func (body: Node): if body.name == "player": add_node(type, node))
    node.body_exited.connect(func (body: Node): if body.name == "player": remove_node(type, node))


func get_all_nodes(type: String):
    if !nodes_in_range.has(type):
        return []
    return nodes_in_range[type]


func get_closest_node(type: String):
    return get_closest_node_with_condition(type, func (x): return true)


func get_closest_node_with_condition(type: String, condition: Callable):
    if !nodes_in_range.has(type):
        return null
    for node in nodes_in_range[type]:
        if condition:
            return node
