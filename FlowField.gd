extends Node2D
class_name FlowField


### Automatic References Start ###
onready var _lines: Node2D = $Lines
### Automatic References Stop ###

onready var SWIDTH = get_viewport().size.x
onready var SHEIGHT = get_viewport().size.y
var width_curve = preload("line_curve.tres")

export var resolution: float = 20
export var field_scale: float = 10.0
export var show_angles: bool = true

var _angles: Array = []
var _la: Array = []
var _noise: OpenSimplexNoise = OpenSimplexNoise.new()


func _ready():
	randomize()
	_noise.seed = randi()
	_noise.octaves = 4
	_noise.period = 20
	_noise.persistence = .8

	for x in range(0, SWIDTH, resolution):
		for y in range(0, SHEIGHT, resolution):
			var new_angle: float = _noise.get_noise_2d(x / field_scale, y / field_scale) * PI * 2
			_angles.append(new_angle)
			
			var new_line = Line2D.new()
			new_line.points = PoolVector2Array([Vector2(0, 0), Vector2(0, -10)])
			new_line.position = Vector2(x + resolution / 2.0, y + resolution / 2.0)
			new_line.rotate(new_angle)
			new_line.width = 1
			new_line.width_curve = width_curve
			_lines.add_child(new_line)
			_la.append(new_line)

func get_angle(pos: Vector2) -> float:
	var index = floor(floor(pos.x / resolution) * SHEIGHT / resolution) + floor(pos.y / resolution)
	return _angles[index] if len(_angles) > index else -999
