extends Node2D


### Automatic References Start ###
onready var _color_rect: ColorRect = $CanvasLayer/ColorRect
onready var _flow_field: Node2D = $FlowField
onready var _particles: Node2D = $Particles
onready var _timer: Timer = $Timer
### Automatic References Stop ###


var ParticleClass = preload("Particle.tscn")


func _ready():
	#_color_rect.hide()
	randomize()
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_NEVER)

	for particle in _particles.get_children():
		particle.flow_field = _flow_field
	
	_timer.start()


func _input(event):
	if not Input.is_mouse_button_pressed(BUTTON_LEFT):
		return
	
	var new_particle = ParticleClass.instance()
	new_particle.position = event.position
	new_particle.flow_field = _flow_field
	_particles.add_child(new_particle)


func _on_Timer_timeout():
	var new_particle = ParticleClass.instance()
	new_particle.position = Vector2(rand_range(0, get_viewport().size.x), rand_range(0, get_viewport().size.y))
	new_particle.flow_field = _flow_field
	_particles.add_child(new_particle)
