/obj/item/extinguisher
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	icon = 'icons/obj/tools.dmi'
	icon_state = "fire_extinguisher0"
	item_state = "fire_extinguisher"
	hitsound = 'sound/weapons/smash.ogg'
	flags_1 = CONDUCT_1
	throwforce = 10
	w_class = WEIGHT_CLASS_BULKY
	throw_speed = 2
	throw_range = 7
	force = 12
	materials = list(/datum/material/iron = 90)
	attack_verb = list("slammed", "whacked", "bashed", "thunked", "battered", "bludgeoned", "thrashed")
	dog_fashion = /datum/dog_fashion/back
	resistance_flags = FIRE_PROOF
	var/max_water = 200
	var/last_use = 1
	var/chem = /datum/reagent/water
	var/chem_amount = 2 //how much of the chem is added to each spray (x5 because of how many sprays per shot)
	var/safety = TRUE
	var/refilling = FALSE
	var/tanktype = /obj/structure/reagent_dispensers/watertank
	var/sprite_name = "fire_extinguisher"
	var/power = 5 //Maximum distance launched water will travel
	var/precision = FALSE //By default, turfs picked from a spray are random, set to 1 to make it always have at least one water effect per row

/obj/item/extinguisher/mini
	name = "pocket fire extinguisher"
	desc = "A light and compact fibreglass-framed model fire extinguisher."
	icon_state = "miniFE0"
	item_state = "miniFE"
	hitsound = null	//it is much lighter, after all.
	flags_1 = null //doesn't CONDUCT_1
	throwforce = 2
	w_class = WEIGHT_CLASS_SMALL
	force = 3
	materials = list(/datum/material/iron = 50, /datum/material/glass = 40)
	max_water = 30
	chem_amount = 1
	sprite_name = "miniFE"
	dog_fashion = null

/obj/item/extinguisher/proc/refill()
	create_reagents(max_water, AMOUNT_VISIBLE)
	reagents.add_reagent(chem, max_water)

/obj/item/extinguisher/Initialize(mapload)
	. = ..()
	refill()

/obj/item/extinguisher/advanced
	name = "advanced fire extinguisher"
	desc = "Used to stop thermonuclear fires from spreading inside your engine."
	icon_state = "foam_extinguisher0"
	item_state = "foam_extinguisher"
	max_water = 150
	chem_amount = 1
	w_class = WEIGHT_CLASS_NORMAL
	dog_fashion = null
	chem = /datum/reagent/firefighting_foam
	tanktype = /obj/structure/reagent_dispensers/foamtank
	sprite_name = "foam_extinguisher"
	precision = TRUE

/obj/item/extinguisher/suicide_act(mob/living/carbon/user)
	if (!safety && (reagents.total_volume >= 1))
		user.visible_message(span_suicide("[user] puts the nozzle to [user.p_their()] mouth. It looks like [user.p_theyre()] trying to extinguish the spark of life!"))
		afterattack(user,user)
		return OXYLOSS
	else if (safety && (reagents.total_volume >= 1))
		user.visible_message(span_warning("[user] puts the nozzle to [user.p_their()] mouth... The safety's still on!"))
		return SHAME
	else
		user.visible_message(span_warning("[user] puts the nozzle to [user.p_their()] mouth... [src] is empty!"))
		return SHAME

/obj/item/extinguisher/attack_self(mob/user)
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	to_chat(user, "The safety is [safety ? "on" : "off"].")
	return

/obj/item/extinguisher/attack(mob/M, mob/living/user, params)
	if(!user.combat_mode && !safety) //If we're on help intent and going to spray people, don't bash them.
		return FALSE
	else
		return ..()

/obj/item/extinguisher/attack_atom(obj/O, mob/living/user)
	if(AttemptRefill(O, user))
		refilling = TRUE
		return FALSE
	else
		return ..()

/obj/item/extinguisher/examine(mob/user)
	. = ..()
	. += "The safety is [safety ? "on" : "off"]."

	if(reagents.total_volume)
		. += span_notice("Alt-click to empty it.")

