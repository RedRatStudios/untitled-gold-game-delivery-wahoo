extends Node2D
const BELT_TILE = preload("res://scenes/factory_tiles/belt_tile.tscn") # temp code
@onready var belt_ghost: Node2D = $BeltGhost

const GRID_SIZE: int = 16;

var active: bool = true;
var rotato: int = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    if !active:
      return;
    var active_tile = Vector2(
      (get_global_mouse_position().x + GRID_SIZE / 2)/ GRID_SIZE,
      (get_global_mouse_position().y + GRID_SIZE / 2)/ GRID_SIZE,
    ).floor()

    belt_ghost.global_position = active_tile * GRID_SIZE;

    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
      var belt = BELT_TILE.instantiate();

      belt.global_position = active_tile * GRID_SIZE;
      belt.rotation_degrees = (90.0 * rotato)
      add_child(belt);

    if Input.is_physical_key_pressed(KEY_R):
      rotato += 1;
      if rotato >= 4:
        rotato = 0

      belt_ghost.rotation_degrees = (90.0 * rotato)
