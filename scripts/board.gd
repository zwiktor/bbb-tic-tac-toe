extends Node

# Board representation: 0=pusty, 1=X, 2=O
var board: Array[Array] = []

func _ready() -> void:
	# Inicjalizuj planszę
	reset()
	
	# ===== TEST RĘCZNY =====
	print("=== TEST GRY W KÓŁKO I KRZYŻYK ===")
	print("Początkowy stan planszy:")
	print_board()
	
	# Test prawidłowych ruchów
	print("\n--- Test 1: Prawidłowe ruchy S---")
	make_move(0, 0, 1)  # X w (0,0)
	print("Po ruchu X na (0,0):")
	print_board()
	
	make_move(1, 1, 2)  # O w (1,1)
	print("Po ruchu O na (1,1):")
	print_board()
	
	make_move(0, 1, 1)  # X w (0,1)
	print("Po ruchu X na (0,1):")
	print_board()
	
	# Test nieprawidłowego ruchu
	print("\n--- Test 2: Ruch na zajęte pole ---")
	var result = is_valid_move(0, 0)
	print("Czy (0,0) jest dostępne? %s" % result)
	
	# Test sekwencji gry
	print("\n--- Test 3: Pełna sekwencja gry ---")
	reset()
	make_move(0, 0, 1)  # X
	make_move(1, 1, 2)  # O
	make_move(0, 2, 1)  # X
	make_move(2, 1, 2)  # O
	make_move(0, 1, 1)  # X - wygrana!
	
	print("Planszy po grze:")
	print_board()
	print("Zwycięzca: %s" % get_winner_text(get_winner()))
	print("Czy remis? %s" % is_draw())
	
	# Test remisu
	print("\n--- Test 4: Remis ---")
	reset()
	make_move(0, 0, 1)  # X
	make_move(0, 1, 2)  # O
	make_move(0, 2, 1)  # X
	make_move(1, 0, 2)  # O
	make_move(1, 1, 1)  # X
	make_move(2, 0, 2)  # O
	make_move(1, 2, 1)  # X
	make_move(2, 2, 2)  # O
	make_move(2, 1, 1)  # X
	
	print("Planszy po grze (remis):")
	print_board()
	print("Zwycięzca: %s" % get_winner_text(get_winner()))
	print("Czy remis? %s" % is_draw())

func _process(delta: float) -> void:
	pass

# Resetuj planszę - wyczyść wszystkie pola
func reset() -> void:
	board = []
	for i in range(3):
		var row: Array = []
		for j in range(3):
			row.append(0)
		board.append(row)
	print("Plansza została wyczyszczona")

# Sprawdź czy ruch jest prawidłowy
func is_valid_move(x: int, y: int) -> bool:
	# Sprawdź czy współrzędne są w zasięgu
	if x < 0 or x > 2 or y < 0 or y > 2:
		print("Błąd: Współrzędne poza zasięgiem! (%d, %d)" % [x, y])
		return false
	
	# Sprawdź czy pole jest puste
	if board[x][y] != 0:
		print("Błąd: Pole (%d, %d) już zajęte!" % [x, y])
		return false
	
	return true

# Wykonaj ruch
func make_move(x: int, y: int, player: int) -> bool:
	if not is_valid_move(x, y):
		return false
	
	board[x][y] = player
	var player_name = "X" if player == 1 else "O"
	print("Gracz %s wykonał ruch na (%d, %d)" % [player_name, x, y])
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

# Funkcja pomocnicza do wydruku planszy w debuggerze
func print_board() -> void:
	print("  0 1 2")
	for i in range(3):
		var row = ""
		for j in range(3):
			var symbol = "."
			if board[i][j] == 1:
				symbol = "X"
			elif board[i][j] == 2:
				symbol = "O"
			row += symbol + " "
		print("%d %s" % [i, row])

# Funkcja pomocnicza do konwersji wyniku na tekst
func get_winner_text(winner: int) -> String:
	match winner:
		0:
			return "BRAK"
		1:
			return "X"
		2:
			return "O"
		_:
			return "NIEZNANY"
