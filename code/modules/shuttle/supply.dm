GLOBAL_LIST_INIT(blacklisted_cargo_types, typecacheof(list(
		/mob/living,
		/obj/structure/blob,
		/obj/effect/rune,
		/obj/structure/spider/spiderling,
		/obj/item/disk/nuclear,
		/obj/machinery/nuclearbomb,
		/obj/item/beacon,
		/obj/singularity/narsie,
		/obj/singularity/wizard,
		/obj/machinery/teleport/station,
		/obj/machinery/teleport/hub,
		/obj/machinery/quantumpad,
		/obj/machinery/clonepod,
		/obj/effect/mob_spawn,
		/obj/effect/hierophant,
		/obj/structure/receiving_pad,
		/obj/effect/clockwork/spatial_gateway,
		/obj/structure/destructible/clockwork/powered/clockwork_obelisk,
		/obj/item/warp_cube,
		/obj/machinery/rnd/production, //print tracking beacons, send shuttle
		/obj/machinery/autolathe, //same
		/obj/projectile/beam/wormhole,
		/obj/effect/portal,
		/obj/item/shared_storage,
		/obj/structure/extraction_point,
		/obj/machinery/syndicatebomb,
		/obj/item/hilbertshotel,
		/obj/structure/disposalpipe,
		/obj/structure/disposaloutlet, // connect outlet to bin, knock outlet onto shuttle, send it, enter bin
		/obj/machinery/disposal
	)))

/obj/docking_port/mobile/supply
	name = "supply shuttle"
	shuttle_id = "supply"
	callTime = 30 SECONDS

	dir = WEST
	port_direction = EAST
	width = 12
	dwidth = 5
	height = 7
	movement_force = list("KNOCKDOWN" = 0, "THROW" = 0)


	//Export categories for this run, this is set by console sending the shuttle.
	var/export_categories = EXPORT_CARGO

/obj/docking_port/mobile/supply/register()
	. = ..()
	SSshuttle.supply = src

/obj/docking_port/mobile/supply/canMove()
	if(is_station_level(z))
		return check_blacklist(shuttle_areas)
	return ..()

/obj/docking_port/mobile/supply/proc/check_blacklist(areaInstances)
	for(var/place in areaInstances)
		var/area/shuttle/shuttle_area = place
		for(var/trf in shuttle_area)
			var/turf/T = trf
			for(var/a in T.get_all_contents())
				for(var/obj/structure/closet/crate/secure/owned/crate in a)
					if(crate.locked)
						return FALSE
				if(is_type_in_typecache(a, GLOB.blacklisted_cargo_types))
					return FALSE
	return TRUE

/obj/docking_port/mobile/supply/request(obj/docking_port/stationary/S)
	if(mode != SHUTTLE_IDLE)
		return 2
	return ..()

/obj/docking_port/mobile/supply/initiate_docking()
	if(getDockedId() == "supply_away") // Buy when we leave home.
		buy()
	. = ..() // Fly/enter transit.
	if(. != DOCKING_SUCCESS)
		return
	if(getDockedId() == "supply_away") // Sell when we get home
		sell()

