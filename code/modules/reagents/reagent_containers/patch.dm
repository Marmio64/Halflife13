/obj/item/reagent_containers/pill/patch
	name = "chemical patch"
	desc = "A chemical patch for touch based applications."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bandaid"
	item_state = "bandaid"
	possible_transfer_amounts = list()
	volume = 40
	apply_type = PATCH
	apply_method = "apply"
	self_delay = 30		// three seconds
	dissolvable = FALSE

/obj/item/reagent_containers/pill/patch/attack(mob/living/L, mob/user)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.wear_suit?.item_flags & MEDRESIST && !get_location_accessible(H, H.zone_selected))
			to_chat(user, span_warning("[src] cannot be applied through [H.wear_suit]!"))
			return
		var/obj/item/bodypart/affecting = L.get_bodypart(check_zone(user.zone_selected))
		if(!affecting)
			to_chat(user, span_warning("The limb is missing!"))
			return
		if(affecting.status != BODYPART_ORGANIC)
			to_chat(user, span_notice("Medicine won't work on a robotic limb!"))
			return
	..()

/obj/item/reagent_containers/pill/patch/canconsume(mob/eater, mob/user)
	if(!iscarbon(eater))
		return 0
	return 1 // Masks were stopping people from "eating" patches. Thanks, inheritance.

/obj/item/reagent_containers/pill/patch/styptic
	name = "brute patch"
	desc = "Helps with brute injuries."
	list_reagents = list(/datum/reagent/medicine/styptic_powder = 20)
	icon_state = "bandaid_brute"

/obj/item/reagent_containers/pill/patch/silver_sulf
	name = "burn patch"
	desc = "Helps with burn injuries."
	list_reagents = list(/datum/reagent/medicine/silver_sulfadiazine = 20)
	icon_state = "bandaid_burn"

/obj/item/reagent_containers/pill/patch/synthflesh
	name = "synthflesh patch"
	desc = "Helps with brute and burn injuries."
	list_reagents = list(/datum/reagent/medicine/synthflesh = 20)
	icon_state = "bandaid_both"

/obj/item/reagent_containers/pill/patch/medkit
	name = "medkit"
	desc = "A medical kit filled with biogel for quickly tending to injuries."
	list_reagents = list(/datum/reagent/medicine/biogel = 20)
	icon = 'icons/obj/halflife/medkits.dmi'
	icon_state = "medkit"
	apply_sound = 'sound/effects/smallmedkit1.ogg'

/obj/item/reagent_containers/pill/patch/medkit/manufactured
	name = "new medkit"
	desc = "A medical kit filled with biogel for quickly tending to injuries. This one looks very new, and recently made. Could be sold."
	
/obj/item/reagent_containers/pill/patch/medkit/vial
	name = "medvial"
	desc = "A small vial of biogel. Quick to apply, but doesn't heal much."
	list_reagents = list(/datum/reagent/medicine/biogel = 10)
	self_delay = 15
	icon_state = "medvial"
	
/obj/item/reagent_containers/pill/patch/grubnugget
	name = "grub nugget"
	desc = "A small nugget obtained from an antlion grub. You're not exactly sure what to do with this."
	list_reagents = list(/datum/reagent/medicine/biogel = 10)
	self_delay = 15
	icon = 'icons/mob/halflife.dmi'
	icon_state = "grub_nugget"
