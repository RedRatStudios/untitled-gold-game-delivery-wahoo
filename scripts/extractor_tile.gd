class_name ExtractorTile
extends ItemProcessor

@onready var extraction_timer: Timer = $extraction_timer
const GOLD_NOOGET = preload("res://scenes/gold_nooget.tscn")

const nooget_offset: Vector2 = Vector2(-4, 2);

func _ready():
    super._ready()
    extraction_timer.start()

func _on_extraction_timer_timeout():
    extract_resource()

func extract_resource():
    var nooget = GOLD_NOOGET.instantiate();
    nooget.position -= nooget_offset;
    if destination:
      destination.add_item(nooget)
