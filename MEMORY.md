# MEMORY.md — Village

> Resumen operativo para retomar el proyecto en otra sesión.
> Actualizar con cada cambio y mantenerlo en 50 líneas o menos.

Última actualización: 2026-11-15

## Estado actual

- Godot 4.7.2-stable, Forward Plus, viewport 1280x768.
- Rama activa: `feature/leveling-zones` (desde `main` en `c72fa15`). Ciclo: `StartMenu` → `Map` → `Game` → `BattleResult` → `Map`; `PreBattle` quedó fuera del ciclo.
- Editor `godot-ai` conectado; verificar con `--check-only`, `--import`, arranque headless y `project_run`.
- Combate de party implementado (partes 1-5, commiteado):
  1. Estado de party persistente (`PartyState`).
  2. Spawn de hasta 3 miembros y posiciones a la izquierda.
  3. Energía compartida de party (`PartyEnergy`, máximo 20).
  4. Turnos por energía agotada o por pasar turno.
  5. HP de todos en pantalla y barra de MP compartida.
- Turno actual: clic en un `Player` → `SkillBar` → preview → skill. No hay límite de acciones por miembro; el turno sigue mientras la party pueda pagar alguna skill y termina al no poder o con el botón "Pasar turno".

## Sistemas implementados

- **PartyState** (`party_state.gd`): `members: Array[PlayerState]`, `shared_energy_max = 20`, `skill_points` y `learned_passives` de party, `MAX_MEMBERS = 3`. `GameManager.party_state` es el dueño; `player_state` es un getter de solo lectura al primer miembro (compatibilidad con `PreBattle`/`Player`).
- **Migración**: un save viejo `PlayerState` se convierte a `PartyState` conservando stats/skills del primer miembro y la progresión; se completa hasta 3 miembros base. El save actual ya está migrado.
- **Energía compartida** (`party_energy.gd`): pool de batalla `current/max`, arranca lleno (20) y regenera 10 por turno (tope 20). `Player.can_use_skill()`/`use_skill()` gastan del pool; los enemigos usan energía propia. `BattleManager.party_energy` se asigna al registrar cada `Player`.
- **Turnos**: sin `actions_remaining`. Tras cada skill, `party_can_act()` decide si sigue el turno; si ningún miembro vivo puede pagar ninguna skill, `change_turn()`. El botón `PassTurnButton` (UI) llama a `finish_player_turn()` para ceder el turno.
- **Spawn**: `combat.gd` instancia un `Player` por miembro en `Positions/0`, `PartyPosition1` (300,360) y `PartyPosition2` (300,546); esas posiciones se excluyen del pool de enemigos.
- **UI**: panel `PartyStatus` abajo-centro (636x163) con la fila de energía arriba ("Energía de party", `actual / máximo` y barra) y 3 tarjetas de 200x110 en una fila. Cada `PartyMemberStatus` muestra retrato 56x56, nombre, `HP actual / máxima` y barra. `CanvasLayer.setup_party()` crea las 3 tarjetas desde `active_players` (las faltantes con `show_empty()`); el MP se actualiza con `party_energy.changed`. `CharacterStatus` fue eliminado.
- **Slots**: `SkillBar.refresh_availability()` deshabilita los que no alcanzan según `can_use_skill()`.
- **Pasivas visuales**: `passive_skill.gd` + `passives/*.tres`; catálogo y aprendizaje en `GameManager`; no modifican stats.
- **Menú/ciclo**: `StartMenu` → `Map` → `Game` → `BattleResult` → `Map`. Fin de batalla por `battle_ended(player_won)`.
- **Mapa (esqueleto)**: `scenes/Map.tscn` + `map.gd` con 5 zonas de prueba conectadas, panel de info y "Entrar" al combate; sin desbloqueo.
- **Zonas**: `zone_data.gd` (`ZoneData`: nombre, nivel, enemigos provisionales) + `scenes/zone_button.gd`; `zones/bosque.tres`, `zones/ruinas.tres` y `zones/fortaleza.tres` con niveles 1/3/5. Cueva y Costa siguen como placeholders.

## Deuda técnica / pendientes

- `BattleUnit.regenerate_energy()` quedó sin uso para jugadores.
- `turn_started` nunca se emite; cooldown sin implementar; `requires_target` sin uso.
- `scenes/combat.gd` precarga `enemy.tscn` en minúscula (warning de case).
- `project.godot` referencia `res://icon.svg`, que no existe (error preexistente).
- `PreBattle` todavía resume solo al primer miembro.

## Próximo paso recomendado

Datos de zona listos en `feature/leveling-zones`. Próximo: definir el sistema de enemigos por zona (`EnemyData`) y la modal de zona; hoy la composición del combate sigue fija.

## Notas de continuidad

- Save en `user://player_save.tres` (`PartyState`); HP/energía actuales no persisten.
- No hacer commit ni push sin pedido explícito.
