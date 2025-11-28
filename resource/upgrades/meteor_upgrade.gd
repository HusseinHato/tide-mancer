extends UpgradeData
class_name Upgrade_MeteorRain

@export var skill_node_path: NodePath

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	var skill: MeteorRainSkill = player.get_node(skill_node_path)
	if not skill:
		push_error("MeteorRainSkill node not found on player")
		return
	
	skill.set_level(new_level)
