extends UpgradeData
class_name Upgrade_SpectralDagger

@export var skill_node_path: NodePath

func apply_upgrade(stats: Stats, player: Player, new_level: int) -> void:
	var skill: SpectralDaggersSkill = player.get_node(skill_node_path)
	if not skill:
		push_error("OrbitalOrbSkill node not found on player")
		return
	
	skill.set_level(new_level)
