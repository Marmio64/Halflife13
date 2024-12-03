/obj/machinery/door/unpowered/halflife
	icon = 'icons/obj/doors/mojavedoors.dmi'
	name = "base state halflife door"
	pixel_x = -16
	pixel_y = -8
	layer = ABOVE_MOB_LAYER
	density = TRUE
	assemblytype = null
	can_crush = FALSE
	spark_system = null
	max_integrity = 500
	armor = list(MELEE = 40, BULLET = 70, LASER = 90, ENERGY = 40, BOMB = 30, BIO = 100, FIRE = 50, ACID = 100)
	damage_deflection = 15
	sparks = FALSE
	halflife_flags_1 = LOCKABLE_1
	var/door_type = null
	var/solidity = SOLID
	var/frametype = "metal"
	var/opensound = 'sound/machines/door_open.ogg'
	var/closesound = 'sound/machines/door_close.ogg'
	//used for attack checks
	var/open = FALSE
	//used for damage overlays
	var/has_damage_overlay = TRUE
	//used for mirrored overlays
	var/mirrored = FALSE
	var/keylock = FALSE
	var/lockhash = 0
	var/lockid = null
	var/masterkey = TRUE //if masterkey can open this regardless

/obj/machinery/door/unpowered/halflife/Initialize()
	. = ..()
	if(dir == NORTH)
		pixel_y = -8

	if(dir == SOUTH)
		pixel_y = -8

	if(dir == EAST)
		pixel_x = -3
		pixel_y = 1
		add_overlay(image(icon,icon_state="[frametype]_frame_vertical_overlay", layer = ABOVE_ALL_MOB_LAYER))

	if(dir == WEST)
		pixel_x = -28
		pixel_y = 1
		add_overlay(image(icon,icon_state="[frametype]_frame_vertical_overlay", layer = ABOVE_ALL_MOB_LAYER))

	if(lockhash)
		GLOB.lockhashes += lockhash
	else if(locked || keylock)
		if(lockid)
			if(GLOB.lockids[lockid])
				lockhash = GLOB.lockids[lockid]
			else
				lockhash = rand(1000,9999)
				while(lockhash in GLOB.lockhashes)
					lockhash = rand(1000,9999)
				GLOB.lockhashes += lockhash
				GLOB.lockids[lockid] = lockhash
		else
			lockhash = rand(1000,9999)
			while(lockhash in GLOB.lockhashes)
				lockhash = rand(1000,9999)
			GLOB.lockhashes += lockhash

