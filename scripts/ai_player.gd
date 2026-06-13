extends Node

# Zwróć losową pustą komórkę
func get_next_move(board: Array[Array]) -> Array:
	var empty_cells: Array = []
	
	# Znaleziono wszystkie puste komórki
	for i in range(3):
		for j in range(3):
			if board[i][j] == 0:
				empty_cells.append([i, j])
	
	# Jeśli nie ma pustych komórek, zwróć pustą tablicę
	if empty_cells.is_empty():
		return []
	
	# Zwróć losową pustą komórkę
	var random_index = randi() % empty_cells.size()
	return empty_cells[random_index]
