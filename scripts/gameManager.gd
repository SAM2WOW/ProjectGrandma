extends Node2D

var stageNumbers = 4;
var draggedObject;
var currentStage = 1; 
@onready var recipeManager = preload("res://scripts/RecipeManager.gd").new()
signal gameEnd
signal stageComplete
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Game Manager is ready")
	recipeManager.initRecipes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;

func _physics_process(delta):
	DragObject(delta);

func _input(event):
	if event is InputEventMouseButton && !event.pressed:
		DropObject();

func BeginDragObject(object):
	if draggedObject: return;
	draggedObject = object;

func DropObject():
	if !draggedObject: return;
	print("drop object");
	draggedObject = null;
	
func DragObject(delta):
	if !draggedObject || !draggedObject is Draggable: return;
	draggedObject.Drag(delta);
	
func CheckGameEnd():
	if currentStage == stageNumbers:
		gameEnd.emit()
		return true
	return false


