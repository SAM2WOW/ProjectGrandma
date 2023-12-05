extends Node2D

var stageNumbers = 4;
var currentStage = 1;

@onready var recipeUI = $CanvasLayer/RecipeUI
@onready var recipeManager = $RecipeManager;
@onready var gameManager = $gameManager;
@onready var instantiationManager = $InstantiationManager;
# @onready var recipeManager = preload("res://scripts/RecipeManager.gd").new()

signal gameEnd
signal stageComplete
var draggedObject : Draggable;

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Game Manager is ready")
	recipeManager = get_tree().get_first_node_in_group("RecipeManager");
	instantiationManager = get_tree().get_first_node_in_group("InstantiationManager");
	print("Recipe Manager Size: ", recipeManager.recipe.size());

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
func BeginDragObject(object : Draggable):
	if draggedObject: return;
	draggedObject = object;

func DropObject():
	if !draggedObject: return;
	draggedObject.dragging = false;
	draggedObject = null;
	
func DragObject(delta):
	if !draggedObject: return;
	draggedObject.Drag(delta);
	
func CheckGameEnd():
	if currentStage == stageNumbers:
		gameEnd.emit()
		return true
	return false
