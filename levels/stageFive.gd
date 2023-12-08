extends "res://scripts/main.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready();
	MusicPlayer.set_pitch(1.1);
	Global.currentStage = 4;
	await get_tree().create_timer(3).timeout
	Global.textManager.Activate("0")
	await get_tree().create_timer(7).timeout
	Global.textManager.Activate("1")
	await get_tree().create_timer(7).timeout
	Global.textManager.Activate("2")
	await get_tree().create_timer(7).timeout
	Global.finishSeqText = true;

func _process(delta):
	super._process(delta);
	if Global.textManager.find_child("cook").hasPlayed:
		PlayText("cook2");

func PlayText(txt):
	await get_tree().create_timer(7).timeout;
	Global.textManager.Activate(txt);
	await get_tree().create_timer(7).timeout;
	Global.textManager.Activate("cook3")
