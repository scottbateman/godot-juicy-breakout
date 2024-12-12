extends RigidBody2D

@export var max_speed = 400.0
@export var min_speed = 200.0
@onready var HUD = get_node("/root/Game/HUD")
@onready var camera = get_node("/root/Game/Camera")

@onready var DEFAULT_RECT_SCALE = $Color.scale
@onready var DEFAULT_COLOR = $Color.color

@onready var effect_paddle = get_node("/root/Game/Effect_Paddle")
@onready var effect_wall = get_node("/root/Game/Effect_Wall")
@onready var effect_brick = get_node("/root/Game/Effect_Brick")

var wall_trauma = 0.01
var paddle_trauma = 0.01
var brick_trauma = 0.01

func _ready():
	HUD.connect("changed", Callable(self, "_on_HUD_changed"))
	contact_monitor = true
	set_max_contacts_reported(4)
	update_color()


func update_color():
	if HUD.color_ball:
		DEFAULT_COLOR = Color8(34,184,207)
	else:
		DEFAULT_COLOR = Color(1,1,1,1)
	if HUD.particle_ball:
		$GPUParticles2D.emitting = true
	else:
		$GPUParticles2D.emitting = false




func play_sound(sound):
	if HUD.audio_effects:
		sound.play()

func _on_HUD_changed():
	update_color()	

func _physics_process(_delta):
	if HUD.ball_trail:
		var c = $Color.duplicate()
		c.global_position = $Color.global_position
		c.color = c.color.darkened(0.4)
		get_node("/root/Game/Trail_Container").add_child(c)
		
	$Color.scale = $Color.scale.lerp(
		DEFAULT_RECT_SCALE, 0.2)
	$Color.color = $Color.color.lerp(
		DEFAULT_COLOR, 0.2)

	var bodies = get_colliding_bodies()
	for body in bodies:
		if(HUD.impact_ball):
			set_ball_on_fire()
		if body.name == "Walls":
			if HUD.screen_shake_walls > 0:
				camera.add_trauma(wall_trauma*HUD.screen_shake_walls)
			play_sound(effect_wall)
		if body.name == "Paddle":
			if HUD.screen_shake_paddle > 0:
				camera.add_trauma(paddle_trauma*HUD.screen_shake_paddle)
			play_sound(effect_paddle)
		if body.is_in_group("Brick"):
			if HUD.screen_shake_blocks > 0:
				camera.add_trauma(brick_trauma*HUD.screen_shake_blocks)
			play_sound(effect_brick)
			
		if body.has_method("emit_particle"):
			body.emit_particle(global_position)
		if body.is_in_group("Brick"):
			body.die()

func set_ball_on_fire():
	$Color.scale = DEFAULT_RECT_SCALE*2
	$Color.color = Color(1,1,1,1)

func _integrate_forces(state):
	if abs(state.linear_velocity.x) < min_speed:
		state.linear_velocity.x = sign(state.linear_velocity.x) * min_speed
	if abs(state.linear_velocity.y) < min_speed:
		state.linear_velocity.y = sign(state.linear_velocity.y) * min_speed
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
