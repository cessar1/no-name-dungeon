class_name PlayerState extends Resource

@export var stats: Stat
@export var skills: Array[Skill]

# Progresión a nivel party. Se mantiene aquí solo para migrar saves anteriores;
# el estado activo vive en PartyState.
@export var learned_passives: Array[PassiveSkill]
@export var skill_points: int = 0
