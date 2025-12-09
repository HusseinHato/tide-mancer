extends Node

signal xp_collected(xp_amout: int)
signal leveled_up(current_level: int)
signal hot_dog_picked(heal_amount: float)
signal magnet_collected()

signal meta_skill_added(skill: MetaSkillData)
signal meta_skill_upgraded(skill_id: StringName, new_level: int, rarity: int)
signal enhancer_added(enhancer: EnhancerData, rarity: int)
signal item_collected(item: ItemData)
signal item_stacked(item_id: StringName, new_level: int)
signal raw_upgrade_applied(stat: String, value: float, rarity: int)
signal shrine_activated(shrine: Node2D)
signal chest_opened(chest: Node2D)
signal character_selected(character: CharacterData)
signal stage_loaded(stage: StageData)
