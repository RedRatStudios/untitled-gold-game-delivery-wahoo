class_name ItemProcessor
extends Node2D

var inventory: Array[Node2D];

"""

default functionality for factory tiles that work with items
don't forget to call `super._ready/_process` in children

"""

func _ready():
    DrawingAgent.add_tile_to_grid(global_position, self)


func _process(_delta: float):
    pass


func add_item(item: TransferableItem):
    if item.transfer_lock == null:
        item.transfer_lock = self;
        inventory.append(item);
    else:
        item.transfer_future = self;

func remove_item(item: TransferableItem):
    var idx = inventory.find(item)
    if idx >= 0:
        inventory.remove_at(idx)
    item.update_lock()
