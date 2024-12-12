extends Node

@onready var HUD = get_node("/root/Game/HUD")
@onready var WE = get_node("/root/Game/WorldEnvironment")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
	if Input.is_action_just_pressed("menu"):	
		if HUD.visible:
			get_tree().paused = false
			HUD.hide()
			WE.show()
		else:
			get_tree().paused = true
			HUD.show()
			WE.hide()
	
	if Input.is_action_just_pressed("restart"):
		HUD._on_Restart_pressed()
