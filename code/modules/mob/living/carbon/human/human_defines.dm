/mob/living/carbon/human
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ID_HUD,WANTED_HUD,IMPLOYAL_HUD,IMPCHEM_HUD,IMPTRACK_HUD, NANITE_HUD, DIAG_NANITE_FULL_HUD,ANTAG_HUD,GLAND_HUD,SENTIENT_DISEASE_HUD)
	hud_type = /datum/hud/human
	pressure_resistance = 25
	can_buckle = TRUE
	buckle_lying = FALSE
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	//Hair colour and style
	var/hair_color = "#000000"
	var/hair_style = "Bald"

	///Colour used for the hair gradient.
	var/grad_color = "#000000"
	///Style used for the hair gradient.
	var/grad_style

	//Facial hair colour and style
	var/facial_hair_color = "#000000"
	var/facial_hair_style = "Shaved"

	//Eye colour
	var/eye_color = "#000000"

	var/skin_tone = "caucasian1"	//Skin tone

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup
	var/lip_color = "white"

	var/age = 30

	var/underwear = "Nude"	//Which underwear the player wants
	var/undershirt = "Nude" //Which undershirt the player wants
	var/socks = "Nude" //Which socks the player wants
	var/backbag = DBACKPACK		//Which backpack type the player has chosen.
	var/jumpsuit_style = PREF_SUIT //suit/skirt

	//Equipment slots
	var/obj/item/clothing/wear_suit = null
	var/obj/item/clothing/w_uniform = null
	var/obj/item/belt = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/bleedsuppress = 0 //for stopping bloodloss, eventually this will be limb-based like bleeding

	var/name_override //For temporary visible name changes

	var/datum/physiology/physiology

	var/list/datum/bioware = list()

	var/creamed = FALSE //to use with creampie overlays
	var/static/list/can_ride_typecache = typecacheof(list(/mob/living/carbon/human, /mob/living/simple_animal/slime, /mob/living/simple_animal/parrot))
	var/lastpuke = 0
	var/last_fire_update
	///The Unique ID number code associated with the owner's bank account, assigned at round start.
	var/account_id
	/// A randomly generated 5-digit pin to access the bank account. This is stored as a string!
	var/account_pin
	var/xylophone = 0 //For the spoooooooky xylophone cooldown
	var/blood_in_hands = 0
	///The Examine Panel TGUI.
	var/datum/examine_panel/tgui = new() //create the datum
