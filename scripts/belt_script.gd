extends Node2D

const item_move_speed: float = 16.0;
const max_items = 4;

@export var items_on_belt: Array[Node2D] = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var translation = item_move_speed * delta;
    for item in items_on_belt:
      item.position.y += translation;

    # current_item_on_belt.velocity
