//KEEP IN MIND: These are different from gun/grenadelauncher. These are designed to shoot premade rocket and grenade projectiles, not flashbangs or chemistry casings etc.
//Put handheld rocket launchers here if someone ever decides to make something so hilarious ~Paprika

/obj/item/gun/ballistic/revolver/grenadelauncher//this is only used for underbarrel grenade launchers at the moment, but admins can still spawn it if they feel like being assholes
	desc = "A break-operated grenade launcher."
	name = "grenade launcher"
	icon_state = "dshotgun_sawn"
	item_state = "gun"
	mag_type = /obj/item/ammo_box/magazine/internal/grenadelauncher
	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	pin = /obj/item/firing_pin/implant/pindicate
	bolt_type = BOLT_TYPE_NO_BOLT

/obj/item/gun/ballistic/revolver/grenadelauncher/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/revolver/grenadelauncher/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing))
		chamber_round()

/obj/item/gun/ballistic/revolver/grenadelauncher/cyborg
	desc = "A 6-shot grenade launcher."
	name = "multi grenade launcher"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_grenadelnchr"
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/grenademulti
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/revolver/grenadelauncher/cyborg/attack_self()
	return

/obj/item/gun/ballistic/automatic/gyropistol
	name = "gyrojet pistol"
	desc = "A prototype pistol designed to fire self propelled rockets."
	icon_state = "gyropistol"
	fire_sound = 'sound/weapons/grenadelaunch.ogg'
	mag_type = /obj/item/ammo_box/magazine/m75
	burst_size = 1
	fire_delay = 0
	actions_types = list()
	casing_ejector = FALSE

/obj/item/gun/ballistic/rocketlauncher
	name = "\improper PML-9"
	desc = "A reusable rocket propelled grenade launcher. The words \"NT this way\" and an arrow have been written near the barrel."
	icon_state = "rocketlauncher"
	item_state = "rocketlauncher"
	pickup_sound = 'sound/weapons/weapon_pickup.ogg'
	mag_type = /obj/item/ammo_box/magazine/internal/rocketlauncher
	fire_sound = 'sound/weapons/rocketlaunch.ogg'
	w_class = WEIGHT_CLASS_BULKY
	can_suppress = FALSE
	pin = /obj/item/firing_pin/implant/pindicate
	burst_size = 1
	fire_delay = 0
	casing_ejector = FALSE
	weapon_weight = WEAPON_HEAVY
	bolt_type = BOLT_TYPE_NO_BOLT
	internal_magazine = TRUE
	cartridge_wording = "rocket"
	empty_indicator = TRUE
	tac_reloads = FALSE

/obj/item/gun/ballistic/rocketlauncher/unrestricted
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/rocketlauncher/process_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE, atom/shooter = null)
	magazine.get_round(FALSE)

/obj/item/gun/ballistic/rocketlauncher/equipped()
	if(prob(1))
		pickup_sound = 'sound/weapons/metalslugrocketlauncher.ogg'
	. = ..()
	pickup_sound = initial(pickup_sound)

/obj/item/gun/ballistic/rocketlauncher/attack_self_tk(mob/user)
	return //too difficult to remove the rocket with TK

/obj/item/gun/ballistic/rocketlauncher/suicide_act(mob/living/user)
	user.visible_message("<span class='warning'>[user] aims [src] at the ground! It looks like [user.p_theyre()] performing a sick rocket jump!<span>", \
		span_userdanger("You aim [src] at the ground to perform a bisnasty rocket jump..."))
	if(can_shoot())
		user.notransform = TRUE
		playsound(src, 'sound/vehicles/rocketlaunch.ogg', 80, 1, 5)
		animate(user, pixel_z = 300, time = 3 SECONDS, easing = LINEAR_EASING)
		sleep(7 SECONDS)
		animate(user, pixel_z = 0, time = 0.5 SECONDS, easing = LINEAR_EASING)
		sleep(0.5 SECONDS)
		user.notransform = FALSE
		process_fire(user, user, TRUE)
		if(!QDELETED(user)) //if they weren't gibbed by the explosion, take care of them for good.
			user.gib()
		return MANUAL_SUICIDE
	else
		sleep(0.5 SECONDS)
		shoot_with_empty_chamber(user)
		sleep(2 SECONDS)
		user.visible_message(span_warning("[user] looks about the room realizing [user.p_theyre()] still there. [user.p_they(TRUE)] proceed to shove [src] down their throat and choke [user.p_them()]self with it!"), \
			span_userdanger("You look around after realizing you're still here, then proceed to choke yourself to death with [src]!"))
		sleep(2 SECONDS)
		return OXYLOSS
		
