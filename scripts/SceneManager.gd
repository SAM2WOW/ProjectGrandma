extends Node2D

var currentScene = null
var root
# Called when the node enters the scene tree for the first time.
func _ready():
	 # Replace with function body.
	print("Scene Manager is ready")
	root = get_tree().root
	currentScene = root.get_child(root.get_child_count()-1)
	#print("Current Scene:",currentScene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func SwitchScene(filePath):
	call_deferred("DeferredSwitchScene", filePath)
	#get_tree().change_scene_to_file(filePath)
	
func DeferredSwitchScene(filePath):


	#currentScene.free()
	root.remove_child(currentScene)
	print(root)
	var scene = load(filePath)
	currentScene = scene.instantiate()
	root.add_child(currentScene)
	#get_tree().current_scene = currentScene
	
func ReloadCurrentScene():
	var scenePath = Global.gameManager.stageScenes[Global.currentStage]
	#print(scenePath)
	SwitchScene(scenePath)
