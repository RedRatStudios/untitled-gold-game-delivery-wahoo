extends CharacterBody2D


const SPEED = 150.0


func _physics_process(delta: float) -> void:
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var dir_side := Input.get_axis("ui_left", "ui_right")
    var dir_up := Input.get_axis("ui_up", "ui_down")
    if dir_side:
        velocity.x = dir_side * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
    if dir_up:
        velocity.y = dir_up * SPEED
    else:
        velocity.y = move_toward(velocity.y, 0, SPEED)

    move_and_slide()
