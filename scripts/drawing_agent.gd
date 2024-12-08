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


enum DrawMode {
  INACTIVE,
  ACTIVE,
  ERASE
}


var mode: DrawMode = DrawMode.INACTIVE;
var rotato: int = 0;
var active_tile_type: FactoryTile;
var offset = 0


func _process(_delta: float) -> void:
    if Input.is_physical_key_pressed(KEY_R):
      rotato += 1;
      if rotato >= 4:
        rotato = 0

      ghost.rotation_degrees = (90.0 * rotato)

    if Input.is_physical_key_pressed(KEY_E):
      mode = DrawMode.ERASE;

    # -- {  TEMP CODE 
    if Input.is_physical_key_pressed(KEY_1):
      mode = DrawMode.ACTIVE;
      ghost.visible = true
      if ghost.get_child_count() > 0:
          ghost.get_child(0).queue_free()
      var sprite = steal_sprite(BELT_TILE)
      offset = sprite.texture.get_width() / 2
      ghost.add_child(sprite)
      sprite.use_parent_material = true;
      active_tile_type = FactoryTile.BELT;
      return

    if Input.is_physical_key_pressed(KEY_2):
      mode = DrawMode.ACTIVE;
      ghost.visible = true
      if ghost.get_child_count() > 0:
          ghost.get_child(0).queue_free()
      var sprite = steal_sprite(EXTRACTOR_TILE)
      offset = sprite.texture.get_width() / 2
      ghost.add_child(sprite)
      sprite.use_parent_material = true;
      active_tile_type = FactoryTile.EXTRACTOR;
      return
    # -- }

    if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
      mode = DrawMode.INACTIVE

    match mode:
        DrawMode.INACTIVE:
            if ghost.visible:
                ghost.visible = false
                var sprite = ghost.find_children("Sprite2D")
                if sprite:
                    ghost.remove_child(sprite[0])
                    sprite[0].queue_free()
            return;

        DrawMode.ACTIVE:
            var mouse_pos = get_global_mouse_position();
            var active_tile = find_tile(mouse_pos);
            ghost.global_position = active_tile * GRID_SIZE + Vector2i(offset, offset);

            if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
              try_place_tile(active_tile, active_tile_type)
              return

        DrawMode.ERASE:
            if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
              var mouse_pos = get_global_mouse_position();
              var active_tile = find_tile(mouse_pos)
              pop_tile_from_grid(active_tile)
              return
            

        




func try_place_tile(tile_position: Vector2i, tile: FactoryTile) -> bool:
    # TODO idfk how but we have to check that all of the tiles on the grid are free
    # before placing
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

    placing_tile.global_position = (tile_position * GRID_SIZE) + Vector2i(offset, offset);
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
  sprite.owner = null
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
