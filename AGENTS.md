# AGENTS.md — Village

> Borrador inicial. Ajustar cuando el desarrollador confirme o corrija algo.

## 1. Proyecto

Village es un RPG 2D para Godot 4.7 (Forward Plus) centrado en combate por turnos.

- Escena principal: `res://scenes/Game.tscn`.
- Rama de trabajo actual: `refactor/combat-flow`.
- El proyecto está en medio de un refactor del flujo de combate; hay bastante trabajo sin commitear. No asumir que el código refleja un estado terminado.

## 2. Cómo trabajar en este repo

1. Leer `MEMORY.md` antes de empezar.
2. Revisar `git status` y los scripts/escenas involucrados antes de modificar.
3. Usar las herramientas del addon **godot-ai** (el editor está conectado) para inspeccionar el árbol de escena, leer scripts, conectar señales, ejecutar/detener el juego y revisar errores.
4. Verificar ejecutando el juego desde el editor y leyendo la consola. No existen pasos de build separados de Godot: no inventar comandos de compilación.
5. Editar `.tscn` preferentemente con el editor o las herramientas de escena. Editarlos a mano es propenso a romper UIDs y conexiones. No renombrar ni mover archivos sin considerar los `.uid` y las referencias `uid://`.
6. No hacer `commit`, `push` ni publicaciones sin pedido explícito.

## 3. Estructura conocida

### Núcleo de combate (raíz)

- `BattleUnit.gd`: clase base (`Area2D`) de las unidades. HP/energía, señales (`unit_died`, `unit_selected`, `unit_hp_changed`), `get_damage()`, `die()`, `skills` y `stats` exportados.
- `Player.gd`: hereda `BattleUnit`. `use_skill()`, animaciones, selección, sonido de daño.
- `SelectionManager.gd`: autoload con un único `selected_actor`.
- `skill.gd`: `class_name Skill extends Resource`. Datos de la skill + `execute()` básico.
- `stat.gd`: `class_name Stat extends Resource`. hp, energy, attack, defence, accuracy, evasion, etc.
- `text_damage.gd`: autoload que muestra números de daño flotantes.

### Escenas

- `scenes/Game.tscn`: escena de combate. Nodo raíz `Game` (`scenes/combat.gd`), con `BattleManager`, `Units`, `Positions`, `CanvasLayer` (HP), `UI` (skill points) y `SkillBar`.
- `scenes/Player.tscn`, `scenes/Enemy.tscn`: unidades instanciables.
- `scenes/skill_bar.tscn` + `skill_bar.gd`: panel que lista las skills del jugador seleccionado.
- `scenes/skill_slot.tscn` + `skill_slot.gd`: botón/icono de una skill.
- `scenes/skill_preview.tscn` + `skill_preview.gd`: área que sigue al mouse y devuelve los objetivos seleccionados.
- `scenes/character_status.tscn`, `scenes/selection_ring.tscn`.
- `scenes/battle_manager.gd`: lógica de turnos (`PLAYER`/`ENEMY`), registro de unidades, selección de jugador y ejecución de skills. Es el script del nodo `BattleManager` dentro de `Game.tscn`.

### Datos y recursos

- `skills/*.tres`: `basic_attack`, `fire_ball`, `wind_strike`.
- `assets/`: sprites de personajes, UI y sonidos.

### Posibles restos

- `BattleScene.tscn` + `battle_scene.gd` (código comentado), `TestSkelleton.tscn`, `scenes/selector.gd`. Confirmar antes de borrar.

## 4. Convenciones de código

- GDScript, indentación con **tabs**.
- Archivos `.gd` en `snake_case`; scripts con `class_name` en `PascalCase`; escenas `.tscn` en `PascalCase`.
- Variables y funciones en `snake_case`; constantes en `UPPER_SNAKE_CASE`.
- Tipado estático cuando sea posible (`Array[BattleUnit]`, `-> bool`, parámetros tipados en señales).
- Señales en `snake_case` con parámetros tipados.
- Comentarios en castellano; identificadores en inglés.
- Acceso a nodos con `@onready` y `$Ruta` / `%NombreUnico`.
- Estado global a través de autoloads (`GameManager`, `SelectionManager`, `TextDamage`).

## 5. Reglas de trabajo

- **No inventar reglas de juego** (daño, energía, cooldown, turnos, recompensas, progresión). Si una mecánica no está definida, preguntar.
- Cambios pequeños y enfocados. No refactorizar de más ni reescribir código que ya funciona sin motivo.
- No agregar addons ni dependencias sin autorización.
- No borrar archivos, escenas ni datos sin autorización.
- No desactivar comprobaciones ni debilitar tipos para "hacer que compile".
- Mantener el comportamiento existente salvo que el cambio sea pedido.
- Evitar `print()` de debug nuevos; si se agregan, quitarlos al terminar.

