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
export var time_scale: float = 3

var _angles: Array = []
var _la: Array = []
var _noise: OpenSimplexNoise = OpenSimplexNoise.new()
var _time: float = 0.0


func _ready():
	randomize()
	_noise.seed = randi()
	_noise.octaves = 4
	_noise.period = 20
	_noise.persistence = .8
	
	update_field()


func _process(delta):
	_time += delta * time_scale
	update_field()


func update_field():
	for x in range(0, SWIDTH, resolution):
		for y in range(0, SHEIGHT, resolution):
			var new_angle: float = _noise.get_noise_3d(x / field_scale, y / field_scale, sin(_time)) * PI * 2
			var angle_index = get_arrow_index(x, y)
			
			if len(_angles) <= angle_index:
				_angles.append(new_angle)
				var new_line = Line2D.new()
				new_line.points = PoolVector2Array([Vector2(0, 0), Vector2(0, -10)])
				new_line.position = Vector2(x + resolution / 2.0, y + resolution / 2.0)
				new_line.rotate(new_angle)
				new_line.width = 1
				new_line.width_curve = width_curve
				_lines.add_child(new_line)
				_la.append(new_line)
			else:
				_la[angle_index].rotate(-_angles[angle_index])
				_la[angle_index].rotate(new_angle)
				_angles[angle_index] = new_angle


func get_arrow_index(x: float, y: float) -> float:
	return floor(floor(x / resolution) * SHEIGHT / resolution) + floor(y / resolution)


func get_angle(pos: Vector2) -> float:
	var index = get_arrow_index(pos.x, pos.y)
	return _angles[index] if len(_angles) > index else -999
