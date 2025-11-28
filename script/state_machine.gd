extends Node
class_name StateMachine

@export var initial_state: EnemyState

var current_state: EnemyState
var states: Dictionary = {}

func _ready() -> void:
	for child_node in get_children():
		if child_node is EnemyState:
			states[child_node.name.to_lower()] = child_node
			child_node.enemy = owner
			child_node.state_machine = self

	if initial_state:
		change_state(initial_state.name)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func change_state(state_name: String) -> void:
	var new_state = states.get(state_name.to_lower())

	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
