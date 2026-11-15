class_name PartyState extends Resource

const MAX_MEMBERS := 3
const DEFAULT_SHARED_ENERGY_MAX := 20.0

@export var members: Array[PlayerState] = []
@export var shared_energy_max: float = DEFAULT_SHARED_ENERGY_MAX

# Progresión compartida por toda la party.
@export var learned_passives: Array[PassiveSkill] = []
@export var skill_points: int = 0
