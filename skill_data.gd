class_name SkillData extends Resource

# Es posible modificar las propiedaes de un recurso y que persista?
# Si pero no me parece conveniente si es para guardar el estado ya que se si comparte
# El estado podria ser compartido y no es algo que se busque


@export var  id : int
@export var label : String
@export var damage : String
@export var radius : float
@export var energy_cost: float
@export var texture : Texture2D
