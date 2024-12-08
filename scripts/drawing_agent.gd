class_name DrawingAgent
extends Node2D

const BELT_TILE = preload("res://scenes/factory_tiles/belt_tile.tscn") # temp code ?
const EXTRACTOR_TILE = preload("res://scenes/factory_tiles/extractor_tile.tscn") # temp code

@onready var ghost: Node2D = $Ghost;

const GRID_SIZE: int = 16;
const OFFSET: int = 8;
enum FactoryTile {
  BELT,
  EXTRACTOR
}
static var GlobalFactoryGrid: Dictionary;  # [Vector2, Node2D]

const factory_tile_sizes: Dictionary = {
  FactoryTile.BELT: Vector2(1, 1),
  FactoryTile.EXTRACTOR: Vector2(2, 2), 
}



var active: bool = false;
var rotato: int = 0;
var active_tile_type: FactoryTile;


func _process(_delta: float) -> void:
    if Input.is_physical_key_pressed(KEY_R):
      rotato += 1;
      if rotato >= 4:
        rotato = 0

      ghost.rotation_degrees = (90.0 * rotato)

    # -- {  TEMP CODE 
    if Input.is_physical_key_pressed(KEY_1):
      active = true;
      ghost.visible = true
      var child = ghost.get_child(0)
      if child:
        child.queue_free()
      var sprite = steal_sprite(BELT_TILE)
      ghost.add_child(sprite)
      active_tile_type = FactoryTile.BELT;
      return

    if Input.is_physical_key_pressed(KEY_2):
      active = true;
      ghost.visible = true
      var child = ghost.get_child(0)
      if child:
        child.queue_free()
      var sprite = steal_sprite(EXTRACTOR_TILE)
      ghost.add_child(sprite)
      active_tile_type = FactoryTile.EXTRACTOR;
      return
    # -- }


    if !active:
      return;

    var mouse_pos = get_global_mouse_position() + Vector2(OFFSET, OFFSET)
    var active_tile = find_tile(mouse_pos)
    ghost.global_position = active_tile * GRID_SIZE;
    ghost.global_position.x += OFFSET;
    ghost.global_position.y += OFFSET;

    if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
      try_place_tile(active_tile, active_tile_type)
      return

    if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
      active = false
      ghost.visible = false
      return



func try_place_tile(tile_position: Vector2i, tile: FactoryTile) -> bool:
    pop_tile_from_grid(tile_position)
    var placing_tile;
    match tile:
      FactoryTile.BELT:
          placing_tile = BELT_TILE.instantiate();
      FactoryTile.EXTRACTOR:
          placing_tile = EXTRACTOR_TILE.instantiate();
      _:
          pass

    if !placing_tile:
        return false

    placing_tile.global_position = tile_position * GRID_SIZE;
    placing_tile.global_position.x += OFFSET;
    placing_tile.global_position.y += OFFSET;
    placing_tile.rotation_degrees = (90.0 * rotato)
    add_child(placing_tile)
    return true



func steal_sprite(res: Resource) -> Sprite2D:
  """
  dont even talk to me
  """
  var thing = res.instantiate()
  var sprite = thing.find_children("Sprite2D")[0]
  thing.remove_child(sprite)
  thing.queue_free()
  return sprite

static func find_tile(pos: Vector2) -> Vector2i:
    return Vector2i(floor(pos.x / GRID_SIZE), floor(pos.y / GRID_SIZE))

static func add_tile_to_grid(pos: Vector2i, tile: Node2D):
    var grid_pos = find_tile(pos);
    GlobalFactoryGrid[grid_pos] = tile;

static func pop_tile_from_grid(pos: Vector2i):
  var tile = GlobalFactoryGrid.get(pos)
  if tile:
      GlobalFactoryGrid.erase(pos)
      tile.queue_free()