## 6. Comunicación

- Explicaciones breves y directas, en castellano.
- Al terminar una tarea, resumir: qué cambió, cómo funciona, qué se verificó y qué queda pendiente.
- No afirmar que algo fue probado si no se ejecutó.

## 7. Documentación

- `AGENTS.md`: este archivo (reglas y contexto para agentes).
- `MEMORY.md`: estado operativo y continuidad entre sesiones. Actualizarlo con cada cambio y mantenerlo en 50 líneas o menos.
- `task.md`: backlog de ideas y tareas pendientes acordadas con el usuario.
- Si el proyecto crece, evaluar `docs/GAME_DESIGN.md` y `docs/TASKS.md`. No crearlos sin acordarlo.

## 8. Backlog de tareas

- Las ideas y mejoras que el usuario quiera dejar para después se anotan en `task.md`.
- Si surge una sugerencia durante el trabajo, proponerla al usuario. Si la acepta, agregarla a `task.md`.
- Cuando el usuario diga **"quiero revisar las tareas pendientes"**, leer `task.md` y presentar las tareas como opciones para que elija cuál implementar.
- No implementar ninguna tarea del backlog sin que el usuario la elija explícitamente.
- Al completar una tarea del backlog, actualizar `task.md` (marcarla como hecha o quitarla) e informar el cambio.
- Para eliminar archivos en desuso, revisarlos uno a uno y preguntar siempre antes de borrar.

---

# Principios de trabajo

## 1. Principio general

Tu función es ayudar a desarrollar este proyecto siguiendo las instrucciones explícitas del usuario.

**No tenés autonomía para decidir qué funcionalidades implementar ni para modificar el diseño del juego.**

- Implementá únicamente lo que el usuario solicite.
- No agregues funcionalidades por iniciativa propia.
- No anticipes tareas futuras.
- Si encontrás oportunidades de mejora, sugerilas antes de implementarlas.
- Si una instrucción es ambigua, preguntá antes de asumir.

## 2. Protección del código existente

El código que ya funciona debe preservarse.

- Antes de modificar un archivo, revisá su implementación actual.
- No reescribas sistemas que ya funcionan para conseguir el mismo resultado de otra manera.
- No reemplaces implementaciones existentes sin una razón técnica concreta y autorización.
- No hagas refactors generales cuando la tarea solo requiere un cambio puntual.
- No elimines código, escenas, nodos, recursos o configuraciones sin autorización.
- Respetá la arquitectura y las convenciones existentes.

**Regla:** modificá lo mínimo necesario para cumplir la tarea.

## 3. Desarrollo paso a paso

Los cambios deben realizarse de manera incremental.

1. Analizá la tarea y el código relacionado.
2. Identificá qué archivos y elementos necesitan modificarse.
3. Explicá brevemente el enfoque antes de realizar cambios importantes.
4. Implementá una parte pequeña y concreta.
5. Verificá que funcione.
6. Continuá con el siguiente paso únicamente cuando corresponda.

No implementes toda una funcionalidad compleja de una sola vez si puede dividirse en etapas.

No avances a funcionalidades adicionales sin una nueva instrucción del usuario.

## 4. Alcance de las tareas

Cada instrucción define el alcance del trabajo.

- No interpretes una solicitud puntual como autorización para modificar sistemas relacionados.
- No agregues mejoras visuales, mecánicas o técnicas que no fueron solicitadas.
- No cambies nombres, estructuras o convenciones por preferencias personales.
- No instales plugins, addons o dependencias sin autorización.
- No modifiques archivos de configuración del proyecto salvo que sea necesario para la tarea.

Si descubrís un problema ajeno a la tarea, informalo sin intentar solucionarlo.

## 5. Reglas específicas de Godot

- Respetá la versión de Godot utilizada por el proyecto.
- Revisá las escenas y sus relaciones antes de modificar nodos.
- Conservá las conexiones de señales existentes.
- No cambies rutas de nodos, nombres de nodos o nombres de escenas sin necesidad.
- No modifiques recursos `.tres`, `.res` o configuraciones del proyecto sin comprender su uso.
- Evitá duplicar lógica entre scripts.
- Utilizá las APIs y patrones compatibles con la versión actual de Godot.
- No agregues nodos, autoloads o sistemas globales si no son necesarios.
- Respetá la separación de responsabilidades que ya tenga el proyecto.

## 6. Calidad y verificación