/obj/item/extinguisher/proc/AttemptRefill(atom/target, mob/user)
	if(istype(target, tanktype) && target.Adjacent(user))
		var/safety_save = safety
		safety = TRUE
		if(reagents.total_volume == reagents.maximum_volume)
			to_chat(user, span_warning("\The [src] is already full!"))
			safety = safety_save
			return 1
		var/obj/structure/reagent_dispensers/W = target //will it work?
		var/transferred = W.reagents.trans_to(src, max_water, transfered_by = user)
		if(transferred > 0)
			to_chat(user, span_notice("\The [src] has been refilled by [transferred] units."))
			playsound(src.loc, 'sound/effects/refill.ogg', 50, 1, -6)
		else
			to_chat(user, span_warning("\The [W] is empty!"))
		safety = safety_save
		return TRUE
	else
		return FALSE

/obj/item/extinguisher/afterattack(atom/target, mob/user , flag)
	. = ..()
	// Make it so the extinguisher doesn't spray yourself when you click your inventory items
	if (target.loc == user)
		return
	//TODO; Add support for reagents in water.

	if(refilling)
		refilling = FALSE
		return
	if (!safety)


		if (src.reagents.total_volume < 1)
			to_chat(usr, span_warning("\The [src] is empty!"))
			return

		if (world.time < src.last_use + 12)
			return

		src.last_use = world.time

		playsound(src.loc, 'sound/effects/extinguish.ogg', 75, 1, -3)

		var/direction = get_dir(src,target)

		if(user.buckled && isobj(user.buckled) && !user.buckled.anchored)
			var/obj/B = user.buckled
			var/movementdirection = turn(direction,180)
			addtimer(CALLBACK(src, /obj/item/extinguisher/proc/move_chair, B, movementdirection), 1)

		else user.newtonian_move(turn(direction, 180))

		//Get all the turfs that can be shot at
		var/turf/T = get_turf(target)
		var/turf/T1 = get_step(T,turn(direction, 90))
		var/turf/T2 = get_step(T,turn(direction, -90))
		var/list/the_targets = list(T,T1,T2)
		if(precision)
			var/turf/T3 = get_step(T1, turn(direction, 90))
			var/turf/T4 = get_step(T2,turn(direction, -90))
			the_targets.Add(T3,T4)

		for(var/a=0, a<5, a++)
			var/my_target = pick(the_targets)
			var/obj/effect/particle_effect/water/W = new /obj/effect/particle_effect/water(get_turf(src), my_target)
			reagents.trans_to(W, chem_amount, transfered_by = user)
			if(precision)
				the_targets -= my_target

//Chair movement loop
/obj/item/extinguisher/proc/move_chair(obj/B, movementdirection, repetition=0)
	step(B, movementdirection)

	var/timer_seconds
	switch(repetition)
		if(0 to 2)
			timer_seconds = 1
		if(3 to 4)
			timer_seconds = 2
		if(5 to 8)
			timer_seconds = 3
		else
			return

	repetition++
	addtimer(CALLBACK(src, /obj/item/extinguisher/proc/move_chair, B, movementdirection, repetition), timer_seconds)

/obj/item/extinguisher/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	EmptyExtinguisher(user)

/obj/item/extinguisher/proc/EmptyExtinguisher(mob/user)
	if(loc == user && reagents.total_volume)
		reagents.clear_reagents()

		var/turf/T = get_turf(loc)
		if(isopenturf(T))
			var/turf/open/theturf = T
			theturf.MakeSlippery(TURF_WET_WATER, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)

		user.visible_message("[user] empties out \the [src] onto the floor using the release valve.", span_info("You quietly empty out \the [src] using its release valve."))

//firebot assembly
/obj/item/extinguisher/attackby(obj/O, mob/user, params)
	if(istype(O, /obj/item/bodypart/l_arm/robot) || istype(O, /obj/item/bodypart/r_arm/robot))
		to_chat(user, span_notice("You add [O] to [src]."))
		qdel(O)
		qdel(src)
		user.put_in_hands(new /obj/item/bot_assembly/firebot)
	else
		..()
