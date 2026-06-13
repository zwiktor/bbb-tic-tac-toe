extends Node

# Globalne ustawienia dostępne z każdego skryptu
var game_mode: String = "vs_ai"
var player_symbol: int = 1 # 1=X, 2=O

signal game_started

func start_game(mode: String, symbol: int):
	game_mode = mode
	player_symbol = symbol
	game_started.emit()