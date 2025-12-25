extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = get_parent().health


func _process(_delta: float) -> void:
	value = get_parent().health
