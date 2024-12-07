class_name BeltTile
extends Node2D
const item_move_speed: float = 16.0;
const max_items = 4;
const position_threshold = 16;


"""

So this is either a very stupid or very performance pilled approach.
Whenever we create belt tiles, we should also update the tiles that POINT to it
By setting the `next_belt` var
So it creates a kind of a linked list, where instead of checking physics every frame
We just check the position of the items and where they should go next.

"""

@export var items_on_belt: Array[BeltItem] = [];
@export var next_belt: BeltTile;


func _ready() -> void:
    pass # Replace with function body.


func _process(delta: float) -> void:
    var translation: Vector2 = Vector2.RIGHT * item_move_speed * delta;
    move_items_on_self(translation)



func move_items_on_self(translation: Vector2):
    """
    move items by given vector
    try to put them onto the next_belt if it exists and we moved far enough
    """
    for item in items_on_belt:
      if item.position.x < position_threshold:
        item.position += translation;
      else:
        if !next_belt:
          continue
        if next_belt.add_item(item):
          items_on_belt.pop_front();


func add_item(item: Node2D) -> bool:
    """
    try to put item on a belt
    returns true if successful, false if not
    """
    if len(items_on_belt) >= max_items:
        return false

    if item.get_parent():
      item.get_parent().remove_child(item)
    add_child(item);

    item.position = Vector2(0, 0);
    items_on_belt.append(item);

    return true
