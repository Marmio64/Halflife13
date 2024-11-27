/obj/machinery/ration_vendor
	name = "\improper Ration Vendor"
	desc = "A machine that will deliver you a suitable ration depending on your status, and if you have a ration voucher loaded on your account."
	icon_state = "ration_dispenser"
	icon = 'icons/obj/vending.dmi'
	var/icon_state_vend = "ration_dispenser-vend"
	var/icon_state_deny = "ration_dispenser-deny"
	resistance_flags = FIRE_PROOF
	max_integrity = 1500 //Because it is pretty important, and there probably will only be one of them. 
	var/datum/bank_account/account  //person's account.
	var/obj/item/card/id/C //the account of the person using the vendor unit.

/obj/machinery/ration_vendor/interact(mob/living/carbon/human/user)
	. = ..()
	var/ration_quality = 3 //1 is terrible, 2 is lowgrade, 3 is standard, 4 is better/production grade, 5 is loyalty grade, 6 is best grade
	var/vortigaunt = FALSE //are they a vortigaunt role?

	if(.)
		return
	C = user.get_idcard(TRUE)
	if(!istype(C))
		say("No ID card detected.") // No unidentified crew.
		playsound(src, 'sound/machines/combine_button_locked.ogg', 50, TRUE, extrarange = -3)
		flick(icon_state_deny,src)
		return
	if(C.registered_account)
		account = C.registered_account
	else
		say("Warning, an account is not detected on your ID card. Contact a local protection team member immediately.")
		playsound(src, 'sound/machines/combine_button_locked.ogg', 50, TRUE, extrarange = -3)
		flick(icon_state_deny,src)
		return
	if(!account.ration_voucher)
		say("You do not have a usable ration voucher in your account.")
		playsound(src, 'sound/machines/combine_button_locked.ogg', 50, TRUE, extrarange = -3)
		flick(icon_state_deny,src)
		return
	if(SSration.cycle_active == FALSE)
		say("A ration cycle is not currently active.") // You snooze you lose.
		playsound(src, 'sound/machines/combine_button_locked.ogg', 50, TRUE, extrarange = -3)
		flick(icon_state_deny,src)
		return

	say("Citizen Account Record detected. Determining ration reward.")

	playsound(src, 'sound/machines/combine_button3.ogg', 50, TRUE, extrarange = -3)

	if(!do_after(user, 4 SECONDS, src))
		to_chat(usr, span_warning("The machine did not finish determining your ration reward!"))
		playsound(src, 'sound/machines/combine_button_locked.ogg', 50, TRUE, extrarange = -3)
		flick(icon_state_deny,src)
		return

	var/username = user.get_face_name(user.get_id_name())
	var/datum/data/record/R = find_record("name", username, GLOB.data_core.security)
	if(R)
		if((R.fields["criminal"] == WANTED_ANTICITIZEN))
			say("Warning, your civil status is in question by local protection teams. Please apply.")
			playsound(src, 'sound/machines/combine_button_locked.ogg', 50, TRUE, extrarange = -3)
			flick(icon_state_deny,src)
			return
		if((R.fields["criminal"] == WANTED_LOYALIST)) //Loyalists get a higher grade of rations
			ration_quality++
		if((R.fields["criminal"] == WANTED_SUSPECT)) //Suspected people are given a worse grade of rations
			ration_quality--
	if(account?.account_job.title == "Vortigaunt Slave") //Shitty ration bonus handled in job datum, this just lets the ration vendor knows they're a vort
		vortigaunt = TRUE
	ration_quality += account?.account_job.ration_bonus //applies job specific ration bonuses

	say("Ration reward determined. Please wait for ration to be dispensed.")

	playsound(src, 'sound/machines/combine_button5.ogg', 50, TRUE, extrarange = -3)

	sleep(1 SECONDS)

	playsound(src, 'sound/machines/combine_dispense.ogg', 50, TRUE, extrarange = -3)

	flick(icon_state_vend,src)

	sleep(2 SECONDS)

	account.ration_voucher = FALSE
	dispense(ration_quality, vortigaunt)
	return

/obj/machinery/ration_vendor/proc/dispense(quality, vortigaunt)
	SSsociostability.modifystability(1) //Compliance brings stability.

	flick(icon_state_vend,src)

	if(vortigaunt)
		say("Here is your designated meal, biotic.")
	else
		say("Enjoy your designated meal.")

	playsound(src, 'sound/machines/machine_vend.ogg', 50, TRUE, extrarange = -3)

	switch(quality)
		if(0 to 1)
			new /obj/item/storage/box/halflife/worstration(loc)
		if(2)
			new /obj/item/storage/box/halflife/badration(loc)
		if(3)
			new /obj/item/storage/box/halflife/ration(loc)
		if(4)
			new /obj/item/storage/box/halflife/betterration(loc)
		if(5)
			new /obj/item/storage/box/halflife/loyaltyration(loc)
		if(6 to 10)
			new /obj/item/storage/box/halflife/bestration(loc)

/obj/machinery/ration_vendor/proc/deny()