Después de realizar cambios:

- Revisá que no existan errores de sintaxis.
- Comprobá que las referencias a nodos, recursos y señales sean correctas.
- Ejecutá las verificaciones disponibles cuando sea posible.
- No afirmes que algo funciona si no fue comprobado.
- Informá cualquier limitación o verificación pendiente.

No ocultes errores ni los soluciones mediante cambios que excedan el alcance solicitado.

## 7. Código y aprendizaje

El código debe ser claro y fácil de mantener.

- Preferí soluciones simples antes que abstracciones innecesarias.
- No agregues patrones de diseño sin una necesidad concreta.
- Evitá crear scripts, clases o sistemas adicionales sin justificación.
- No agregues comentarios que repitan lo que el código ya expresa.
- Explicá brevemente las decisiones técnicas relevantes.
- Si hay varias soluciones posibles, presentá las alternativas cuando la decisión afecte la arquitectura.

El objetivo es que el usuario pueda comprender y mantener el código.

## 8. Comunicación

- Sé directo y conciso.
- Explicá qué vas a hacer antes de cambios importantes.
- No abrumes con explicaciones innecesarias.
- Si necesitás tomar una decisión que afecte al diseño o la arquitectura, consultá primero.
- No des por aprobada una sugerencia hasta recibir confirmación.

## 9. Al finalizar una tarea

Informá:

1. Qué se modificó.
2. Qué archivos se modificaron.
3. Cómo funciona el cambio.
4. Qué verificaciones se realizaron.
5. Si quedó algo pendiente.

No continúes automáticamente con otra tarea.

## 10. Regla prioritaria

**Hacé exactamente lo solicitado, preservá lo que ya funciona y avanzá en cambios pequeños.**

Si considerás que una modificación requiere ampliar el alcance original, detenete y consultá al usuario.

## 11. Buenas prácticas de código y mantenibilidad

El código debe priorizar la legibilidad, la simplicidad y la facilidad de mantenimiento.

### 11.1 Nombres e identificación

- Utilizá nombres descriptivos, claros y consistentes.
- Evitá nombres genéricos como `data`, `manager`, `item` o `temp` cuando no expresen claramente su propósito.
- Preferí nombres únicos y específicos cuando exista riesgo de confusión o colisión.
- Respetá las convenciones de nombres de Godot y las utilizadas en el proyecto.
- Evitá nombres excesivamente largos o redundantes.
- Las variables, funciones, señales y clases deben expresar claramente su responsabilidad.

### 11.2 Acceso a nodos

- Preferí `%NombreDelNodo` utilizando Unique Name in Owner cuando sea apropiado.
- Evitá rutas extensas y frágiles como `$Panel/Container/Player/HealthBar` si existe una alternativa más sencilla.
- No reemplaces rutas cortas y claras por Unique Names sin una razón concreta.
- No abuses de `get_node()` ni de rutas construidas dinámicamente.
- Si una escena necesita acceder a muchos nodos internos de otra escena, evaluá si su estructura o comunicación puede mejorarse.

### 11.3 Señales y comunicación

- Utilizá señales para comunicar eventos entre nodos y escenas sin generar dependencias innecesarias.
- Preferí que un nodo emita una señal cuando sucede algo y que otro nodo decida cómo reaccionar.
- Evitá que un nodo conozca y controle directamente demasiados elementos externos.
- No utilices señales para reemplazar llamadas directas cuando existe una relación simple y claramente definida.
- Conectá las señales de manera explícita y mantené sus conexiones fáciles de localizar.
- Evitá conexiones duplicadas o conexiones que nunca se liberan cuando corresponda.
- Utilizá nombres de señales que describan eventos ocurridos, por ejemplo: `health_changed`, `enemy_defeated`, `attack_finished`.
- Definí argumentos tipados y claros para las señales.
- Evitá utilizar señales globales para eventos que solo afectan a dos nodos relacionados.

### 11.4 Estructura de escenas y nodos

- Cada escena debe tener una responsabilidad clara.
- Evitá escenas excesivamente grandes que concentren demasiada lógica.
- Cuando una parte de una escena tenga comportamiento o responsabilidad independiente, evaluá convertirla en una escena reutilizable.
- Preferí composición de nodos antes que concentrar todo el comportamiento en un único script.
- Evitá jerarquías de nodos innecesariamente profundas.
- Mantené nombres y relaciones entre nodos fáciles de comprender.
- Evitá dependencias innecesarias entre escenas.
- Cuando detectes una estructura difícil de mantener, proponé una alternativa y explicá sus ventajas antes de modificarla.

