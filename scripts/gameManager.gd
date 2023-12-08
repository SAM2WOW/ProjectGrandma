extends Node2D

@export var cursorState= {}
var canCompleteStage = false
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

var cursors = {
	"normal": [
		"res://arts/UI/player cursor/Hand young v3.png",
		"res://arts/UI/player cursor/hand married v3.png",
		"res://arts/UI/player cursor/hand old v3.png"
	],
	"grab": [
		"res://arts/UI/player cursor/grab young hand.png",
		"res://arts/UI/player cursor/grab married hand.png",
		"res://arts/UI/player cursor/grab old hand.png"
	]
}
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.gameManager = self
	print("Game Manager is ready")
	if Global.currentStage == 0 || Global.currentStage == 4:
		cursorState['normal'] = cursors['normal'][0]
		cursorState['grab'] = cursors['grab'][0]
	elif Global.currentStage == 3:
		cursorState['normal'] = cursors['normal'][2]
		cursorState['grab'] = cursors['grab'][2]
	else:
		cursorState['normal'] = cursors['normal'][1]
		cursorState['grab'] = cursors['grab'][1]
		

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
		
func ToggleCursor(state:String):
	var cursorPath = cursorState[state]
	print("cursor:",cursorPath)
	Input.set_custom_mouse_cursor(load(cursorPath))
	
func BeginDragObject(object : Draggable):
	if draggedObject: DropObject();
	draggedObject = object;
	draggedObject.UnHover()
	ToggleCursor('grab')
	
func DropObject():
	if !draggedObject: return;
	draggedObject.StopDrag();
	ToggleCursor('normal')
	
func DragObject(delta):
	if !draggedObject: return;
	draggedObject.Drag(delta);
	
func UpdateStage():
	if !canCompleteStage: return
	print('Update Scene')
	Global.currentStage += 1
	var scenePath = stageScenes[Global.currentStage]
	#print(scenePath)
	get_tree().change_scene_to_file(scenePath)
	
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
		Global.textManager.Activate("All Ingredients")

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
