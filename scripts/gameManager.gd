extends Node2D

var draggedObject : Draggable;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
