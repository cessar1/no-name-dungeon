# Tareas pendientes

> Backlog de ideas y mejoras para implementar más adelante.
>
> Cuando pidas **"quiero revisar las tareas pendientes"**, leo este archivo y te presento las tareas como opciones para que elijas cuál implementar.
>
> Ninguna tarea de esta lista se implementa sin que la elijas explícitamente.

## Contexto actual

- `PartyStatus` es un panel abajo-centro: fila de energía compartida arriba y 3 tarjetas de personaje (200x110) en una fila.
- Cada tarjeta muestra retrato, nombre, HP actual/máxima y barra de vida.
- La barra de skills cambia según el jugador seleccionado.
- La energía es un pool compartido de party (máximo 20); el turno sigue mientras la party pueda pagar alguna skill y termina al no poder o con "Pasar turno".

## Party (rama `feature/party-combat`)

- [x] **Estado persistente de party.** `PartyState` con hasta 3 miembros, progresión de party y migración del save viejo de 1 personaje.
- [x] **Spawn de la party y posiciones.** `combat.gd` instancia un jugador por miembro; 2 posiciones nuevas a la izquierda.
- [x] **Energía compartida.** Pool único de 20, arranca lleno y regenera 10 por turno; la barra de MP muestra el pool.
- [x] **Turnos por energía o pasar turno.** Sin `actions_remaining`; `party_can_act()` decide si sigue el turno y `PassTurnButton` permite cederlo.
- [x] **HP de todos visible y UI de party.** `PartyStatus` + `PartyMemberStatus` con el panel abajo-centro, energía compartida arriba y 3 tarjetas de personaje.

## Combate y turnos

- [x] **Atacar hasta quedarse sin energía o pasar el turno.**
  - La party puede seguir lanzando skills mientras quede energía compartida.
  - El turno termina cuando ningún miembro vivo puede pagar ninguna skill o al pulsar "Pasar turno".

- [x] **Cerrar el ciclo de batalla (victoria/derrota).**
  - `BattleManager` detecta victoria/derrota, espera la animación de muerte y emite `battle_ended(player_won)`.
  - `Game` cambia directamente a `scenes/BattleResult.tscn` cuando se emite `battle_ended`.
  - `BattleResult` muestra el resultado y un botón para volver a `Game.tscn` (destino provisorio).

- [x] **Preparar las acciones para varios personajes.**
  - Se eliminó `actions_remaining`; ya no hay límite de acciones por miembro.
  - La barra de skills sigue atada al jugador seleccionado.

## Escena previa al combate

- [ ] **Crear una escena de preparación antes del combate.**
  - Punto de partida para acciones fuera de batalla: gastar skill points, comprar, etc.
  - [x] Primer paso: `scenes/PreBattle.tscn` muestra los skill points y tiene un botón para iniciar `scenes/Game.tscn`.
  - [x] Segundo paso: `PreBattle` muestra HP, energía y skills del primer miembro (solo lectura); falta adaptarlo a toda la party.
  - [x] Tercer paso: pasivas visuales en `PreBattle`. Catálogo en `passives/*.tres` (`PassiveSkill`) y estado en `GameManager` (`learned_passives`, `learn_passive()`). Aún no modifican stats.
  - [x] Estado de party centralizado en `GameManager.party_state` (`PartyState` con miembros y progresión); valores iniciales de cada miembro desde `stats/player_base.tres` y `STARTING_SKILLS`. `PreBattle` y el combate leen de ahí.
  - [x] `combat.gd` instancia un `Player` por miembro de `GameManager.party_state`; `Player.tscn` ya no define stats/skills (con respaldo para ejecutar la escena sola).
  - [ ] Definir los efectos reales de las pasivas.
  - Definir si se compra con skill points, oro u otra moneda, y qué se puede comprar.
  - [x] Los datos persistentes entre escenas se guardan en `GameManager`.
  - [x] Persistencia en `user://player_save.tres`: `PartyState` (miembros con stats/skills + skill points y pasivas de party). Se guarda al sumar puntos o aprender pasivas; HP/energía actuales no persisten.
  - [x] Entrada: el menú de inicio es la primera escena; Jugar lleva a `PreBattle` y Salir cierra el juego. `PreBattle` antecede al combate.
  - [x] Salida: `BattleResult` vuelve a `PreBattle`; el ciclo `PreBattle → Game → BattleResult → PreBattle` queda cerrado.
  - [x] Menú de inicio: `scenes/StartMenu.tscn` con título, Jugar y Salir; es la escena principal.

## Personajes y UI

- [x] **Vida visible de todos los personajes.**
  - `PartyStatus` muestra una tarjeta por miembro con retrato, nombre, HP actual/máxima y barra de vida.
  - La barra de energía sigue siendo única para la party y va encima de las tarjetas.
  - [x] Diseño de la UI de party definido e implementado (tarjetas abajo-centro).

- [ ] **Indicador visual de la tarjeta seleccionada.**
  - Destacar la tarjeta del personaje que tiene el turno/selección actual.
  - Definir el estilo (borde, color o resaltado) antes de implementarlo.

- [ ] **Tarjeta placeholder para personajes faltantes.**
  - Si la party tiene menos de 3 miembros, la tarjeta libre muestra un candado y el texto "Desbloquear".
  - Hoy `PartyMemberStatus.show_empty()` solo deja la tarjeta vacía.
  - Definir qué hace el botón "Desbloquear" antes de implementarlo.

- [x] **Adaptar `CharacterStatus` a varios personajes.**
  - Resuelto con `PartyStatus` + `PartyMemberStatus`; `CharacterStatus` fue eliminado.

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

- [x] Eliminar `PLayerHpLabel` de `scenes/Game.tscn` (quedó sin uso).
- [x] Eliminar los signals `GameManager.player_hp_changed` y `player_max_hp_changed`: no se emitían ni conectaban en ningún lado.
- [x] Eliminar el autoload `SelectionManager`: no se usaba fuera de su propio script y duplicaba la selección de `BattleManager`. También se quitó la señal `enemy_selected`, sin emisor ni conexiones.

## Decisiones pendientes

- [ ] Confirmar si los enemigos deben gastar energía (hoy la ignoran).
- [x] Definido: si ningún miembro vivo puede pagar ninguna skill, el turno pasa solo a los enemigos.
