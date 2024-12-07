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

  # TODO CHECKS EVERY FRAME VERY BAD
  # should only do this on tile placement or something
  update_destination()


func update_destination(ip: ItemProcessor = null):
  """
  set destination to provided ItemProcessor or select one by brute force
  """
  if ip:
    destination = ip
    return

  for p in all_processors:
    if p.destination_collision.overlaps_body(destination_point):
      destination = p;
      return


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
