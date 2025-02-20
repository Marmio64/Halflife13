/*
	Basically just an empty shell for receiving and broadcasting radio messages. Not
	very flexible, but it gets the job done.
*/

/obj/machinery/telecomms/allinone
	name = "telecommunications mainframe relay"
	icon_state = "comm_tower"
	icon = 'icons/port/comm_tower2.dmi'
	desc = "A communications tower which hosts local frequencies and broadcasts. Required for most radio equipment to function."
	density = TRUE
	use_power = NO_POWER_USE
	idle_power_usage = 0
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	var/intercept = FALSE  // If true, only works on the Syndicate frequency.

/obj/machinery/telecomms/allinone/indestructable
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	flags_1 = NODECONSTRUCT_1

/obj/machinery/telecomms/allinone/Initialize(mapload)
	. = ..()
	id = "Telecommunicatons Mainframe" //Does nothing, just prevents from showing NULL
	network = "DistrictMain"
	if (intercept)
		freq_listening = list(FREQ_SYNDICATE)

/obj/machinery/telecomms/allinone/receive_signal(datum/signal/subspace/signal)
	if(!istype(signal) || signal.transmission_method != TRANSMISSION_SUBSPACE)  // receives on subspace only
		return
	if(!on || !is_freq_listening(signal))  // has to be on to receive messages
		return
	if (!intercept && !(z in signal.levels) && !(0 in signal.levels))  // has to be syndicate or on the right level
		return

	// Decompress the signal and mark it done
	if (intercept)
		signal.levels += 0  // Signal is broadcast to agents anywhere

	signal.data["compression"] = 0
	signal.mark_done()
	if(signal.data["slow"] > 0)
		sleep(signal.data["slow"]) // simulate the network lag if necessary
	signal.broadcast()

/obj/machinery/telecomms/allinone/attackby(obj/item/P, mob/user, params)
	if(P.tool_behaviour == TOOL_MULTITOOL)
		return attack_hand(user)
