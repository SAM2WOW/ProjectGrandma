extends Control
@onready var ingredentLabel  = $IngredientLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	print("UI is ready")# Replace with function body.
	GameManager.gameEnd.connect(onGameEnd)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateIngredientLable(ingredientText: Array):
	var s
	ingredentLabel.text = ''
	for i in ingredientText.size():
		s = str(i+1)+ ' ' + ingredientText[i] + "\n"
		ingredentLabel.text += s
	

func onGameEnd():
	ingredentLabel.text = ''
