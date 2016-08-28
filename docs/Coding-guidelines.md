# Coding guidelines
## Code style
* Tabs
* Clear whitespace. Tabs expected in empty lines (for aligment).
* Do not use `self` unless necessary.
* First line is the `extends` line if apply.
  * Follow with a *doc block* (many lines starting in `#`) if apply.
  * The next blocks are: constants, global variables and functions.
* Constants UPPERCASE_WITH_UNDERSCORES.
* Vars and functions lowercase_with_underscores.
  * Private vars and functions start with underscore.
    * Provide getters and setters to access this values.
* Single line separation:
  * Grouping vars.
  * Separating sections of functionality.
* Double line separation:
  * After and before the top file *doc block*.
  * After and before the top constants and variables.
  * Between each function.
* Document complex functions with *doc blocks* at the beginning.

## Files
| Path                  | Usage                                   |
| --------------------- | --------------------------------------- |
|  images/sprites       |                                         |
|  images/animations    | One per subfolder. frameXXX.png         |
|  images/interface     |                                         |
|  sounds               |                                         |
|  music                |                                         |
|  scenes/.             | Global (state) scenes.                  |
|  scenes/entities      | Object represented in-game.             |
|  scenes/iface         | Interface components.                   |
|  scenes/modules       | Pluggable scenes to give functionality. |
## Architecture
### States
In the root scene directory we can find the game state scenes:

* **space**: This is the main game scene. It features an stars background and
             the normal elements for the space: ships, planets, stars... Also,
             it features the interface components needed for the game control.

### Game components
Game components are a combination of one base entity (called the "head") and
a set of modules. This modules implement most of the functionality in the
game.

An example for a IA controlled ship:
* Ship
  * SpaceBody
  * Mass
  * Hull
  * MainEngine
  * TrustersEngine
  * RotationEngine
  * PhaserCannonWeapon
  * PhotonMissileWeapon
  * IAEasyAggressive

Most of the module interactions with the outside imply a search in the head
tree using module names and patterns. Names matter.
### Module guidelines
Modules will feature a `_head` module attribute (a.k.a. module scope var). The
`_ready` function should init this value with:
```python
_head = get_parent()
```