/obj/docking_port/mobile/supply/proc/buy()
	var/list/obj/miscboxes = list() //miscboxes are combo boxes that contain all small_item orders grouped
	var/list/misc_order_num = list() //list of strings of order numbers, so that the manifest can show all orders in a box
	var/list/misc_contents = list() //list of lists of items that each box will contain
	if(!SSshuttle.shopping_list.len)
		return

	var/list/empty_turfs = list()
	for(var/place in shuttle_areas)
		var/area/shuttle/shuttle_area = place
		for(var/turf/open/floor/T in shuttle_area)
			if(T.is_blocked_turf())
				continue
			empty_turfs += T

	var/value = 0
	var/purchases = 0
	for(var/datum/supply_order/SO in SSshuttle.shopping_list)
		if(!empty_turfs.len)
			break
		var/price = SO.pack.get_cost()
		var/datum/bank_account/D
		if(SO.paying_account) //Someone paid out of pocket
			D = SO.paying_account
			price *= 1.1 //TODO make this customizable by the quartermaster
		else
			D = SSeconomy.get_dep_account(ACCOUNT_CAR)
		if(D)
			if(!D.adjust_money(-price))
				if(SO.paying_account)
					D.bank_card_talk("Cargo order #[SO.id] rejected due to lack of funds. Credits required: [price]")
				continue

		if(SO.paying_account)
			D.bank_card_talk("Cargo order #[SO.id] has shipped. [price] credits have been charged to your bank account.")
			var/datum/bank_account/department/cargo = SSeconomy.get_dep_account(ACCOUNT_CAR)
			cargo.adjust_money(price - SO.pack.get_cost()) //Cargo gets the handling fee
		value += SO.pack.get_cost()
		SSshuttle.shopping_list -= SO
		SSshuttle.order_history += SO

		if(SO.pack.small_item) //small_item means it gets piled in the miscbox
			if(SO.paying_account)
				if(!miscboxes.len || !miscboxes[D.account_holder]) //if there's no miscbox for this person
					if(SO.paying_account == SSeconomy.get_dep_account(ACCOUNT_MED))
						miscboxes[D.account_holder] = new /obj/structure/closet/crate/secure/owned/cheap/medical(pick_n_take(empty_turfs), SO.paying_account)
					else if(SO.paying_account == SSeconomy.get_dep_account(ACCOUNT_ENG))
						miscboxes[D.account_holder] = new /obj/structure/closet/crate/secure/owned/cheap/engineering(pick_n_take(empty_turfs), SO.paying_account)
					else if(SO.paying_account == SSeconomy.get_dep_account(ACCOUNT_SCI))
						miscboxes[D.account_holder] = new /obj/structure/closet/crate/secure/owned/cheap/science(pick_n_take(empty_turfs), SO.paying_account)
					else if(SO.paying_account == SSeconomy.get_dep_account(ACCOUNT_SRV))
						miscboxes[D.account_holder] = new /obj/structure/closet/crate/secure/owned/cheap/hydroponics(pick_n_take(empty_turfs), SO.paying_account)
					else if(SO.paying_account == SSeconomy.get_dep_account(ACCOUNT_SEC))
						miscboxes[D.account_holder] = new /obj/structure/closet/crate/secure/owned/cheap/gear(pick_n_take(empty_turfs), SO.paying_account)
					else if(SO.paying_account == SSeconomy.get_dep_account(ACCOUNT_CIV))
						miscboxes[D.account_holder] = new /obj/structure/closet/crate/secure/owned/cheap/civ(pick_n_take(empty_turfs), SO.paying_account)
					else
						miscboxes[D.account_holder] = new /obj/structure/closet/crate/secure/owned/cheap(pick_n_take(empty_turfs), SO.paying_account)
					miscboxes[D.account_holder].name = "small items crate - purchased by [D.account_holder]"
					misc_contents[D.account_holder] = list()
				for (var/item in SO.pack.contains)
					misc_contents[D.account_holder] += item
				misc_order_num[D.account_holder] = "[misc_order_num[D.account_holder]]#[SO.id]  "
			else //No private payment, so we just stuff it all into a generic crate
				if(!miscboxes.len || !miscboxes["Cargo"])
					miscboxes["Cargo"] = new /obj/structure/closet/crate/secure/cheap(pick_n_take(empty_turfs))
					miscboxes["Cargo"].name = "small items crate"
					misc_contents["Cargo"] = list()
					miscboxes["Cargo"].req_access = list()
				for (var/item in SO.pack.contains)
					misc_contents["Cargo"] += item
					//new item(miscboxes["Cargo"])
				if(SO.pack.access)
					miscboxes["Cargo"].req_access += SO.pack.access
				misc_order_num["Cargo"] = "[misc_order_num["Cargo"]]#[SO.id]  "
		else
			SO.generate(pick_n_take(empty_turfs))

		SSblackbox.record_feedback("nested tally", "cargo_imports", 1, list("[SO.pack.get_cost()]", "[SO.pack.name]"))
		investigate_log("Order #[SO.id] ([SO.pack.name], placed by [key_name(SO.orderer_ckey)]), paid by [D.account_holder] has shipped.", INVESTIGATE_CARGO)
		if(SO.pack.dangerous)
			message_admins("\A [SO.pack.name] ordered by [ADMIN_LOOKUPFLW(SO.orderer_ckey)], paid by [D.account_holder] has shipped.")
		purchases++

	for(var/I in miscboxes)
		var/datum/supply_order/SO = new/datum/supply_order()
		SO.id = misc_order_num[I]
		SO.generateCombo(miscboxes[I], I, misc_contents[I])
		qdel(SO)

	var/datum/bank_account/cargo_budget = SSeconomy.get_dep_account(ACCOUNT_CAR)
	investigate_log("[purchases] orders in this shipment, worth [value] credits. [cargo_budget.account_balance] credits left.", INVESTIGATE_CARGO)

