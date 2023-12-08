extends Node

var default_volume = -10.0

var song1 = preload("res://sounds/Grandma's Story.ogg")
var playlist = [song1]
var last_played 
var rain = preload("res://sounds/rainAmbience.wav");
var baby = preload("res://sounds/babyCry.mp3");

func _ready():
	# dynamically download music for HTML5
	var a = AudioStreamPlayer.new()
	# pick a random song
	randomize()
	last_played = randi() % playlist.size()
	a.set_stream(playlist[last_played])
	a.set_volume_db(-80)
	a.set_bus("Music")
	#a.set_autoplay(true)
	a.set_name("BGM")
	#a.connect("finished", self, "_on_finished")
	add_child(a, true)
	
	var b = AudioStreamPlayer.new()
	b.set_stream(rain)
	b.set_volume_db(-20)
	b.set_bus("bg")
	#a.set_autoplay(true)
	b.set_name("Rain")
	#a.connect("finished", self, "_on_finished")
	add_child(b, true)
	
	var c = AudioStreamPlayer.new()
	c.set_stream(baby)
	c.set_volume_db(-25)
	c.set_bus("bg")
	#a.set_autoplay(true)
	c.set_name("Baby")
	#a.connect("finished", self, "_on_finished")
	add_child(c, true)


func _on_finished():
	# non repeating random playlist
	var next = randi() % playlist.size()
	while next == last_played:
		next = randi() % playlist.size()
	
	$BGM.set_stream(playlist[next])
	$BGM.play()

func PlayRain():
	if not $Rain.is_playing():
		$Rain.play()

func PlayBaby():
	if not $Baby.is_playing():
		$Baby.play()

func play_music():
	if not $BGM.is_playing():
		$BGM.play()

func set_pitch(ptch):
	$BGM.pitch_scale = ptch;

func stop_music():
	$BGM.stop();

func fade_in():
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($BGM, "volume_db", default_volume, 0.5)
	return tween;

func fade_out(stop=false):
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($BGM, "volume_db", -80, 0.5)
	if stop:
		tween.tween_callback(stop_music)
