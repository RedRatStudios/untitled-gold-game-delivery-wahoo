class_name BeltTile
extends ItemProcessor

const item_move_speed: float = 16.0;
# const position_threshold = 16;

func _ready() -> void:
    super._ready()


func _process(delta: float) -> void:
    super._process(delta)
    var translation: Vector2 = Vector2.from_angle(rotation) * item_move_speed * delta;
    move_items_on_self(translation)



func move_items_on_self(translation: Vector2):
    """
    move items by given vector
    try to put them onto the destination if it exists and we moved far enough
    """
    for item in inventory:
        if item.transfer_lock == self:
            item.position += translation;


func _on_movement_collision_body_entered(body: Node2D) -> void:
    var parent = body.get_parent()
    if parent is TransferableItem:
        add_item(parent)


func _on_movement_collision_body_exited(body: Node2D) -> void:
    var parent = body.get_parent()
    if parent is TransferableItem:
        remove_item(parent)


# on exit - check and transfer lock

# it exits the collision body early for some reason
