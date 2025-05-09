extends Node
class_name ProximitySystem

var player: CharacterBody2D


class NodePair:
    var detect_node: Node
    var target_node: Node

    func _init(detect_node: Node, target_node: Node):
        self.detect_node = detect_node
        self.target_node = target_node

    func _equal(other: NodePair):
        return self.target_node == other.target_node and self.detect_node == other.detect_node


# Dictionary[String, Array[Node]]
var nodes_in_range: Dictionary


func add_node(type: String, node_pair: NodePair) -> void:
    nodes_in_range.get_or_add(type, []).append(node_pair)


func remove_node(type: String, node_pair: NodePair) -> void:
    if nodes_in_range.has(type):
        nodes_in_range[type].erase(node_pair)


func has_detect_node(type: String, detect_node: Node) -> bool:
    if !nodes_in_range.has(type):
        return false

    for node_pair: NodePair in nodes_in_range[type]:
        if node_pair.detect_node == detect_node:
            return true

    return false


# Register the node
# When the player is in range/out of range the node is automatically added/removed
# detect_node: The node for proximity measurement
# target_node: The node to store and use
func register_node(type: String, detect_node: Node, target_node: Node) -> void:
    var node_pair := NodePair.new(detect_node, target_node)
    detect_node.body_entered.connect(func (body: Node): if body.name == "player": add_node(type, node_pair))
    detect_node.body_exited.connect(func (body: Node): if body.name == "player": remove_node(type, node_pair))


func get_all_nodes(type: String) -> Array[Node]:
    if !nodes_in_range.has(type):
        return []

    var all_nodes = []
    for node_pair: NodePair in nodes_in_range[type]:
        all_nodes.append(node_pair.target_node)

    return all_nodes


func get_closest_node(type: String) -> Node:
    return get_closest_node_with_condition(type, func (x): return true)


func get_closest_node_with_condition(type: String, condition: Callable) -> Node:
    if !nodes_in_range.has(type):
        return null

    var closest_node: Node = null
    var min_distance = INF
    for node_pair: NodePair in nodes_in_range[type]:
        # Skip if condition not met
        if !condition:
            continue
        # Otherwise check distance to player
        var distance = player.global_position.distance_to(node_pair.detect_node.global_position)
        if distance < min_distance:
            min_distance = distance
            closest_node = node_pair.target_node

    return closest_node


func _ready() -> void:
    player = $/root/game_scene/player
