class_name BeltTile
extends ItemProcessor

const item_move_speed: float = 16.0;
const position_threshold = 16;


"""

So this is either a very stupid or very performance pilled approach.
Whenever we create belt tiles, we should also update the tiles that POINT to it
By setting the `destination` var
So it creates a kind of a linked list, where instead of checking physics every frame
We just check the position of the items and where they should go next.

"""


func _ready() -> void:
    super._ready()
    max_items = 1;


func _process(delta: float) -> void:
    super._process(delta)
    var translation: Vector2 = Vector2.RIGHT * item_move_speed * delta;
    move_items_on_self(translation)



func move_items_on_self(translation: Vector2):
    """
    move items by given vector
    try to put them onto the destination if it exists and we moved far enough
    """
    for item in inventory:
      if item.position.x < position_threshold:
        item.position += translation;
      else:
        if !destination:
          continue
        if destination.add_item(item):
          inventory.pop_front();
