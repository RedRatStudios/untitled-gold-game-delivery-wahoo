extends Node2D
const BELT_TILE = preload("res://scenes/factory_tiles/belt_tile.tscn") # temp code
const EXTRACTOR_TILE = preload("res://scenes/factory_tiles/extractor_tile.tscn") # temp code

@onready var ghost: Node2D = $Ghost;

const GRID_SIZE: int = 16;

var active: bool = false;
var rotato: int = 0;
var offset = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    if Input.is_physical_key_pressed(KEY_1):
      active = true;
      ghost.visible = true
      var child = ghost.get_child(0)
      if child:
        child.queue_free()
      var sprite = steal_sprite(BELT_TILE)
      ghost.add_child(sprite)
      offset = sprite.texture.get_width() / 2

    if Input.is_physical_key_pressed(KEY_2):
      active = true;
      ghost.visible = true
      var child = ghost.get_child(0)
      if child:
        child.queue_free()
      var sprite = steal_sprite(EXTRACTOR_TILE)
      ghost.add_child(sprite)
      offset = sprite.texture.get_width()

    if !active:
      return;

    var active_tile = Vector2(
      (get_global_mouse_position().x + offset) / GRID_SIZE,
      (get_global_mouse_position().y + offset) / GRID_SIZE,
    ).floor()

    ghost.global_position = active_tile * GRID_SIZE;

    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
      var belt = BELT_TILE.instantiate();

      belt.global_position = active_tile * GRID_SIZE;
      belt.rotation_degrees = (90.0 * rotato)
      add_child(belt);

    if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
      active = false
      ghost.visible = false

    if Input.is_physical_key_pressed(KEY_R):
      rotato += 1;
      if rotato >= 4:
        rotato = 0

      ghost.rotation_degrees = (90.0 * rotato)


func steal_sprite(res: Resource) -> Sprite2D:
  """
  dont even talk to me
  """
  var thing = res.instantiate()
  var sprite = thing.find_children("Sprite2D")[0]
  thing.remove_child(sprite)
  thing.queue_free()
  return sprite
