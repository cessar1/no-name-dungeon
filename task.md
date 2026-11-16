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

- [ ] **Renombrar y rediseñar la escena previa al combate como hub de party.**
  - La escena va a tener otro nombre (a definir).
  - Debe mostrar los miembros que tenemos y permitir interactuar con ellos: ver estadísticas, skills, pasivas, etc.
  - Interacciones, layout y alcance pendientes de definir; sujeto a cambios.

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

## Habilidades pasivas y árbol de talentos

- [ ] **Sección de pasivas como árbol de talentos expandible.**
  - Representación inicial en forma de nodos o árbol de talentos, con expansión en todas las direcciones.
  - Al aprender pasivas aparecen nuevas habilidades disponibles.
  - Relacionado con "Definir los efectos reales de las pasivas" (sección Escena previa al combate).
  - Alcance, navegación, reglas de desbloqueo y presentación pendientes de definir; sujeto a cambios.

## Mapa y exploración

- [ ] **Sección de mapa explorable con nodos.**
  - El mapa se recorre por zonas representadas como nodos; se visitan para superar los desafíos de cada una.
  - [x] Primer paso (esqueleto): `scenes/Map.tscn` con 5 zonas de prueba conectadas, panel de información y botón "Entrar" que inicia el combate. Sin datos reales, desbloqueo ni estilos finales.
  - [x] Ciclo: `StartMenu` → `Map` → `Game` → `BattleResult` → `Map`. `PreBattle` queda fuera del ciclo por ahora (se conserva en disco).
  - [ ] **Ventana modal de zona.** Reemplazar el panel lateral de información por una ventana modal con la información de la zona y el botón "Entrar". Contenido y estilo a definir.
  - Tipos de desafío, orden y desbloqueo de zonas, y presentación pendientes de definir; sujeto a cambios.

- [ ] **Salas dentro de cada zona.**
  - Al entrar a una zona se recorre una serie de salas; cada sala tiene enemigos.
  - Algunas salas especiales requieren una llave o un item especial para entrar.
  - Algunas zonas tienen jefes (bosses).
  - Cantidad de salas, estructura, llaves, items y jefes pendientes de definir; sujeto a cambios.

- [ ] **Cantidad de enemigos definida por sala.**
  - Cada sala define cuántos enemigos tiene.
  - Falta definir si la cantidad es fija o varía en cada visita, y si la composición es fija o aleatoria.

- [ ] **Minimapa durante el combate.**
  - La pantalla de combate muestra un minimapa de la ubicación actual (zona y sala).
  - Estilo, tamaño y datos a mostrar pendientes de definir.

- [ ] **Selección de camino al limpiar la sala.**
  - Al eliminar todos los enemigos se muestra una versión ampliada del minimapa con los caminos posibles.
  - El jugador puede interactuar con esa vista para elegir el siguiente camino.
  - Representación de los caminos, transición entre salas y reglas de desbloqueo pendientes de definir.

## Sistema de enemigos

- [ ] **Sistema de enemigos por zona.**
  - Definir cómo se gestionan, crean y personalizan las escenas de enemigos.
  - Personalización por configuración: raza, clase, rareza y level.
  - El level se asigna a los mobs según la zona.
  - Alternativas de arquitectura a definir:
    - A) Una sola `Enemy.tscn` + recurso de datos (`EnemyData`) con stats, skills, sprite y nombre.
    - B) Una escena por tipo de enemigo.
    - C) Híbrida: escena base con datos y escenas variante solo cuando cambie el arte o las animaciones.
  - Hoy `Enemy.tscn` es única, con sprite y nombre fijos, y `combat.gd` instancia siempre 2 enemigos sin configuración.

- [ ] **Herramienta para crear enemigos rápidamente.**
  - Herramienta de editor que permita crear y configurar enemigos (raza, clase, rareza, level, stats, skills, drops) y dejarlos listos para integrarlos al juego.
  - Alcance pendiente: plugin de editor, recurso + inspector o herramienta asistida por IA.

## Drops y materiales

- [ ] **Sistema de drops por zona y level.**
  - Los enemigos dropean según la zona y su level asignado.
  - Falta definir probabilidades, tablas de drop y si el level modifica cantidad o calidad.

- [ ] **Materiales exclusivos por zona.**
  - Cada zona dropea materiales distintos para incentivar que el jugador visite diferentes sitios.
  - Falta definir qué materiales existen, para qué se usan y cómo se obtienen.

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
