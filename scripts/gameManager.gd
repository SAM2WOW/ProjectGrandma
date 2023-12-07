extends Node2D


@export var canCompleteStage = false
# @onready var recipeManager = preload("res://scripts/RecipeManager.gd").new()

signal gameEnd
signal stageComplete
var draggedObject : Draggable;
var hoveredObject : Draggable;
var ingredientsInPan: Array
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
	print("Recipe Manager Size: ", Global.recipeManager.recipe.size());

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
	if !canCompleteStage: return
	#print('Update Scene')
	Global.currentStage += 1
	var scenePath = stageScenes[Global.currentStage]
	#print(scenePath)
	Global.sceneManager.SwitchScene(scenePath)
	
func CheckGameEnd():
	if Global.currentStage == Global.stageNumbers:
		gameEnd.emit()
		return true
	return false

func AddObjectToPan(type,id):
		
	if type == "Ingredient":
		if !ingredientsInPan.has(id):
			print("Add ",type,": ",id)
			ingredientsInPan.append(id)
	elif type == "Liquid":
		if !liquidInPan.has(id):
			print("Add ",type,": ",id)
			liquidInPan.append(id)
	if ArraysAreEqual(Global.recipeManager.allIngredients,ingredientsInPan) and ArraysAreEqual(Global.recipeManager.allLiquid,liquidInPan):
		canCompleteStage = true
		stageComplete.emit()

func ArraysAreEqual(array1,array2):
	if array1.size() != array2.size() : return false
	for e in array1:
		if !array2.has(e):
			return false;
	return true
func OnCompleteStage():
	if CheckGameEnd():
		print("Complete last stage, game ends")
		gameEnd.emit()
	else:
		UpdateStage()
	canCompleteStage = false
