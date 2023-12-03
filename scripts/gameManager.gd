extends Node2D

var draggedObject;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
