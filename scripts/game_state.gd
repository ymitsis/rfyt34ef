extends Node

signal energy_changed(int)

const MAX_ENERGY: int = 999
const MIN_ENERGY: int = 0

var energy: int: set = set_energy

func set_energy(value: int) -> void:
	value = clamp(value, MIN_ENERGY, MAX_ENERGY)
	if value == energy: return
	energy = value
	energy_changed.emit(energy)
#tst
