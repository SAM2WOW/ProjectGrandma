extends Node2D

var stageNumbers = 4;
var currentStage = 0;

@onready var recipeUI = $CanvasLayer/RecipeUI
# @onready var recipeManager = preload("res://scripts/RecipeManager.gd").new()

signal gameEnd
signal stageComplete
var draggedObject : Draggable;
var hoveredObject : Draggable;

var liquidInPan: Array
var stageScenes: Array[String] = [
"res://levels/stageOne.tscn",
"res://levels/stageTwo.tscn",
"res://levels/stageThree.tscn",
"res://levels/stageFour.tscn",
"res://levels/endStageScene.tscn"
]
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Game Manager is ready")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;

func _physics_process(delta):
	DragObject(delta);

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 && !event.pressed:
			DropObject();
		elif event.button_index == 2 && draggedObject:
			draggedObject.ObjectAction(event);
	if event is InputEventKey and event.keycode == KEY_SPACE and draggedObject:
		draggedObject.ObjectAction(event);

func BeginDragObject(object : Draggable):
	if draggedObject: DropObject();
	draggedObject = object;

func HoverObject(object : Draggable):
	if hoveredObject: hoveredObject.hovering = false;
	hoveredObject = object;
	object.hovering = true;

func DropObject():
	if !draggedObject: return;
	draggedObject.StopDrag();
	
func DragObject(delta):
	if !draggedObject: return;
	draggedObject.Drag(delta);
	
func UpdateStage():
	var scenePath = stageScenes[currentStage]
	print(scenePath)
	Global.sceneManager.SwitchScene(scenePath)
	pass
func CheckGameEnd():
	if currentStage == stageNumbers:
		gameEnd.emit()
		return true
	return false
