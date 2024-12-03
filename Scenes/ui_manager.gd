extends Control

@onready var GAME: Node2D = $".."

@onready var MENU_UI : Panel = $Menu
@onready var GAME_OVERLAY : Panel = $"Game Overlay"
@onready var GAMEOVER_UI : Panel = $"Game Over Screen"
@onready var AMMO_BAR : TextureProgressBar = $"Game Overlay/Ammo Bar"
@onready var SCORE_OVERLAY : Label = $"Game Overlay/Score"
@onready var SCORE : Label = $"Game Over Screen/Score"

var score
var player
var playerMag 
var playerAmmo
var playerInfo : bool = false


func set_game_ui():
	MENU_UI.hide()
	GAMEOVER_UI.hide()
	GAME_OVERLAY.show()
	set_process(true)
	playerInfo = false


func set_menu_ui():
	GAME_OVERLAY.hide()
	GAMEOVER_UI.hide()
	MENU_UI.show()
	set_process(false)


func set_gameover_ui():
	GAME_OVERLAY.hide()
	MENU_UI.hide()
	SCORE.text = str(GAME.score)
	GAMEOVER_UI.show()
	set_process(false)


	
func _process(_delta: float) -> void:
	set_ui_size()
	if not playerInfo:
		player = GAME.get_player()
		playerInfo = true
	if player:
		playerMag = player.MAGAZINE_SIZE
		playerAmmo = player.ammo
		AMMO_BAR.value = playerAmmo
		AMMO_BAR.max_value = playerMag
	SCORE_OVERLAY.text = str(GAME.score)


func set_ui_size():
	size = GAME.screenSize
