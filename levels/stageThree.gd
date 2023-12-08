extends "res://scripts/main.gd"


func _ready():
	super._ready();
	Global.currentStage = 2;
	MusicPlayer.set_pitch(0.8);
	
	await get_tree().create_timer(3).timeout
	
	Global.textManager.Activate("1")
	
	await get_tree().create_timer(7).timeout
	
	Global.textManager.Activate("2")
	
	await get_tree().create_timer(7).timeout
	
	Global.textManager.Activate("3")

func _process(delta):
	super._process(delta);
	if Global.textManager.find_child("4").hasPlayed:
		PlayText("5");

func PlayText(txt):
	await get_tree().create_timer(6).timeout;
	Global.textManager.Activate(txt);
