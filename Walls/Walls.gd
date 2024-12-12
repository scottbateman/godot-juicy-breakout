extends StaticBody2D

@onready var HUD = get_node("/root/Game/HUD")


func emit_particle(pos):
	if HUD.particle_walls:
		$GPUParticles2D.emitting = true
		$GPUParticles2D.global_position = pos
		$GPUParticles2D.look_at(get_viewport_rect().size/2)