### 11.5 Calidad y legibilidad del código

- Utilizá tipado estático en GDScript siempre que aporte claridad.
- Dividí funciones extensas en funciones pequeñas con responsabilidades concretas.
- Cada función debe realizar una tarea claramente identificable.
- Evitá duplicar lógica: si una misma operación aparece en varios lugares, evaluá extraerla a una función compartida.
- Evitá abstracciones innecesarias y soluciones demasiado genéricas.
- Utilizá constantes para valores que tengan significado o que se repitan.
- Evitá números y cadenas mágicas dispersos por el código.
- Utilizá retornos tempranos cuando ayuden a reducir anidamientos.
- Evitá variables globales y estados compartidos innecesarios.
- Eliminá código muerto únicamente cuando su eliminación esté dentro del alcance autorizado.

### 11.6 Responsabilidad y organización

- Separá la lógica de presentación, comportamiento y datos cuando corresponda.
- Evitá que un mismo script controle sistemas que no tienen relación directa.
- No conviertas todos los scripts en managers o controladores globales.
- Utilizá Autoloads solamente para servicios o estados que realmente necesiten alcance global.
- Evaluá utilizar Resources para representar datos reutilizables o configuraciones, cuando sea conveniente.
- Evitá crear sistemas genéricos antes de tener una necesidad real.

### 11.7 Mantenibilidad y escalabilidad

Antes de dar por terminado un cambio, evaluá:

- ¿El código es fácil de leer sin explicaciones adicionales?
- ¿Las responsabilidades están bien distribuidas?
- ¿Existe acoplamiento innecesario entre nodos o escenas?
- ¿Se está duplicando lógica?
- ¿Es fácil modificar esta funcionalidad en el futuro?
- ¿Agregar un nuevo elemento requeriría modificar demasiados archivos?
- ¿La solución introduce complejidad innecesaria?

Si encontrás una oportunidad de mejora importante, explicala y proponela. No la implementes sin autorización cuando exceda la tarea solicitada.

### 11.8 Comentarios y documentación

- Escribí comentarios para explicar decisiones o comportamientos que no sean evidentes.
- No comentes cada línea ni repitas lo que el código ya expresa.
- Documentá funciones públicas cuando su comportamiento o sus parámetros no sean evidentes.
- Mantené los comentarios actualizados cuando modifiques la implementación.
- Preferí código claro antes que depender de comentarios para explicar código confuso.

### 11.9 Rendimiento

- Evitá optimizaciones prematuras.
- Preferí soluciones simples y eficientes.
- Prestá atención a procesos `_process()` y `_physics_process()` para no ejecutar trabajo innecesario cada frame.
- Evitá búsquedas repetidas de nodos, cálculos o instanciaciones innecesarias dentro de procesos que se ejecutan continuamente.
- Si una optimización agrega complejidad, justificá por qué es necesaria antes de implementarla.

### 11.10 Creación de escenas y nodos

**Priorizar la creación y configuración de escenas mediante el editor de Godot antes que construir estructuras de nodos programáticamente.**

- Siempre que sea posible, creá las escenas, nodos, propiedades visuales y jerarquías desde el editor.
- Utilizá scripts para definir el comportamiento y la lógica de los nodos, no para construir estructuras completas que podrían existir como escenas.
- Preferí instanciar escenas reutilizables (`PackedScene`) antes que crear manualmente sus nodos mediante código.
- Evitá utilizar `Node.new()`, `Control.new()`, `Sprite2D.new()` y similares para construir interfaces o estructuras complejas cuando puedan resolverse mediante escenas.
- No generes interfaces completas mediante código si pueden diseñarse y mantenerse desde el editor.
- Utilizá la creación programática cuando exista una necesidad real, como generación dinámica de elementos, estructuras variables en tiempo de ejecución o sistemas procedurales.
- Si una escena necesita generar muchos elementos dinámicamente, evaluá crear una escena individual reutilizable y luego instanciarla mediante código.
- Mantené separados el diseño visual de una escena y su comportamiento programático.

**Antes de construir una estructura mediante código, evaluá si podría resolverse mejor mediante una escena reutilizable. Si existe una alternativa clara en el editor, preferila.**

### 11.11 Componentes de UI

- Todo componente de UI reutilizable debe incluir textos placeholder en sus nodos de texto.
- El placeholder permite abrir la escena individualmente en el editor y ver cómo se ve sin depender de datos en tiempo de ejecución.
- Usá textos representativos del contenido real (por ejemplo, un nombre y una descripción de ejemplo) en lugar de dejar los campos vacíos.
- El script puede sobrescribir esos textos al inicializar el componente.