/obj/item/gun/ballistic/handcannon
	name = "hand cannon"
	desc = "Since the times of shooting cannonballs from ships has long passed, pirate culture has moved onto making these ship-piercing weapons handheld."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "handcannon"
	item_state = "handycannon"
	mag_type = /obj/item/ammo_box/magazine/internal/cannonball
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	casing_ejector = FALSE
	bolt_type = BOLT_TYPE_NO_BOLT
	internal_magazine = TRUE
	empty_indicator = TRUE
	tac_reloads = FALSE
	can_suppress = FALSE
	force = 10
	cartridge_wording = "cannonball"
	fire_sound = 'sound/effects/bang.ogg'
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/gauss
	name = "gauss rifle"
	desc = "A makeshift gauss rifle, barely holding together with tape and cables"
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "gauss"
	item_state = "gauss"
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	mag_type = /obj/item/ammo_box/magazine/internal/rods
	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	casing_ejector = FALSE
	bolt_type = BOLT_TYPE_NO_BOLT
	internal_magazine = TRUE
	empty_indicator = TRUE
	can_suppress = FALSE
	force = 10
	cartridge_wording = "rod"
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	pin = /obj/item/firing_pin

/obj/item/gun/ballistic/gauss/shoot_live_shot(mob/living/user, pointblank, atom/pbtarget, message)
	. = ..()
	playsound(loc, "sparks", 75, 1, -1)
	do_sparks(8, 3, usr)

/obj/item/gun/ballistic/maint_musket
	name = "maintenance musket"
	desc = "A weapon with notoriously poor accuracy; it makes up for this by being quick and easy to smash together."
	icon_state = "maint_musket"
	item_state = "maint_musket"
	mag_type = /obj/item/ammo_box/magazine/internal/cartridge
	w_class = WEIGHT_CLASS_HUGE
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_BACK
	casing_ejector = FALSE
	bolt_type = BOLT_TYPE_NO_BOLT
	internal_magazine = TRUE
	empty_indicator = FALSE
	can_bayonet = TRUE
	knife_x_offset = 27
	knife_y_offset = 13
	can_suppress = FALSE
	force = 5
	cartridge_wording = "cartridge"
	fire_sound = 'sound/weapons/musket_shot.ogg'
	load_sound = 'sound/weapons/musket_cock.ogg'
	pin = /obj/item/firing_pin
	var/reloading_active = FALSE

/obj/item/gun/ballistic/maint_musket/process_chamber(empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE, atom/shooter = null)
	magazine.get_round(FALSE)

/obj/item/gun/ballistic/maint_musket/attackby(obj/item/A, mob/user, params)
	
	if(istype(A, /obj/item/ammo_casing/caseless/cartridge))
		if(reloading_active)
			to_chat(user, span_warning("You're already reloading it!"))
			return
		if(magazine.stored_ammo.len > 0)
			user.balloon_alert(user, "Already loaded!")
			return
		user.visible_message(span_warning("[user] starts reloading [src]!"), span_notice("You start reloading [src]."))
		reloading_active = TRUE
		if(!do_after(user, 5 SECONDS, user))
			reloading_active = FALSE
			user.balloon_alert(user, "You were interrupted!")
			return
		reloading_active = FALSE

	if(istype(A, /obj/item/kitchen/knife/plug_bayonet))
		//Turn it into a spear if unloaded and has no bayonet
		if(magazine.stored_ammo.len != 0)
			user.balloon_alert(user, "Unload it!")
			return
		else if(src.bayonet)
			user.balloon_alert(user, "Remove its bayonet!")
			return
		else
			user.balloon_alert(user, "Barrel plugged!")
			user.visible_message(span_warning("[user] plugs [src]!"), span_notice("You plug [src]."))
			var/obj/item/melee/spear/plugged_musket/P = new /obj/item/melee/spear/plugged_musket
			qdel(src)
			qdel(A)
			user.put_in_hands(P)
	..()
