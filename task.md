# Tareas pendientes

> Backlog de ideas y mejoras para implementar más adelante.
>
> Cuando pidas **"quiero revisar las tareas pendientes"**, leo este archivo y te presento las tareas como opciones para que elijas cuál implementar.
>
> Ninguna tarea de esta lista se implementa sin que la elijas explícitamente.

## Contexto actual

- `CharacterStatus` muestra HP y energía de la unidad seleccionada.
- La barra de skills cambia según el jugador seleccionado.
- Hoy hay una acción por jugador por turno (`actions_remaining = active_players.size()`).

## Combate y turnos

- [ ] **Atacar hasta quedarse sin energía o pasar el turno.**
  - Hoy el turno del jugador termina después de una acción.
  - Nuevo: el jugador puede seguir lanzando skills mientras tenga energía.
  - El turno termina al quedarse sin energía o al elegir "pasar turno".
  - Definir cómo se pasa el turno (botón/tecla) y cómo se combina con varios personajes.

- [x] **Cerrar el ciclo de batalla (victoria/derrota).**
  - `BattleManager` detecta victoria/derrota, espera la animación de muerte y emite `battle_ended(player_won)`.
  - `Game` cambia directamente a `scenes/BattleResult.tscn` cuando se emite `battle_ended`.
  - `BattleResult` muestra el resultado y un botón para volver a `Game.tscn` (destino provisorio).

- [ ] **Preparar las acciones para varios personajes.**
  - `actions_remaining` no registra qué jugador actuó; con 2 jugadores se podría usar el mismo dos veces.
  - Mantener la barra de skills atada al jugador seleccionado.

## Escena previa al combate

- [ ] **Crear una escena de preparación antes del combate.**
  - Punto de partida para acciones fuera de batalla: gastar skill points, comprar, etc.
  - [x] Primer paso: `scenes/PreBattle.tscn` muestra los skill points y tiene un botón para iniciar `scenes/Game.tscn`.
  - [x] Segundo paso: `PreBattle` muestra HP, energía y skills del jugador (solo lectura), tomados de `scenes/Player.tscn`.
  - [x] Tercer paso: pasivas visuales en `PreBattle`. Catálogo en `passives/*.tres` (`PassiveSkill`) y estado en `GameManager` (`learned_passives`, `learn_passive()`). Aún no modifican stats.
  - [x] Estado del jugador centralizado en `GameManager.player_state` (`PlayerState` con stats y skills); valores iniciales desde `stats/player_base.tres` y `STARTING_SKILLS`. `PreBattle` y el combate leen de ahí.
  - [x] `combat.gd` inyecta `GameManager.player_state` en el `Player` y `Player.tscn` ya no define stats/skills (con respaldo para ejecutar la escena sola).
  - [ ] Definir los efectos reales de las pasivas.
  - Definir si se compra con skill points, oro u otra moneda, y qué se puede comprar.
  - [x] Los datos persistentes entre escenas se guardan en `GameManager`.
  - [x] Persistencia en `user://player_save.tres`: `PlayerState` (stats, skills, pasivas y skill points). Se guarda al sumar puntos o aprender pasivas; HP/energía actuales no persisten.
  - [ ] Definir cómo se entra y se sale de la escena, y cómo se inicia el combate.

## Personajes y UI

- [ ] **Vida visible de todos los personajes.**
  - Hoy solo se ve la vida del personaje seleccionado.
  - Cuando haya varios personajes, cada uno debe mostrar su HP en pantalla todo el tiempo.
  - Definir si la energía también se muestra permanentemente por personaje o solo para el seleccionado.

- [ ] **Adaptar `CharacterStatus` a varios personajes.**
  - Evaluar si se instancia uno por personaje o si se usa otro contenedor de UI.

## Skills

- [ ] **Cooldown de skills.**
  - `Skill.is_on_cooldown()` siempre devuelve `false`; `wind_strike.tres` ya tiene `cooldown = 1`.
  - Definir dónde se guarda el estado del cooldown (unidad, skill o batalla).

- [ ] **Usar `requires_target`.**
  - Está declarado en `Skill` pero no se usa; hoy toda skill abre el preview de objetivos.

- [ ] **Feedback al no poder usar una skill.**
  - Hoy, sin energía suficiente, el slot queda deshabilitado y no pasa nada más.
  - Evaluar si hace falta un aviso visual o sonoro.

## Limpieza

- [x] **Eliminar archivos que ya no estén en uso.**
  - Revisar uno a uno y preguntar siempre antes de borrar.
  - Eliminados: `BattleScene.tscn`, `battle_scene.gd`, `scenes/skill.tscn`, `scenes/selector.gd`, `scenes/World.tscn` y `scenes/Dungeon2d.tscn`.
  - `TestSkelleton.tscn` ya no existe en disco.
  - Limpiados bloques comentados y prints de debug en los scripts de combate.
  - Pendiente (borrado manual): assets nuevos sin uso (`HealSlot.png`, `Panel.png`, `mixkit-hard-horror-hit-drum-565.wav`), ya versionados.

- [ ] Eliminar `PLayerHpLabel` de `scenes/Game.tscn` (quedó sin uso).
- [ ] Revisar los signals `GameManager.player_hp_changed` y `player_max_hp_changed`: no se emiten en ningún lado.
- [ ] Revisar el autoload `SelectionManager`: no se usa fuera de su propio script y duplica la selección de `BattleManager`.

## Decisiones pendientes

- [ ] Confirmar si los enemigos deben gastar energía (hoy la ignoran).
- [ ] Definir qué pasa cuando un jugador no tiene ninguna skill usable por falta de energía.
