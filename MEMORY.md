# MEMORY.md — Village

> Resumen operativo para retomar el proyecto en otra sesión.
> Actualizar con cada cambio y mantenerlo en 50 líneas o menos.

Última actualización: 2026-11-13

## Estado actual

- Godot 4.7.2-stable, Forward Plus, viewport 1280x768.
- Rama activa: `feature/pre-combat-scene`. `scenes/PreBattle.tscn` es la escena principal: muestra skill points, HP/energía/skills desde `GameManager.player_state` y pasivas que se aprenden con puntos; botón a `Game.tscn`. Verificado en headless.
- Escena principal: `res://scenes/PreBattle.tscn`. Juego detenido.
- Editor: addon `godot-ai` conectado, pero en esta sesión sus herramientas MCP no están expuestas al agente; verificar con Godot headless (`--check-only` y `--script`).
- Flujo: `Game._ready()` instancia 1 jugador y 2 enemigos, los registra en `BattleManager` y arranca.
- Turno del jugador: clic en el `Player` → `SkillBar` con sus skills → `skill_preview` sigue al mouse y devuelve objetivos → se ejecuta la skill y se descuenta una acción.
- Al terminar las acciones, los enemigos actúan y vuelve el turno del jugador.

## Sistemas implementados

- **Energía por batalla**: `BattleUnit.can_use_skill()` exige `current_energy >= energy_cost`; `Player.use_skill()` cobra una vez por lanzamiento y ejecuta por target; `regenerate_energy()` suma 10 al inicio del turno con tope en `max_energy`.
- **UI**: `CharacterStatus` tiene script propio (`set_hp`/`set_energy`); `CanvasLayer` sigue a la unidad seleccionada y actualiza HP/energía vía `unit_hp_changed` y `unit_energy_changed`.
- **Slots**: `SkillBar.refresh_availability()` deshabilita los que no alcanzan.
- **Pasivas visuales**: `passive_skill.gd` (`PassiveSkill`) + `passives/*.tres`; `GameManager.PASSIVE_CATALOG`, `learned_passives` y `learn_passive()` (descuenta puntos y emite `skill_points_changed`). `PreBattle` instancia `scenes/passive_row.tscn` por pasiva y `scenes/skill_line.tscn` por skill; deshabilita las aprendidas. No modifican stats todavía.
- **Estado del jugador**: `player_state.gd` (`PlayerState` con `stats`, `skills`, `learned_passives` y `skill_points`) en `GameManager.player_state`. Se carga de `user://player_save.tres` al iniciar; si no existe, se crea desde `stats/player_base.tres` (duplicado) y `GameManager.STARTING_SKILLS`. `save_state()` se llama al sumar puntos o aprender pasivas. `PreBattle` lee de ahí y `combat.gd` inyecta `stats`/`skills` en el `Player` antes de agregarlo al árbol; `Player.tscn` ya no define esos datos.
- **Fin de batalla**: `BattleUnit.unit_death_finished` se emite al terminar `on_death()`; `BattleManager` detecta victoria/derrota, espera las animaciones y emite `battle_ended(player_won)`. `Game` cambia a `scenes/BattleResult.tscn` y su botón vuelve a `PreBattle`, cerrando el ciclo `PreBattle → Game → BattleResult → PreBattle`.

## Deuda técnica / pendientes

- `turn_started` nunca se emite.
- `actions_remaining` no registra qué jugador actuó (problema al agregar varios personajes).
- Cooldown no implementado (`Skill.is_on_cooldown()` siempre `false`).
- `Skill.requires_target` declarado pero sin uso.
- `GameManager.player_hp_changed` / `player_max_hp_changed` sin emitir.
- `PLayerHpLabel` quedó sin uso en `Game.tscn`.
- Cálculo de daño plano; `stats` (defence, accuracy, evasion, etc.) sin usar.
- `SelectionManager` duplica la selección de `BattleManager` y no se usa fuera de su script.
- `GameManager.enemy_selected` quedó sin emisor tras eliminar `selector.gd`.
- Código sin uso: `skill_preview.gd` (`collision`, `is_single_target`, `get_targets()`) y `enemy.gd::_on_input_event()`.
- `scenes/combat.gd` precarga `res://scenes/enemy.tscn` en minúscula; en plataformas case-sensitive falla (Godot ya emite warning).
- `Player.tscn` ya no define `stats`/`skills`: `combat.gd` los inyecta desde `GameManager.player_state` y `Player._ready()` usa ese mismo estado como respaldo para ejecutar la escena sola (F6).

## Próximo paso recomendado

Definir los efectos reales de las pasivas o crear el menú de inicio. Backlog completo en `task.md`.

## Notas de continuidad

- Commits: `86346a3` (combate). El addon `godot-ai` y los docs (`AGENTS.md`, `MEMORY.md`, `task.md`) ya están versionados.
- Assets nuevos versionados: `assets/ui/HealSlot.png`, `assets/ui/Panel.png` y `assets/sounds/mixkit-hard-horror-hit-drum-565.wav`; aún no se usan en escenas. Si no se usan, el usuario los borra manualmente.
- Datos persistentes: `user://player_save.tres` guarda `PlayerState` (stats, skills, pasivas y skill points). HP/energía actuales no se guardan. Las referencias a `.tres` de skills/pasivas se rompen si se mueven o renombran esos archivos.
- Reglas y convenciones: `AGENTS.md` (incluye la sección 11 de buenas prácticas de código).
- Verificar ejecutando el juego desde el editor y leyendo la consola.
- No hacer commits sin pedido explícito.