/obj/machinery/door/unpowered/halflife/update_overlays()
	. = ..()

	cut_overlays()

	if(dir == EAST)
		add_overlay(image(icon,icon_state="[frametype]_frame_vertical_overlay", layer = ABOVE_ALL_MOB_LAYER))

	if(dir == WEST)
		add_overlay(image(icon,icon_state="[frametype]_frame_vertical_overlay", layer = ABOVE_ALL_MOB_LAYER))

	if(has_damage_overlay) //stunning code, code of the year
		switch(open)
			if(TRUE)
				switch(mirrored)
					if(TRUE)
						switch(dir)
							if(EAST)
								if(atom_integrity < (0.25 * max_integrity))
									cut_overlays()
									add_overlay(image(icon, icon_state = "damage_closed_3", layer = FLOAT_LAYER, pixel_x = 17, pixel_y = -2))
								else if(atom_integrity < (0.50 * max_integrity))
									cut_overlays()
									add_overlay(image(icon, icon_state = "damage_closed_2", layer = FLOAT_LAYER, pixel_x = 17, pixel_y = -2))
								else if(atom_integrity < (0.75 * max_integrity))
									cut_overlays()
									add_overlay(image(icon, icon_state = "damage_closed_1", layer = FLOAT_LAYER, pixel_x = 17, pixel_y = -2))
							if(WEST)
								if(atom_integrity < (0.25 * max_integrity))
									cut_overlays()
									add_overlay(image(icon, icon_state = "damage_closed_3", layer = FLOAT_LAYER, pixel_x = -17, pixel_y = -2))
								else if(atom_integrity < (0.50 * max_integrity))
									cut_overlays()
									add_overlay(image(icon, icon_state = "damage_closed_2", layer = FLOAT_LAYER, pixel_x = -17, pixel_y = -2))
								else if(atom_integrity < (0.75 * max_integrity))
									cut_overlays()
									add_overlay(image(icon, icon_state = "damage_closed_1", layer = FLOAT_LAYER, pixel_x = -17, pixel_y = -2))
					if(FALSE)
						switch(dir)
							if(EAST)
								if(atom_integrity < (0.25 * max_integrity))
									cut_overlays()
									add_overlay(image(icon, icon_state = "damage_closed_3", layer = FLOAT_LAYER, pixel_x = -17, pixel_y = -2))
								else if(atom_integrity < (0.50 * max_integrity))
									cut_overlays()
									add_overlay(image(icon, icon_state = "damage_closed_2", layer = FLOAT_LAYER, pixel_x = -17, pixel_y = -2))
								else if(atom_integrity < (0.75 * max_integrity))
									cut_overlays()
									add_overlay(image(icon, icon_state = "damage_closed_1", layer = FLOAT_LAYER, pixel_x = -17, pixel_y = -2))
							if(WEST)
								if(atom_integrity < (0.25 * max_integrity))
									cut_overlays()
									add_overlay(image(icon, icon_state = "damage_closed_3", layer = FLOAT_LAYER, pixel_x = 17, pixel_y = -2))
								else if(atom_integrity < (0.50 * max_integrity))
									cut_overlays()
									add_overlay(image(icon, icon_state = "damage_closed_2", layer = FLOAT_LAYER, pixel_x = 17, pixel_y = -2))
								else if(atom_integrity < (0.75 * max_integrity))
									cut_overlays()
									add_overlay(image(icon, icon_state = "damage_closed_1", layer = FLOAT_LAYER, pixel_x = 17, pixel_y = -2))
			if(FALSE)
				switch(dir)
					if(NORTH)
						if(atom_integrity < (0.25 * max_integrity))
							cut_overlays()
							add_overlay(image(icon, icon_state = "damage_closed_3", layer = FLOAT_LAYER, pixel_y = -8))
						else if(atom_integrity < (0.50 * max_integrity))
							cut_overlays()
							add_overlay(image(icon, icon_state = "damage_closed_2", layer = FLOAT_LAYER, pixel_y = -8))
						else if(atom_integrity < (0.75 * max_integrity))
							cut_overlays()
							add_overlay(image(icon, icon_state = "damage_closed_1", layer = FLOAT_LAYER, pixel_y = -8))
					if(SOUTH)
						if(atom_integrity < (0.25 * max_integrity))
							cut_overlays()
							add_overlay(image(icon, icon_state = "damage_closed_3", layer = FLOAT_LAYER))
						else if(atom_integrity < (0.50 * max_integrity))
							cut_overlays()
							add_overlay(image(icon, icon_state = "damage_closed_2", layer = FLOAT_LAYER))
						else if(atom_integrity < (0.75 * max_integrity))
							cut_overlays()
							add_overlay(image(icon, icon_state = "damage_closed_1", layer = FLOAT_LAYER))


/obj/machinery/door/unpowered/halflife/open()
	if(!density)
		return TRUE
	if(operating)
		return
	operating = TRUE
	set_opacity(0)
	set_density(FALSE)
	flags_1 &= ~PREVENT_CLICK_UNDER_1
	open = TRUE
	update_appearance()
	set_opacity(0)
	operating = FALSE
	air_update_turf(TRUE, FALSE)
	update_freelook_sight()
	playsound(src, (opensound), 50, TRUE)
	return TRUE

