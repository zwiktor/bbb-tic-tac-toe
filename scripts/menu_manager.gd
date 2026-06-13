extends Control

var selected_mode: String = "vs_ai"
var selected_symbol: int = 1

func _ready() -> void:
	# Zakładamy, że przyciski są dziećmi MenuContainer
	$ModeVsPlayerBtn.pressed.connect(_on_mode_vs_player)
	$ModeVsAIBtn.pressed.connect(_on_mode_vs_ai)
	$SymbolXBtn.pressed.connect(_on_symbol_x)
	$SymbolOBtn.pressed.connect(_on_symbol_o)
	$StartBtn.pressed.connect(_on_start_game)

func _on_mode_vs_player() -> void:
	selected_mode = "vs_player"
	$ModeVsPlayerBtn.modulate.a = 0.5
	$ModeVsAIBtn.modulate.a = 1.0

func _on_mode_vs_ai() -> void:
	selected_mode = "vs_ai"
	$ModeVsAIBtn.modulate.a = 0.5
	$ModeVsPlayerBtn.modulate.a = 1.0

func _on_symbol_x() -> void:
	selected_symbol = 1
	$SymbolXBtn.modulate.a = 0.5
	$SymbolOBtn.modulate.a = 1.0

func _on_symbol_o() -> void:
	selected_symbol = 2
	$SymbolOBtn.modulate.a = 0.5
	$SymbolXBtn.modulate.a = 1.0

func _on_start_game() -> void:
	GameState.start_game(selected_mode, selected_symbol)
	visible = false
