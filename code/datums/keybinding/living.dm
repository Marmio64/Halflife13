/datum/keybinding/living
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/living/can_use(client/user)
	return isliving(user.mob)


/datum/keybinding/carbon/rest
	hotkey_keys = list("U")
	name = "rest"
	full_name = "Rest"
	description = "Lay down, or get up."

/datum/keybinding/carbon/rest/down(client/user)
	var/mob/living/carbon/C = user.mob
	C.lay_down()
	return TRUE


/datum/keybinding/living/resist
	hotkey_keys = list("B")
	name = "resist"
	full_name = "Resist"
	description = "Break free of your current state. Handcuffed? on fire? Resist!"

/datum/keybinding/living/resist/down(client/user)
	var/mob/living/L = user.mob
	L.resist()
	return TRUE

// Moved here because of dextrous mobs and carbons and etc.
/datum/keybinding/living/quick_equip
	hotkey_keys = list("E")
	name = "quick_equip"
	full_name = "Quick Equip"
	description = "Quickly puts an item in the best slot available."

/datum/keybinding/living/quick_equip/down(client/user)
	var/mob/living/living_mob = user.mob
	living_mob.quick_equip()
	return TRUE

// Combat mode
/datum/keybinding/living/toggle_combat_mode
	hotkey_keys = list("F")
	name = "toggle_combat_mode"
	full_name = "Toggle Combat Mode"
	description = "Toggles combat mode. Like Help/Harm but cooler."

/datum/keybinding/living/toggle_combat_mode/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/user_mob = user.mob
	user_mob.set_combat_mode(!user_mob.combat_mode, FALSE, FALSE)

/datum/keybinding/living/enable_combat_mode
	hotkey_keys = list("4")
	name = "enable_combat_mode"
	full_name = "Enable Combat Mode"
	description = "Enable combat mode."

/datum/keybinding/living/enable_combat_mode/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/user_mob = user.mob
	user_mob.set_combat_mode(TRUE, FALSE, FALSE)

/datum/keybinding/living/disable_combat_mode
	hotkey_keys = list("1")
	name = "disable_combat_mode"
	full_name = "Disable Combat Mode"
	description = "Disable combat mode."

/datum/keybinding/living/disable_combat_mode/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/user_mob = user.mob
	user_mob.set_combat_mode(FALSE, FALSE, FALSE)

/datum/keybinding/living/fixeye
	hotkey_keys = list("ShiftF")
	name = "fixeye"
	full_name = "Fix Eye"
	description = "Fix the direction you're staring at."
	keybind_signal = COMSIG_KB_FIXEYE_DOWN

/datum/keybinding/living/fixeye/down(client/user)
	. = ..()
	var/mob/living/living_user = user.mob
	if(istype(living_user))
		SEND_SIGNAL(living_user, COMSIG_FIXEYE_TOGGLE)
	return TRUE
	