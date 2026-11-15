class_name PartyEnergy extends RefCounted

signal changed(current_energy: float, max_energy: float)

var current_energy: float = 0.0
var max_energy: float = 0.0

# Arranca el pool lleno al iniciar la batalla.
func setup(max_value: float) -> void:
	max_energy = max_value
	current_energy = max_energy
	changed.emit(current_energy, max_energy)

func can_afford(cost: float) -> bool:
	return current_energy >= cost

func spend(cost: float) -> void:
	current_energy = maxf(current_energy - cost, 0.0)
	changed.emit(current_energy, max_energy)

func regenerate(amount: float) -> void:
	current_energy = minf(current_energy + amount, max_energy)
	changed.emit(current_energy, max_energy)
