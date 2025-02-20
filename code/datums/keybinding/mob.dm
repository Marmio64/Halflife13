/datum/keybinding/mob
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB


/datum/keybinding/mob/stop_pulling
	hotkey_keys = list("H", "Delete")
	classic_keys = list("Delete")
	name = "stop_pulling"
	full_name = "Stop pulling"
	description = ""

/datum/keybinding/mob/stop_pulling/down(client/user)
	var/mob/M = user.mob
	if (!M.pulling)
		to_chat(user, "<span class='notice'>You are not pulling anything.</span>")
	else
		M.stop_pulling()
	return TRUE


/datum/keybinding/mob/swap_hands
	hotkey_keys = list("X")
	classic_keys = list("Northeast") // PAGEUP
	name = "swap_hands"
	full_name = "Swap hands"
	description = ""

/datum/keybinding/mob/swap_hands/down(client/user)
	var/mob/M = user.mob
	M.swap_hand()
	return TRUE


/datum/keybinding/mob/activate_inhand
	hotkey_keys = list("Z")
	classic_keys = list("Southeast") // PAGEDOWN
	name = "activate_inhand"
	full_name = "Activate in-hand"
	description = "Uses whatever item you have in your active hand"

/datum/keybinding/mob/activate_inhand/down(client/user)
	var/mob/M = user.mob
	M.mode()
	return TRUE


/datum/keybinding/mob/drop_item
	hotkey_keys = list("Q")
	name = "drop_item"
	full_name = "Drop Item"
	description = ""

/datum/keybinding/mob/drop_item/down(client/user)
	if(HAS_TRAIT(user, TRAIT_NOINTERACT)) // INTERCEPTED
		to_chat(user, span_danger("You can't interact with anything right now!"))
		return FALSE
	if(iscyborg(user.mob)) //cyborgs can't drop items
		return FALSE

	var/mob/M = user.mob
	var/obj/item/I = M.get_active_held_item()
	if(!I)
		to_chat(user, "<span class='warning'>You have nothing to drop in your hand!</span>")
	else
		user.mob.dropItemToGround(I)

	return TRUE


/datum/keybinding/mob/toggle_move_intent
	hotkey_keys = list("Shift")
	name = "toggle_move_intent"
	full_name = "Hold to toggle move intent"
	description = "Held down to cycle to the other move intent, release to cycle back"

/datum/keybinding/mob/toggle_move_intent/down(client/user)
	var/mob/M = user.mob // Broken?
	M.toggle_move_intent()
	return TRUE

/datum/keybinding/mob/toggle_move_intent/up(client/user)
	var/mob/M = user.mob
	M.toggle_move_intent()
	return TRUE


/datum/keybinding/mob/toggle_move_intent_alternative
	hotkey_keys = list("Unbound")
	name = "toggle_move_intent_alt"
	full_name = "Press to cycle move intent"
	description = "Pressing this cycle to the opposite move intent, does not cycle back"

/datum/keybinding/mob/toggle_move_intent_alternative/down(client/user)
	var/mob/M = user.mob
	M.toggle_move_intent()
	return TRUE


/datum/keybinding/mob/target_head_cycle
	hotkey_keys = list("Numpad8")
	name = "target_head_cycle"
	full_name = "Target: Cycle Head"
	description = "Pressing this key targets the head, and continued presses will cycle to the eyes and mouth. This will impact where you hit people, and can be used for surgery."

/datum/keybinding/mob/target_head_cycle/down(client/user)
	user.body_toggle_head()
	return TRUE


/datum/keybinding/mob/target_eyes
	hotkey_keys = list("Numpad7")
	name = "target_eyes"
	full_name = "Target: Eyes"
	description = "Pressing this key targets the eyes. This will impact where you hit people, and can be used for surgery."

/datum/keybinding/mob/target_eyes/down(client/user)
	user.body_eyes()
	return TRUE


/datum/keybinding/mob/target_mouth
	hotkey_keys = list("Numpad9")
	name = "target_mouths"
	full_name = "Target: Mouth"
	description = "Pressing this key targets the mouth. This will impact where you hit people, and can be used for surgery."

/datum/keybinding/mob/target_mouth/down(client/user)
	user.body_mouth()
	return TRUE


/datum/keybinding/mob/target_r_arm
	hotkey_keys = list("Numpad4")
	name = "target_r_arm"
	full_name = "Target: Right arm"
	description = "Pressing this key targets the right arm. This will impact where you hit people, and can be used for surgery."

/datum/keybinding/mob/target_r_arm/down(client/user)
	user.body_r_arm()
	return TRUE


/datum/keybinding/mob/target_body_chest
	hotkey_keys = list("Numpad5")
	name = "target_body_chest"
	full_name = "Target: Body"
	description = "Pressing this key targets the body. This will impact where you hit people, and can be used for surgery."

/datum/keybinding/mob/target_body_chest/down(client/user)
	user.body_chest()
	return TRUE


/datum/keybinding/mob/target_left_arm
	hotkey_keys = list("Numpad6")
	name = "target_left_arm"
	full_name = "Target: Left arm"
	description = "Pressing this key targets the body. This will impact where you hit people, and can be used for surgery."

/datum/keybinding/mob/target_left_arm/down(client/user)
	user.body_l_arm()
	return TRUE


/datum/keybinding/mob/target_right_leg
	hotkey_keys = list("Numpad1")
	name = "target_right_leg"
	full_name = "Target: Right leg"
	description = "Pressing this key targets the right leg. This will impact where you hit people, and can be used for surgery."

/datum/keybinding/mob/target_right_leg/down(client/user)
	user.body_r_leg()
	return TRUE


/datum/keybinding/mob/target_body_groin
	hotkey_keys = list("Numpad2")
	name = "target_body_groin"
	full_name = "Target: Groin"
	description = "Pressing this key targets the groin. This will impact where you hit people, and can be used for surgery."

/datum/keybinding/mob/target_body_groin/down(client/user)
	user.body_groin()
	return TRUE


/datum/keybinding/mob/target_left_leg
	hotkey_keys = list("Numpad3")
	name = "target_left_leg"
	full_name = "Target: Left leg"
	description = "Pressing this key targets the left leg. This will impact where you hit people, and can be used for surgery."

/datum/keybinding/mob/target_left_leg/down(client/user)
	user.body_l_leg()
	return TRUE


/datum/keybinding/mob/prevent_movement
	hotkey_keys = list("Alt")
	name = "block_movement"
	full_name = "Block movement"
	description = "Prevents you from moving"

/datum/keybinding/mob/prevent_movement/down(client/user)
	user.movement_locked = TRUE

/datum/keybinding/mob/prevent_movement/up(client/user)
	user.movement_locked = FALSE
	user.pixel_shifting = FALSE // needed to prevent conflicting keybind from fucking us up


/datum/keybinding/mob/pixel_shift
	hotkey_keys = list("AltShift")
	name = "pixel_shift"
	full_name = "Pixel shift"
	description = "Allows you to shift your characters by a few pixels"

/datum/keybinding/mob/pixel_shift/down(client/user)
	user.pixel_shifting = TRUE

/datum/keybinding/mob/pixel_shift/up(client/user)
	user.movement_locked = FALSE  // needed to prevent conflicting keybind from fucking us up
	user.pixel_shifting = FALSE
