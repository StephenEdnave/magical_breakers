extends Node

enum HEALTH_STATUS { NONE, INVINCIBLE, POISON, FIRE, DEAD }
enum HEALTH_EFFECT { NONE, POISON, FIRE }
enum HEALTH_DAMAGE_TYPE { NONE, POISON, FIRE }

var sfx_volume = 1.0
var music_volume = 1.0