/obj/machinery/door/unpowered/halflife/close()
	if(density)
		return TRUE
	if(operating)
		return
	if(safe)
		for(var/atom/movable/M in get_turf(src))
			if(M.density && M != src) //something is blocking the door
				return
	operating = TRUE
	set_density(TRUE)
	flags_1 |= PREVENT_CLICK_UNDER_1
	open = FALSE
	update_appearance()
	if(visible && !glass)
		set_opacity(1)
	operating = FALSE
	air_update_turf(TRUE, FALSE)
	update_freelook_sight()
	playsound(src, (closesound), 50, TRUE)
	return TRUE

/obj/machinery/door/unpowered/halflife/update_appearance(updates)
	. = ..()
	if(density)
		icon_state = "[door_type]_closed"
	else
		icon_state = "[door_type]_open"

/obj/machinery/door/unpowered/halflife/try_to_activate_door(mob/living/M)
	add_fingerprint(M)
	if(density)
		open()
	else
		close()
	return TRUE

/obj/machinery/door/unpowered/halflife/attack_hand(mob/living/M)
	if(locked)
		to_chat(M, "<span class='warning'> The [name] is locked.</span>")
		playsound(src, 'sound/halflifesounds/halflifeeffects/door_locked.ogg', 50, TRUE)
		return
	if(.)
		return
	if(halflife_flags_1 & LOCKABLE_1 && lock_locked)
		to_chat(M, span_warning("The [name] is locked."))
		playsound(src, 'sound/halflifesounds/halflifeeffects/door_locked.ogg', 50, TRUE)
		return
	if(do_after(M, 0.5 SECONDS, interaction_key = DOAFTER_SOURCE_DOORS))
		try_to_activate_door(M)

/obj/machinery/door/unpowered/halflife/attackby(obj/item/I, mob/living/M, params)
	. = ..()
	if(istype(I, /obj/item/hl2key))
		trykeylock(I, M)
	if(istype(I, /obj/item/lockpick))
		trypicklock(I, M)
	if(locked && !(M.combat_mode))
		to_chat(M, "<span class='warning'> The [name] is locked.</span>")
		playsound(src, 'sound/halflifesounds/halflifeeffects/door_locked.ogg', 50, TRUE)
		return
		/*
	if(!(I.item_flags & NOBLUDGEON || LOCKING_ITEM) && !(M.combat_mode) && do_after(M, 1.5 SECONDS, interaction_key = DOAFTER_SOURCE_DOORS))
		open = TRUE
		try_to_activate_door(M)
		return TRUE
		*/
	if(!open)
		update_appearance()
		return ((obj_flags & CAN_BE_HIT) && I.attack_atom(src, M, params))

/obj/machinery/door/unpowered/halflife/proc/trykeylock(obj/item/I, mob/user)
	if(!keylock)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	var/obj/item/hl2key/K = I
	if(K.lockhash == lockhash)
		lock_toggle(user)
		return
	return

/obj/machinery/door/unpowered/halflife/proc/trypicklock(obj/item/I, mob/user)
	if(open)
		to_chat(user, "<span class='warning'>This cannot be picked while it is open.</span>")
		return
	if(!keylock)
		return
	else
		var/lockprogress = 0
		var/locktreshold = 100

		var/obj/item/lockpick/P = I
		
		var/picktime = 30
		var/pickchance = 60
		var/moveup = 20

		pickchance *= P.picklvl
		pickchance = clamp(pickchance, 1, 95)



		while(!QDELETED(I) &&(lockprogress < locktreshold))
			if(!do_after(user, picktime, target = src))
				break
			if(prob(pickchance))
				lockprogress += moveup
				playsound(src.loc, pick('sound/items/pickgood1.ogg','sound/items/pickgood2.ogg'), 5, TRUE)
				to_chat(user, "<span class='warning'>Click...</span>")
				if(lockprogress >= locktreshold)
					to_chat(user, "<span class='deadsay'>The locking mechanism gives.</span>")
					lock_toggle(user)
					break
				else
					continue
			else
				playsound(loc, 'sound/items/pickbad.ogg', 40, TRUE)
				I.take_damage(1, BRUTE, "melee")
				to_chat(user, "<span class='warning'>Clack.</span>")
				continue
		return

