extends Node2D

@export var enemy_data: Array[Wave]

func _ready() -> void:
	SignalBus.startWave.connect(_on_wave_start)
	pass


func _on_wave_start(wave_number: int):
	if wave_number < enemy_data.size() - 1:
		spawn_wave(enemy_data[wave_number])
	# check game won after last wave has finished spawning
	elif(wave_number == enemy_data.size() - 1):
		var finish_check_timer = Timer.new()
		finish_check_timer.wait_time = 30
		finish_check_timer.timeout.connect(_on_finish_check_timer_timeout.bind(finish_check_timer))
		finish_check_timer.name = "test"
		print("i got here")
		add_child(finish_check_timer)
		finish_check_timer.start()
		spawn_wave(enemy_data[wave_number])

func spawn_wave(wave: Wave) -> void:
	for enemy_sequence in wave.enemy_sequences:
		var timer: Timer = Timer.new()
		timer.wait_time = enemy_sequence.timer
		timer.timeout.connect(_on_enemy_timer_timeout.bind({
			"enemy_sequence": enemy_sequence,
			"timer": timer
		}))
		add_child(timer)
		timer.start()
		
		
func _on_enemy_timer_timeout(dict: Dictionary):
	var enemy_sequence: EnemySequence = dict.get("enemy_sequence")
	var enemy: PackedScene = get_enemy(enemy_sequence.name)
	var path: Path2D = get_enemy_path(enemy_sequence.path)
	
	create_enemy(enemy, path)
	
	enemy_sequence.amount -= 1
	if enemy_sequence.amount <= 0:
		var timer: Timer = dict.get("timer")
		timer.queue_free()
	
func create_enemy(enemy: PackedScene, path: Path2D) -> void:
	var follow_path = PathFollow2D.new()
	follow_path.add_child(enemy.instantiate())
	path.add_child(follow_path)
	follow_path.set_progress_ratio(0)

func get_enemy_path(enemy_path: Enums.PathType) -> Path2D:
	match enemy_path:
		Enums.PathType.TOP_RIGHT:
			return $TopRightPath
		Enums.PathType.TOP_LEFT:
			return $TopLeftPath
		Enums.PathType.BOTTOM:
			return $BottomPath
			
	return $TopRightPath

func get_enemy(enemy_name: Enums.EnemyType) -> PackedScene:
	match enemy_name:
		Enums.EnemyType.SOLDIER:
			return load("res://Scenes/Enemies/soldier_a.tscn")
		Enums.EnemyType.SPRINTER:
			return load("res://Scenes/Enemies/soldier_sprinter.tscn")
		Enums.EnemyType.TANK:
			return load("res://Scenes/Enemies/soldier_tank.tscn")
		Enums.EnemyType.ELITE:
			return load("res://Scenes/Enemies/soldier_elite.tscn")
			
	return load("res://Scenes/Enemies/soldier_a.tscn")
	
	
func _on_finish_check_timer_timeout(timer: Timer) -> void:
	print("finish check timer timeout")
	timer.wait_time = 1
	timer.start()
	var enemiesLeft = $TopRightPath.get_child_count() + $TopLeftPath.get_child_count() + $BottomPath.get_child_count()
	print(enemiesLeft)
	if enemiesLeft == 0:
		Game.win()
