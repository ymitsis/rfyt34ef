# Global game state
# Διατηρεί την τρέχουσα τιμή ενέργειας, και εκπέμπει signal όταν η ενέργεια αλλάζει
extends Node

signal energy_changed(int)

signal zoom_changed(value)

const MAX_ENERGY: int = 999
const MIN_ENERGY: int = 0

var energy: int: set = set_energy
# Setter ενέργειας: εφαρμόζει clamp στα επιτρεπτά όρια και εκπέμπει signal μόνο όταν η τιμή αλλάζει πραγματικά
func set_energy(value: int):
	value = clamp(value, MIN_ENERGY, MAX_ENERGY)
	if value == energy: return
	energy = value
	energy_changed.emit(energy)
	
var board_zoom_normalized: float: set = set_board_zoom_normalized
# Setter board zoom
func set_board_zoom_normalized(value: float):
	board_zoom_normalized = value
	zoom_changed.emit(board_zoom_normalized)
