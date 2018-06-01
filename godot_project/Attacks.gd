extends Node

# Database for every type of attack

var attacks = {
	# Setup
	"SETUP": {
		animation = "SETUP",
		host_animation = "SETUP" },
	
	
	# Status effects
	"poison": {
		damage = 50, 
		effect = GlobalConstants.HEALTH_EFFECT.NONE, 
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.POISON },
	"burn": {
		damage = 100, 
		effect = GlobalConstants.HEALTH_EFFECT.NONE, 
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.FIRE },
	
	
	# Star Breaker
	# Melee
	"star_b_melee_1": { 
		damage = 100 , 
		animation = "attack_fast",
		effect = GlobalConstants.HEALTH_EFFECT.FIRE,
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.FIRE ,
		knockback_force = 10 ,
		knockback_duration = 0.4,
		hit_pause = 0.001,
		host_animation = "melee_1",
		move_force = 800 },
	"star_b_melee_2": { 
		damage = 100 , 
		animation = "attack_fast",
		effect = GlobalConstants.HEALTH_EFFECT.FIRE,
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.FIRE ,
		knockback_force = 10 ,
		knockback_duration = 0.4,
		hit_pause = 0.001, 
		host_animation = "melee_1",
		move_force =  800 },
	"star_b_melee_3": { 
		damage = 75 , 
		animation = "attack_straight",
		effect = GlobalConstants.HEALTH_EFFECT.FIRE,
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.FIRE ,
		knockback_force = 10 ,
		knockback_duration = 0.4, 
		hit_pause = 0.004,
		host_animation = "melee_2",
		move_force = -1200 },
	"star_b_melee_4": {
		damage = 200,
		animation = "attack_medium",
		effect = GlobalConstants.HEALTH_EFFECT.FIRE,
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.FIRE,
		knockback_force = 50,
		knockback_duration = 0.6, 
		hit_pause = 0.03,
		host_animation = "melee_3",
		move_force = 1600 },
	#Projectiles
	"star_b_sticky_bomb": { 
		damage = 100 , 
		effect = GlobalConstants.HEALTH_EFFECT.NONE,
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.NONE ,
		knockback_force = 30 ,
		knockback_duration = 0.5,
		hit_pause = 0.01 },
	"star_b_drone_laser": {
		damage = 10 , # DPS tick every 0.1 seconds
		effect = GlobalConstants.HEALTH_EFFECT.NONE,
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.NONE ,
		knockback_force = 0 ,
		knockback_duration = 0.2 },
	# Projectiles - visuals
	"star_b_laser_spawn": {
		animation = "attack",
		host_animation = "primary_attack" },
	"star_b_sticky_bomb_launch": {
		animation = "attack",
		host_animation = "secondary_attack" },
	
	
	# Dwarf
	"dwarf_charge": {
		damage = 50, # DPS tick every 0.06 seconds
		effect = GlobalConstants.HEALTH_EFFECT.NONE, 
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.NONE, 
		knockback_force = 20.0 ,
		knockback_duration = 0.2,
		hit_pause = 0.002, },
	"dwarf_projectile_energy": { 
		damage = 20 , 
		effect = GlobalConstants.HEALTH_EFFECT.NONE,
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.NONE ,
		knockback_force = 30 ,
		knockback_duration = 0.5,
		hit_pause = 0.01 },
	"dwarf_projectile_explosion": { 
		damage = 30 , 
		effect = GlobalConstants.HEALTH_EFFECT.NONE,
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.NONE ,
		knockback_force = 50 ,
		knockback_duration = 0.5,
		hit_pause = 0.01 },
	"dwarf_gun": {
		animation = "attack",
		host_animation = "shoot"
		},
	
	
	# Sprite
	"sprite_gun": {
		animation = "attack",
		host_animation = "walk" },
	"sprite_projectile": { 
		damage = 50 , 
		effect = GlobalConstants.HEALTH_EFFECT.NONE,
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.NONE ,
		knockback_force = 50 ,
		knockback_duration = 0.5,
		hit_pause = 0.02 },
	
	
	# Basic Plushy
	"basic_plushy_gun": {
		animation = "attack",
		host_animation = "walk" },
	"basic_plushy_projectile": {
		damage = 50 , 
		effect = GlobalConstants.HEALTH_EFFECT.NONE,
		damage_type = GlobalConstants.HEALTH_DAMAGE_TYPE.NONE ,
		knockback_force = 50 ,
		knockback_duration = 0.5,
		hit_pause = 0.02 },
}