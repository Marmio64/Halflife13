/obj/machinery/combine_recharger
	name = "combine recharger"
	desc = "A wall mounted recharger unit which can refill the battery capacity of combine suits. It slowly restores power over time."
	icon = 'icons/obj/halflife/machinery.dmi'
	icon_state = "suitcharger"
	circuit = /obj/item/circuitboard/machine/combinerecharger
	var/capacity = 50
	var/capacity_max = 100

	var/round_start = FALSE

/obj/machinery/combine_recharger/round_start
	round_start = TRUE //so that it deducts sociostability when destroyed

/obj/machinery/combine_recharger/proc/adjust_capacity(change)
	capacity += change
	if(capacity > capacity_max)
		capacity = capacity_max
	if(capacity < 0)
		capacity = 0

/obj/machinery/combine_recharger/process(delta_time)
	if(capacity < capacity_max)
		capacity++
		update_icon_state()

/obj/machinery/combine_recharger/examine(mob/user)
	. = ..()
	. += span_notice("Its capacity is at '[(capacity/capacity_max)*100]%'.")

/obj/machinery/combine_recharger/attack_hand(mob/living/carbon/human/H, modifiers)
	. = ..()
	if(.)
		return
	add_fingerprint(H)
	if (H.w_uniform)
		if(H.w_uniform.powered_suit)
			if(H.w_uniform.suit_power < H.w_uniform.max_suit_power && capacity > 19)
				playsound(src, 'sound/effects/suitcharge1.ogg', 40, FALSE)
				if(do_after(H, 2 SECONDS, src))
					H.w_uniform.adjust_suitpower(20)
					adjust_capacity(-20)
					playsound(src, 'sound/effects/suitchargeok1.ogg', 40, FALSE)
					update_icon_state()
				else
					playsound(src, 'sound/effects/suitchargeno1.ogg', 40, FALSE)
			else
				playsound(src, 'sound/effects/suitchargeno1.ogg', 40, FALSE)
		else
			to_chat(H, span_warning("You do not have a compatible suit for recharging."))
			playsound(src, 'sound/effects/suitchargeno1.ogg', 40, FALSE)
	return

/obj/machinery/combine_recharger/update_icon_state()
	. = ..()
	if(capacity > 60)
		icon_state = "suitcharger_01"
	else if(capacity > 20)
		icon_state = "suitcharger_02"
	else
		icon_state = "suitcharger_03"

/obj/machinery/combine_recharger/deconstruct(disassembled = TRUE)
	. = ..()
	if(round_start)
		SSsociostability.modifystability(-20) //Destroying vital roundstart placed combine rechargers is bad for stability.
