extends Movement


enum MOVEMENT_STATE {
    LEFT = 0,  LEFT_IDLE = 1,
    RIGHT = 2, RIGHT_IDLE = 3,
}

const SPEED := 3.0
const MOVING_TIME := 5.2
const IDLE_TIME := 0.5
const MOVING_STATES = [
    MOVEMENT_STATE.LEFT,
    MOVEMENT_STATE.RIGHT,
]
const IDLE_STATES = [
    MOVEMENT_STATE.LEFT_IDLE,
    MOVEMENT_STATE.RIGHT_IDLE,
]

var current_state: MOVEMENT_STATE
var current_time := 0.0
var contact_flag := false
var node: Node
var range_node: Node


# Given the current state and time, return the velocity
# Updates the current state internally
func transition() -> Vector2:
    # Find the velocity
    var velocity = Vector2.ZERO
    match current_state:
        MOVEMENT_STATE.LEFT:
            velocity.x -= 1.0
        MOVEMENT_STATE.RIGHT:
            velocity.x += 1.0

    # Change state
    if current_state in MOVING_STATES and current_time > MOVING_TIME:
        current_state += 1
        current_time = 0
    elif current_state in IDLE_STATES and current_time > IDLE_TIME:
        current_state = (current_state + 1) % 4
        current_time = 0

    return velocity


func start(node: Node) -> void:
    self.node = node
    self.range_node = node.get_node("dialogue_range")


func update(delta: float) -> void:
    if range_node.contact_state():
        return

    var velocity = transition()
    node.move_and_collide(velocity.normalized() * SPEED)

    # Update the time
    current_time += delta
