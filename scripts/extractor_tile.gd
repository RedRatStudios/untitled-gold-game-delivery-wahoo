class_name ExtractorTile
extends ItemProcessor

@onready var extraction_timer: Timer = $ExtractionTimer
@onready var extraction_point: Node2D = $ExtractionPoint

const GOLD_NOOGET = preload("res://scenes/gold_nooget.tscn")
const item_move_speed: float = 16.0;



func _ready():
    super._ready()
    tile_size = Vector2i(2, 2)
    extraction_timer.start()


func _process(delta: float) -> void:
    super._process(delta)
    var translation: Vector2 = Vector2.from_angle(rotation) * item_move_speed * delta;
    move_items_on_self(translation)

func _on_extraction_timer_timeout():
    extract_resource()

func _on_movement_collision_body_entered(body: Node2D) -> void:
    var parent = body.get_parent()
    if parent is TransferableItem:
        add_item(parent)

func _on_movement_collision_body_exited(body: Node2D) -> void:
    var parent = body.get_parent()
    if parent is TransferableItem:
        remove_item(parent)

func extract_resource():
    var nooget = GOLD_NOOGET.instantiate();
    add_sibling(nooget)
    nooget.global_position = extraction_point.global_position;

func move_items_on_self(translation: Vector2):
    for item in inventory:
        # if item.transfer_lock == self:
        item.position += translation;
