extends RigidBody2D


### Automatic References Start ###
onready var _color: ColorRect = $Color
onready var _tween: Tween = $Tween
### Automatic References Stop ###


var flow_field: FlowField


func _ready():
	modulate = Color(0, randf(), randf())
	modulate.a = 0
	_tween.interpolate_property(self, "modulate:a", 0, 0.05, .3)
	_tween.start()


func _physics_process(_delta: float):
	var angle: float = flow_field.get_angle(position)
	linear_velocity = Vector2(0, -200 * rand_range(.5, 1)).rotated(angle)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
