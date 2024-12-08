class_name TransferableItem
extends Node2D

var transfer_lock: ItemProcessor = null;
var transfer_future: ItemProcessor = null;

func update_lock():
    var proc = self.transfer_future
    self.transfer_lock = null
    self.transfer_future = null
    if proc:
        proc.add_item(self)
