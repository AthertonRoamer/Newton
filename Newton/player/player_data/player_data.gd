class_name PlayerDataClass
extends Node

#class for containing player data that should be preserved through death or across level segment changes

#persistent data - data preserved across death and respawn
var equipped_spells : Array[PackedScene] = []

#temporary data - data preserved across level segment changes
var health : int = 100