/obj/machinery/door/unpowered/halflife/proc/lock_toggle(mob/user)
	if(open)
		return
	if(locked)
		user.visible_message("<span class='warning'>[user] unlocks [src].</span>", \
			"<span class='notice'>I unlock [src].</span>")
		locked = 0
		playsound(loc, 'sound/halflifesounds/halflifeeffects/door_unlock.ogg', 40, TRUE)
	else
		user.visible_message("<span class='warning'>[user] locks [src].</span>", \
			"<span class='notice'>I lock [src].</span>")
		locked = 1
		playsound(loc, 'sound/halflifesounds/halflifeeffects/door_unlock.ogg', 40, TRUE)

/obj/machinery/door/unpowered/halflife/do_animate(animation)
	return

/obj/machinery/door/unpowered/halflife/Bumped(atom/movable/AM)
	return

/obj/machinery/door/unpowered/halflife/metal
	name = "metal door"
	icon_state = "metal_closed"
	door_type = "metal"
	assemblytype = /obj/item/stack/sheet/metal
	max_integrity = 750 //its metal
	armor = list(MELEE = 65, BULLET = 80, LASER = 75, ENERGY = 50, BOMB = 30, BIO = 100, FIRE = 60, ACID = 100)
	damage_deflection = 25
	hitted_sound = 'sound/halflifesounds/halflifeeffects/metal_door_hit.ogg'
	opensound = 'sound/machines/metaldoor_open.ogg'
	closesound = 'sound/machines/metaldoor_close.ogg'

/obj/machinery/door/unpowered/halflife/metal/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		playsound(src, 'sound/halflifesounds/halflifeeffects/metal_door_break.ogg', 100, TRUE)
		new /obj/item/stack/sheet/metal(loc)
		for(var/obj/item/I in src)
			I.forceMove(loc)
	qdel(src)

/obj/machinery/door/unpowered/halflife/metal/mirrored
	icon_state = "metal_mirrored_closed"
	door_type = "metal_mirrored"
	mirrored = TRUE

/obj/machinery/door/unpowered/halflife/metal/alt
	icon_state = "metal_alt_closed"
	door_type = "metal_alt"

/obj/machinery/door/unpowered/halflife/metal/mirrored/alt
	icon_state = "metal_alt_mirrored_closed"
	door_type = "metal_alt_mirrored"

/obj/machinery/door/unpowered/halflife/metal/red
	icon_state = "metal_red_closed"
	door_type = "metal_red"

/obj/machinery/door/unpowered/halflife/metal/mirrored/red
	icon_state = "metal_red_mirrored_closed"
	door_type = "metal_red_mirrored"

// Wood doors //
/obj/machinery/door/unpowered/halflife/wood
	name = "wood door"
	icon_state = "wood_closed"
	door_type = "wood"
	frametype = "wood"
	assemblytype = /obj/item/stack/sheet/mineral/wood
	hitted_sound = 'sound/halflifesounds/halflifeeffects/wood_door_hit.ogg'
	opensound = 'sound/machines/wooddoor_open.ogg'
	closesound = 'sound/machines/wooddoor_close.ogg'

/obj/machinery/door/unpowered/halflife/wood/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		playsound(src, 'sound/halflifesounds/halflifeeffects/wood_door_break.ogg', 100, TRUE)
		new /obj/item/stack/sheet/mineral/wood(loc)
		for(var/obj/item/I in src)
			I.forceMove(loc)
	qdel(src)

/obj/machinery/door/unpowered/halflife/wood/mirrored
	icon_state = "wood_mirrored_closed"
	door_type = "wood_mirrored"
	mirrored = TRUE

