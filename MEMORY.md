# MEMORY.md — Village

> Resumen operativo para retomar el proyecto en otra sesión.
> Actualizar con cada cambio y mantenerlo en 50 líneas o menos.

Última actualización: 2026-11-10

## Estado actual

- Godot 4.7.2-stable, Forward Plus, viewport 1280x768.
- Rama: `refactor/combat-flow`. Mucho trabajo sin commitear; no asumir estado terminado.
- Escena principal: `res://scenes/Game.tscn`. Juego detenido.
- Editor: el addon `godot-ai` está desconectado al momento de este cambio; reconectar para verificar en runtime.
- Flujo: `Game._ready()` instancia 1 jugador y 2 enemigos, los registra en `BattleManager` y arranca.
- Turno del jugador: clic en el `Player` → `SkillBar` con sus skills → `skill_preview` sigue al mouse y devuelve objetivos → se ejecuta la skill y se descuenta una acción.
- Al terminar las acciones, los enemigos actúan y vuelve el turno del jugador.

## Sistemas implementados

- **Energía por batalla**: `BattleUnit.can_use_skill()` exige `current_energy >= energy_cost`; `Player.use_skill()` cobra una vez por lanzamiento y ejecuta por target; `regenerate_energy()` suma 10 al inicio del turno con tope en `max_energy`.
- **UI**: `CharacterStatus` tiene script propio (`set_hp`/`set_energy`); `CanvasLayer` sigue a la unidad seleccionada y actualiza HP/energía vía `unit_hp_changed` y `unit_energy_changed`.
- **Slots**: `SkillBar.refresh_availability()` deshabilita los que no alcanzan.
- **Fin de batalla**: `BattleUnit.unit_death_finished` se emite al terminar `on_death()`; `BattleManager` detecta victoria/derrota, espera las animaciones y emite `battle_ended(player_won)`. `Game` cambia directamente a `scenes/BattleResult.tscn` (destino provisorio, botón para volver a `Game.tscn`).

## Deuda técnica / pendientes

- `turn_started` nunca se emite.
- `actions_remaining` no registra qué jugador actuó (problema al agregar varios personajes).
- Cooldown no implementado (`Skill.is_on_cooldown()` siempre `false`).
- `Skill.requires_target` declarado pero sin uso.
- `GameManager.player_hp_changed` / `player_max_hp_changed` sin emitir.
- `PLayerHpLabel` quedó sin uso en `Game.tscn`.
- Cálculo de daño plano; `stats` (defence, accuracy, evasion, etc.) sin usar.
- `SelectionManager` duplica la selección de `BattleManager` y no se usa fuera de su script.
- Prints de debug y archivos legado (`BattleScene.tscn`, `battle_scene.gd`, `TestSkelleton.tscn`, `selector.gd`).

## Próximo paso recomendado

Definir el nuevo flujo de turnos (seguir atacando hasta quedarse sin energía o pasar turno). Backlog completo en `task.md`.

## Notas de continuidad

- Commits: `86346a3` (combate). El addon `godot-ai` y los docs (`AGENTS.md`, `MEMORY.md`, `task.md`) ya están versionados.
- Siguen sin commitear: eliminaciones de `World.tscn` / `Dungeon2d.tscn` y assets sin usar.
- Reglas y convenciones: `AGENTS.md` (incluye la sección 11 de buenas prácticas de código).
- Verificar ejecutando el juego desde el editor y leyendo la consola.
- No hacer commits sin pedido explícito.
