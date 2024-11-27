SUBSYSTEM_DEF(sociostability)
	name = "Sociostability"
	wait = 3 MINUTES
	init_order = INIT_ORDER_SOCIOSTABILITY
	runlevels = RUNLEVEL_GAME
	var/sociostability = SOCIOSTABILITY_GREAT
	var/okay_package_received = FALSE
	var/poor_package_received = FALSE
	var/bad_package_received = FALSE

/datum/controller/subsystem/sociostability/fire(resumed = 0)
	if(sociostability < SOCIOSTABILITY_GREAT)
		modifystability(SOCIOSTABILITY_PASSIVE_GAIN)


	if(sociostability < SOCIOSTABILITY_POOR) //Poor sociostability means a poor district. Buying power will be reduced by 20%.
		SSeconomy.pack_price_modifier = 1.2
	else
		SSeconomy.pack_price_modifier = 1

	if(sociostability < SOCIOSTABILITY_OKAY && !okay_package_received)
		drop_package()
		okay_package_received = TRUE
		return
	if(sociostability < SOCIOSTABILITY_POOR && !poor_package_received)
		drop_package()
		poor_package_received = TRUE
		return
	if(sociostability < SOCIOSTABILITY_BAD && !bad_package_received)
		drop_package()
		bad_package_received = TRUE
		return

/datum/controller/subsystem/sociostability/proc/drop_package(amount)
	var/datum/round_event_control/care_package/PackageControl = new /datum/round_event_control/care_package()
	var/datum/round_event/care_package/package = PackageControl.runEvent()
	package.setup()

/datum/controller/subsystem/sociostability/proc/modifystability(amount)
	sociostability += amount
	if(sociostability > SOCIOSTABILITY_GREAT)
		sociostability = SOCIOSTABILITY_GREAT
	else if (sociostability < SOCIOSTABILITY_TERRIBLE)
		sociostability = SOCIOSTABILITY_TERRIBLE

///This just gets the amount of sociostability that has been lost in comparison to the max/starting value.
/datum/controller/subsystem/sociostability/proc/getloss()
	var/loss = abs(sociostability - SOCIOSTABILITY_GREAT) //ex: stability is 700. 700-1000 = -300, then absolute value is 300. 300 stability has been lost.
	return loss
