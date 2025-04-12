extends CharacterBody2D

var move_speed: int = 400
var hotbar_input: int = 0		#INFO default to first hotbar slot
var hotbar_select: int = 0		#^
var currently_firing: int = 0	#^
var hotbar_fire_durations: Array[float] = [0.01, 2]	#INFO [slot 1, slot 2]
var hotbar_cooldowns: Array[float] = [0.01, 4]		#^
var can_fire: bool = true
var mouse_position: Vector2
var fire_start_pos_port: Array[Marker2D]
var fire_start_pos_starbrd: Array[Marker2D]

signal fire(port_position, starbrd_position, direction, projectile_ID)
signal fire_projectile_update(port_position, starbrd_position, direction)


# Called when the node enters the scene tree for the first time.
func _ready():
	
	fire_start_pos_port = [$Slot1StartPos/Port, $Slot2StartPos/Port]
	fire_start_pos_starbrd = [$Slot1StartPos/Starboard, $Slot2StartPos/Starboard]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	#general processes
	mouse_position = get_global_mouse_position()
	var mouse_vector = (mouse_position - position)
	
	#player movement
	if Input.is_action_pressed("engine_throttle"):
		
		var move_direction = (mouse_position - position).normalized()
		velocity = move_direction * move_speed
	
	elif Input.is_action_just_released("engine_throttle"):
		
		velocity = Vector2(0, 0)
	
	move_and_slide()
	
	#player orientation
	rotation_degrees = rad_to_deg(mouse_vector.angle()) + 90
	
	#firing control
	var fire_direction = mouse_vector.normalized()
	fire_projectile_update.emit(fire_start_pos_port[hotbar_select].global_position,
								fire_start_pos_starbrd[hotbar_select].global_position, fire_direction) #TODO currently unused
	if Input.is_action_pressed("fire_weapon") and can_fire:
		
		currently_firing = hotbar_select
		$FireDurationTimer.start(hotbar_fire_durations[currently_firing])
		fire.emit(fire_start_pos_port[currently_firing].global_position,
				  fire_start_pos_starbrd[currently_firing].global_position,
				  fire_direction, currently_firing)
		can_fire = false
	
	get_hotbar_input()
	update_movement_sprites()


func get_hotbar_input():
	
	if Input.is_action_just_pressed("hotbar1"):
		
		hotbar_input = 0
	
	elif Input.is_action_just_pressed("hotbar2"):
		
		hotbar_input = 1
	
	elif Input.is_action_just_pressed("hotbar3"):
		
		hotbar_input = 2
	
	elif Input.is_action_just_pressed("hotbar4"):
		
		hotbar_input = 3


func update_movement_sprites():
	
	#thruster sprite handling
	if Input.is_action_just_pressed("engine_throttle"):
		
		$Sprites/EngineAfterburner.visible = true
	
	elif Input.is_action_just_released("engine_throttle"):
		
		$Sprites/EngineAfterburner.visible = false


func _on_fire_duration_timer_timeout():
	
	$Sprites/Ship.visible = true
	$Sprites/FireSecondary.visible = false
	$FireCooldownsTimer.start(hotbar_cooldowns[hotbar_select])


func _on_fire_cooldowns_timer_timeout():
	
	can_fire = true
	hotbar_select = hotbar_input