/obj/machinery/door/unpowered/halflife/wood/red
	icon_state = "wood_red_closed"
	door_type = "wood_red"

/obj/machinery/door/unpowered/halflife/wood/mirrored/red
	icon_state = "wood_red_mirrored_closed"
	door_type = "wood_red_mirrored"

/obj/machinery/door/unpowered/halflife/wood/blue
	icon_state = "wood_blue_closed"
	door_type = "wood_blue"

/obj/machinery/door/unpowered/halflife/wood/mirrored/blue
	icon_state = "wood_blue_mirrored_closed"
	door_type = "wood_blue_mirrored"

/obj/machinery/door/unpowered/halflife/wood/green
	icon_state = "wood_green_closed"
	door_type = "wood_green"

/obj/machinery/door/unpowered/halflife/wood/mirrored/green
	icon_state = "wood_green_mirrored_closed"
	door_type = "wood_green_mirrored"

/obj/machinery/door/unpowered/halflife/wood/white
	icon_state = "wood_white_closed"
	door_type = "wood_white"

/obj/machinery/door/unpowered/halflife/wood/mirrored/white
	icon_state = "wood_white_mirrored_closed"
	door_type = "wood_white_mirrored"

// Window/Open doors //

/obj/machinery/door/unpowered/halflife/seethrough
	name = "generic halflife see-through door"
	glass = TRUE
	opacity = 0
	assemblytype = /obj/item/stack/sheet/metal
	var/passthrough_chance = 80

/obj/machinery/door/unpowered/halflife/seethrough/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(locate(/obj/machinery/door/unpowered/halflife/seethrough) in get_turf(mover))
		return TRUE
	else if(istype(mover, /obj/projectile))
		if(!anchored)
			return TRUE
		var/obj/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return TRUE
		if(prob((passthrough_chance)))
			return TRUE
		return FALSE

/obj/machinery/door/unpowered/halflife/seethrough/metal
	name = "metal door"
	icon_state = "metal_window_closed"
	door_type = "metal_window"
	passthrough_chance = 40 //Small window!
	max_integrity = 750 //its metal
	armor = list(MELEE = 65, BULLET = 80, LASER = 75, ENERGY = 50, BOMB = 30, BIO = 100, FIRE = 60, ACID = 100)
	damage_deflection = 25
	hitted_sound = 'sound/halflifesounds/halflifeeffects/metal_door_hit.ogg'

/obj/machinery/door/unpowered/halflife/seethrough/metal/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		playsound(src, 'sound/halflifesounds/halflifeeffects/metal_door_break.ogg', 100, TRUE)
		new /obj/item/stack/sheet/metal(loc)
		for(var/obj/item/I in src)
			I.forceMove(loc)
	qdel(src)

/obj/machinery/door/unpowered/halflife/seethrough/mirrored/metal
	name = "metal door"
	icon_state = "metal_window_mirrored_closed"
	door_type = "metal_window_mirrored"
	mirrored = TRUE

/obj/machinery/door/unpowered/halflife/seethrough/bar
	name = "barred door"
	icon_state = "metal_bar_closed"
	door_type = "metal_bar"
	has_damage_overlay = FALSE

/obj/machinery/door/unpowered/halflife/seethrough/mirrored/bar
	name = "barred door"
	icon_state = "metal_bar_mirrored_closed"
	door_type = "metal_bar_mirrored"
	has_damage_overlay = FALSE

/obj/machinery/door/unpowered/halflife/seethrough/grate
	name = "grated door"
	icon_state = "metal_grate_closed"
	door_type = "metal_grate"
	has_damage_overlay = FALSE

/obj/machinery/door/unpowered/halflife/seethrough/mirrored/grate
	name = "grated door"
	icon_state = "metal_grate_mirrored_closed"
	door_type = "metal_grate_mirrored"
	has_damage_overlay = FALSE