/obj/docking_port/mobile/supply/proc/sell()
	var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
	var/presale_points = D.account_balance

	if(!GLOB.exports_list.len) // No exports list? Generate it!
		setupExports()

	var/msg = ""
	var/matched_bounty = FALSE

	var/datum/export_report/ex = new

	for(var/place in shuttle_areas)
		var/area/shuttle/shuttle_area = place
		for(var/atom/movable/AM in shuttle_area)
			if(iscameramob(AM))
				continue
			if(istype(AM, /obj/structure/closet/crate))
				var/obj/structure/closet/crate/C = AM
				if(C.manifest)
					var/obj/item/paper/manifest = C.manifest
					if(!manifest.stamped) // Unstamped papers on crates // Futureproofing
						continue
			if(bounty_ship_item_and_contents(AM, dry_run = FALSE))
				matched_bounty = TRUE
			if(!AM.anchored || istype(AM, /obj/mecha))
				export_item_and_contents(AM, export_categories , dry_run = FALSE, external_report = ex)

		for(var/obj/item/card/id/miner in shuttle_area.gem_payout)
			miner.mining_points += shuttle_area.gem_payout[miner]
			playsound(miner, 'sound/machines/ping.ogg', 15, TRUE)
			var/mob/card_holder = recursive_loc_check(miner, /mob)
			if(ismob(card_holder))
				to_chat(card_holder, "You have been credited with [shuttle_area.gem_payout[miner]] mining points from sold gems!")
			shuttle_area.gem_payout.Remove(miner)

	if(ex.exported_atoms)
		ex.exported_atoms += "." //ugh

	if(matched_bounty)
		msg += "Bounty items received. An update has been sent to all bounty consoles. "

	for(var/datum/export/E in ex.total_amount)
		var/export_text = E.total_printout(ex)
		if(!export_text)
			continue

		msg += export_text + "\n"
		D.adjust_money(ex.total_value[E])

	SSshuttle.centcom_message = msg
	investigate_log("Shuttle contents sold for [D.account_balance - presale_points] credits. Contents: [ex.exported_atoms ? ex.exported_atoms.Join(",") + "." : "none."] Message: [SSshuttle.centcom_message || "none."]", INVESTIGATE_CARGO)

/*
	Generates a box of mail depending on our exports and imports.
	Applied in the cargo shuttle sending/arriving, by building the crate if the round is ready to introduce mail based on the economy subsystem.
	Then, fills the mail crate with mail, by picking applicable crew who can receive mail at the time to sending.
*/
/obj/docking_port/mobile/supply/proc/create_mail()
	//Early return if there's no mail waiting to prevent taking up a slot. We also don't send mails on sundays or holidays.
	if(!SSeconomy.mail_waiting || SSeconomy.mail_blocked)
		return
	//spawn crate
	var/list/empty_turfs = list()
	for(var/place as anything in shuttle_areas)
		var/area/shuttle/shuttle_area = place
		for(var/turf/open/floor/shuttle_floor in shuttle_area)
			if(shuttle_floor.is_blocked_turf())
				continue
			empty_turfs += shuttle_floor

	new /obj/structure/closet/crate/mail/economy(pick(empty_turfs))
