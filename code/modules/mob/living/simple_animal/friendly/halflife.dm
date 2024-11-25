/mob/living/simple_animal/hostile/hl2bot
	var/radio_key = null //which channels can the bot listen to
	var/radio_channel = RADIO_CHANNEL_COMMON //The bot's default radio channel
	var/obj/item/radio/Radio //The bot's radio, for speaking to people.
	var/obj/machinery/camera/builtInCamera = null
	var/nocamera = FALSE //Should the bot have a built in camera or not?
	var/data_hud_type
	hud_possible = list(DIAG_STAT_HUD, DIAG_BOT_HUD, DIAG_HUD, DIAG_PATH_HUD = HUD_LIST_LIST) //Diagnostic HUD views

/mob/living/simple_animal/hostile/hl2bot/Initialize(mapload)
	. = ..()
	access_card = new /obj/item/card/id(src)
	access_card.access += ACCESS_SEC_BASIC
	Radio = new/obj/item/radio(src)
	if(radio_key)
		Radio.keyslot = new radio_key
	Radio.subspace_transmission = TRUE
	Radio.canhear_range = 0 // anything greater will have the bot broadcast the channel as if it were saying it out loud.
	Radio.recalculateChannels()
	if(!nocamera && !builtInCamera)
		builtInCamera = new (src)
		builtInCamera.c_tag = real_name
		builtInCamera.network = list("ss13")
		builtInCamera.internal_light = FALSE
		builtInCamera.built_in = src

	//If a bot has its own HUD (for player bots), provide it.
	if(data_hud_type)
		var/datum/atom_hud/datahud = GLOB.huds[data_hud_type]
		datahud.show_to(src)

/mob/living/simple_animal/hostile/hl2bot/Destroy()
	qdel(Radio)
	qdel(access_card)
	return ..()

/mob/living/simple_animal/hostile/hl2bot/radio(message, list/message_mods = list(), list/spans, language)
	. = ..()
	if(. != 0)
		return

	if(message_mods[MODE_HEADSET])
		Radio.talk_into(src, message, , spans, language, message_mods)
		return REDUCE_RANGE
	else if(message_mods[RADIO_EXTENSION] == MODE_DEPARTMENT)
		Radio.talk_into(src, message, message_mods[RADIO_EXTENSION], spans, language, message_mods)
		return REDUCE_RANGE
	else if(message_mods[RADIO_EXTENSION] in GLOB.radiochannels)
		Radio.talk_into(src, message, message_mods[RADIO_EXTENSION], spans, language, message_mods)
		return REDUCE_RANGE

/mob/living/simple_animal/hostile/hl2bot/cityscanner
	name = "City Scanner"
	desc = "A flying machine built to scan the city for malcompliants."
	icon = 'icons/mob/halflife.dmi'
	icon_state = "cityscanner"
	icon_living = "cityscanner"
	friendly = "scans"
	loot = list(/obj/item/circuitmaterial)
	del_on_death = 1
	health = 60
	maxHealth = 60
	unsuitable_atmos_damage = 0
	wander = 0
	speed = -0.33
	healable = 0
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	speak_emote = list("beeps")
	speech_span = SPAN_ROBOT
	bubble_icon = BUBBLE_MACHINE
	movement_type = FLYING
	radio_key = /obj/item/encryptionkey/secbot //AI Priv + Security
	radio_channel = RADIO_CHANNEL_SECURITY //Security channel
	has_unlimited_silicon_privilege = 1
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	data_hud_type = DATA_HUD_SECURITY_ADVANCED
	faction = list("neutral","silicon","combine")
	deathsound = 'sound/creatures/cityscanner/cbot_energyexplosion1.ogg'
	ranged = 1 //for flashing
	ranged_cooldown_time = 50
	light_power = 0.75
	light_range = 3
	var/idle_sound_chance = 50
	var/idle_sounds = list('sound/creatures/cityscanner/scanner_scan_loop1.ogg')
	var/scan_sounds = list('sound/creatures/cityscanner/scanner_scan1.ogg', 'sound/creatures/cityscanner/scanner_scan2.ogg')
	var/talk_sounds = list('sound/creatures/cityscanner/scanner_talk1.ogg', 'sound/creatures/cityscanner/scanner_talk2.ogg')

/mob/living/simple_animal/hostile/hl2bot/cityscanner/binarycheck()
	return TRUE

/mob/living/simple_animal/hostile/hl2bot/cityscanner/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	..()
	if(stat)
		return
	if(prob(idle_sound_chance))
		var/chosen_sound = pick(idle_sounds)
		playsound(src, chosen_sound, 20, FALSE)
		if(prob(15))
			chosen_sound = pick(scan_sounds)
			playsound(src, chosen_sound, 50, FALSE)

/mob/living/simple_animal/hostile/hl2bot/cityscanner/OpenFire()
	playsound(src, 'sound/creatures/cityscanner/scanner_photo1.ogg', 40, FALSE)
	ranged_cooldown = world.time + ranged_cooldown_time

/mob/living/simple_animal/hostile/hl2bot/cityscanner/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	..()
	if(stat)
		return
	var/chosen_sound = pick(talk_sounds)
	playsound(src, chosen_sound, 50, FALSE)

//antlion grub
/mob/living/simple_animal/halflife/grub
	name = "Antlion Grub"
	desc = "A large maggot filled with a green, glowing mass."
	icon = 'icons/mob/halflife.dmi'
	icon_state = "grub"
	icon_living = "grub"
	icon_dead = "grub_dead"
	faction = list("antlion")
	mob_biotypes = MOB_ORGANIC
	maxHealth = 12
	health = 12
	wander = 0
	light_range = 2
	light_power = 1
	light_color = "#67ac65"
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	speed = -1
	loot = list(/obj/item/reagent_containers/pill/patch/grubnugget = 1, /obj/effect/decal/cleanable/insectguts = 1)
	can_be_held = TRUE
	held_state = "grub"
	deathsound = 'sound/creatures/halflife/grub/agrub_squish.ogg'
	density = FALSE
	//var/squish_chance = 50
	var/idle_sounds = list('sound/creatures/halflife/grub/idle1.ogg','sound/creatures/halflife/grub/idle2.ogg', ,'sound/creatures/halflife/grub/idle3.ogg', ,'sound/creatures/halflife/grub/idle4.ogg')

/mob/living/simple_animal/halflife/grub/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	..()
	if(stat)
		return
	if(prob(25))
		var/chosen_sound = pick(idle_sounds)
		playsound(src, chosen_sound, 50, FALSE)

//commented out until i figure a way to make antlions not squash their own babies
/*
/mob/living/simple_animal/halflife/grub/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/squashable, \
		squash_chance = squish_chance, \
		squash_damage = 6, \
		squash_flags = SQUASHED_ALWAYS_IF_DEAD|SQUASHED_DONT_SQUASH_IN_CONTENTS, \
	)
*/
