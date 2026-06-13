extends Control

# Board representation: 0=pusty, 1=X, 2=O
var board: Array[Array] = []
var current_player: int = 1  # 1=X, 2=O
var game_over: bool = false
var ai_player = preload("res://scripts/ai_player.gd").new()

func _ready() -> void:
	# Ukryj grę na starcie, czekaj na sygnał z GameState
	visible = false
	GameState.game_started.connect(_on_game_started_signal)

	# Połącz przyciski gry (GameContainer)
	for i in range(3):
		for j in range(3):
			var button_index = i * 3 + j
			var button_name = "Button" if button_index == 0 else "Button%d" % (button_index + 1)
			var button = get_node("GridContainer/%s" % button_name)
			button.pressed.connect(_on_button_pressed.bindv([i, j]))
	
	# Połącz reset button
	var reset_btn = get_node("ResetButton")
	reset_btn.pressed.connect(_on_reset_pressed)

func _on_game_started_signal() -> void:
	visible = true
	reset_game()

# Obsługa kliknięcia przycisku gry
func _on_button_pressed(x: int, y: int) -> void:
	if game_over:
		return
	
	if GameState.game_mode == "vs_ai" and current_player != GameState.player_symbol:
		return
	
	if make_move(x, y, current_player):
		update_button_ui(x, y)
		
		# Sprawdzenie końca gry
		var winner = get_winner()
		if winner != 0:
			game_over = true
			get_node("StatusLabel").text = "Player %s WINS!" % ("X" if winner == 1 else "O")
			SoundManager.play_win_sound()
			return
		
		if is_draw():
			game_over = true
			get_node("StatusLabel").text = "It's a DRAW!"
			SoundManager.play_win_sound()
			return
		
		# Zmiana gracza
		current_player = 2 if current_player == 1 else 1
		update_ui()
		
		# Jeśli AI ma zagrać
		if GameState.game_mode == "vs_ai" and current_player != GameState.player_symbol:
			await get_tree().create_timer(0.5).timeout
			_ai_make_move()

# AI wykonuje ruch
func _ai_make_move() -> void:
	if game_over:
		return
	
	var move = ai_player.get_next_move(board)
	
	if move.is_empty():
		return
	
	var x = move[0]
	var y = move[1]
	
	if make_move(x, y, current_player):
		update_button_ui(x, y)
		
		# Sprawdzenie końca gry
		var winner = get_winner()
		if winner != 0:
			game_over = true
			get_node("StatusLabel").text = "Player %s WINS!" % ("X" if winner == 1 else "O")
			return
		
		if is_draw():
			game_over = true
			get_node("StatusLabel").text = "It's a DRAW!"
			return
		
		# Zmiana gracza
		current_player = 2 if current_player == 1 else 1
		update_ui()

# Obsługa reset buttona
func _on_reset_pressed() -> void:
	reset_game()

# Resetuj grę
func reset_game() -> void:
	reset()
	SoundManager.play_start_sound()
	current_player = 1
	game_over = false
	
	# Wyczyść wszystkie labele przycisków
	for i in range(3):
		for j in range(3):
			var button_index = i * 3 + j
			var button_name = "Button" if button_index == 0 else "Button%d" % (button_index + 1)
			var button = get_node("GridContainer/%s" % button_name)
			if button.has_node("Label"):
				button.get_node("Label").text = ""
	
	update_ui()
	
	# Jeśli AI zaczyna (gracz wybrał O)
	if GameState.game_mode == "vs_ai" and GameState.player_symbol == 2:
		_ai_make_move()

# Aktualizuj UI
func update_ui() -> void:
	if not game_over:
		get_node("StatusLabel").text = "Player %s Turn" % ("X" if current_player == 1 else "O")

# Aktualizuj label przycisku
func update_button_ui(x: int, y: int) -> void:
	var button_index = x * 3 + y
	var button_name = "Button" if button_index == 0 else "Button%d" % (button_index + 1)
	var button = get_node("GridContainer/%s" % button_name)
	var symbol = "X" if board[x][y] == 1 else "O"
	if button.has_node("Label"):
		button.get_node("Label").text = symbol
	
	# Wywołanie dźwięku przez Globalny SoundManager
	if board[x][y] == 1:
		SoundManager.play_x_sound()
	elif board[x][y] == 2:
		SoundManager.play_o_sound()

# Resetuj planszę - wyczyść wszystkie pola
func reset() -> void:
	board = []
	for i in range(3):
		var row: Array[int] = []
		for j in range(3):
			row.append(0)
		board.append(row)

# Sprawdź czy ruch jest prawidłowy
func is_valid_move(x: int, y: int) -> bool:
	# Sprawdź czy współrzędne są w zasięgu
	if x < 0 or x > 2 or y < 0 or y > 2:
		return false
	
	# Sprawdź czy pole jest puste
	if board[x][y] != 0:
		return false
	
	return true

# Wykonaj ruch
func make_move(x: int, y: int, player: int) -> bool:
	if not is_valid_move(x, y):
		return false
	
	board[x][y] = player
	return true

# Sprawdź zwycięzcę
func get_winner() -> int:
	# Sprawdź wiersze
	for i in range(3):
		if board[i][0] != 0 and board[i][0] == board[i][1] and board[i][1] == board[i][2]:
			return board[i][0]
	
	# Sprawdź kolumny
	for j in range(3):
		if board[0][j] != 0 and board[0][j] == board[1][j] and board[1][j] == board[2][j]:
			return board[0][j]
	
	# Sprawdź przekątną \
	if board[0][0] != 0 and board[0][0] == board[1][1] and board[1][1] == board[2][2]:
		return board[0][0]
	
	# Sprawdź przekątną /
	if board[0][2] != 0 and board[0][2] == board[1][1] and board[1][1] == board[2][0]:
		return board[0][2]
	
	# Brak zwycięzcy
	return 0

# Sprawdź czy gra zakończyła się remisem
func is_draw() -> bool:
	# Jeśli jest zwycięzca, to nie remis
	if get_winner() != 0:
		return false
	
	# Sprawdź czy wszystkie pola są zajęte
	for i in range(3):
		for j in range(3):
			if board[i][j] == 0:
				return false
	
	return true
