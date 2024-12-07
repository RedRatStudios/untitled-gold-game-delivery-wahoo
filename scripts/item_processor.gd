class_name ItemProcessor
extends Node2D

"""

default functionality for factory tiles that work with items
don't forget to call `super._ready/_process` in children

"""

static var all_processors: Array[ItemProcessor];

@onready var destination_collision: Area2D = $destination_collision
@onready var destination_point: RigidBody2D = $destination_point

var destination: ItemProcessor;
var inventory: Array[ItemThing] = [];
var max_items = 4;

func _ready():
  all_processors.append(self)


func _process(_delta: float):
  update_destination()


func update_destination():
  """
  check if there's an ItemProcessor at the destination point,
  and set own destination to it
  """
  for p in all_processors:
    if p.destination_collision.overlaps_body(destination_point):
      destination = p;
      break


func add_item(item: Node2D) -> bool:
    """
    try to put item into an ItemProcessor
    returns true if successful, false if not
    """
    if len(inventory) >= max_items:
        return false

    if item.get_parent():
      item.get_parent().remove_child(item)
    add_child(item);

    item.position = Vector2(0, 0);
    inventory.append(item);

    return true
