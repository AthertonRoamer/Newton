class_name PlayerDataClass
extends Node

#class for containing player data that should be preserved through death or across level segment changes

#persistent data - data preserved across death/respawn and level segment changes 
var equipped_spells : Array[PackedScene] = []
var selected_spell_num : int = 0
var lives : int = 5
var total_death_respawn_level_index : int = 0

#temporary data - data preserved across level segment changes
var health : int = 100


