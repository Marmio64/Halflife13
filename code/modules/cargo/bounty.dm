GLOBAL_LIST_EMPTY(bounties_list)

/datum/bounty
	var/name
	var/description
	var/reward = 1000 // In credits.
	var/claimed = FALSE
	var/high_priority = FALSE

//SYNDICATE BOUNTY
/datum/bounty/syndicate


// Displayed on bounty UI screen.
/datum/bounty/proc/completion_string()
	return ""

// Displayed on bounty UI screen.
/datum/bounty/proc/reward_string()
	return "[reward] Credits"

/datum/bounty/proc/can_claim()
	return !claimed

// Called when the claim button is clicked. Override to provide fancy rewards.
/datum/bounty/proc/claim(mob/user)
	if(can_claim())
		var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
		if(D)
			D.adjust_money(reward * SSeconomy.bounty_modifier)
			D.bounties_claimed += 1
			if(D.bounties_claimed == 10)
				SSachievements.unlock_achievement(/datum/achievement/cargo/bounties, user.client)
		claimed = TRUE

// If an item sent in the cargo shuttle can satisfy the bounty.
/datum/bounty/proc/applies_to(obj/O)
	return FALSE

// Called when an object is shipped on the cargo shuttle.
/datum/bounty/proc/ship(obj/O)
	return

// When randomly generating the bounty list, duplicate bounties must be avoided.
// This proc is used to determine if two bounties are duplicates, or incompatible in general.
/datum/bounty/proc/compatible_with(other_bounty)
	return TRUE

/datum/bounty/proc/mark_high_priority(scale_reward = 2)
	if(high_priority)
		return
	high_priority = TRUE
	reward = round(reward * scale_reward)

// This proc is called when the shuttle docks at CentCom.
// It handles items shipped for bounties.
/proc/bounty_ship_item_and_contents(atom/movable/AM, dry_run=FALSE)
	if(!GLOB.bounties_list.len)
		setup_bounties()

	var/list/matched_one = FALSE
	for(var/thing in reverse_range(AM.get_all_contents()))
		var/matched_this = FALSE
		for(var/datum/bounty/B as anything in GLOB.bounties_list)
			if(B.applies_to(thing))
				matched_one = TRUE
				matched_this = TRUE
				if(!dry_run)
					B.ship(thing)
		if(!dry_run && matched_this)
			qdel(thing)
	return matched_one

// Returns FALSE if the bounty is incompatible with the current bounties.
/proc/try_add_bounty(datum/bounty/new_bounty)
	if(!new_bounty || !new_bounty.name || !new_bounty.description)
		return FALSE
	for(var/i in GLOB.bounties_list)
		var/datum/bounty/B = i
		if(!B.compatible_with(new_bounty) || !new_bounty.compatible_with(B))
			return FALSE
	GLOB.bounties_list += new_bounty
	return TRUE

// Returns a new bounty of random type, but does not add it to GLOB.bounties_list.
/proc/random_bounty()
	switch(rand(1, 6))
		if(1)
			var/subtype = pick(subtypesof(/datum/bounty/item/assistant))
			return new subtype
		if(2)
			var/subtype = pick(subtypesof(/datum/bounty/item/chef))
			return new subtype
		if(3)
			var/subtype = pick(subtypesof(/datum/bounty/item/security))
			return new subtype
		if(4)
			var/subtype = pick(subtypesof(/datum/bounty/item/science))
			return new subtype
		if(5)
			var/subtype = pick(subtypesof(/datum/bounty/item/medical))
			return new subtype
		if(6)
			var/subtype = pick(subtypesof(/datum/bounty/item/botany))
			return new subtype

// Called lazily at startup to populate GLOB.bounties_list with random bounties.
/proc/setup_bounties()

	var/pick // instead of creating it a bunch let's go ahead and toss it here, we know we're going to use it for dynamics and subtypes!

	/********************************Subtype Gens********************************/
	var/list/easy_add_list_subtypes = list(/datum/bounty/item/assistant = 2,
											/datum/bounty/item/chef = 2,
											/datum/bounty/item/security = 1,
											/datum/bounty/item/medical = 1,
											/datum/bounty/item/science = 1,
											/datum/bounty/item/botany = 2)

	for(var/the_type in easy_add_list_subtypes)
		for(var/i in 1 to easy_add_list_subtypes[the_type])
			pick = pick(subtypesof(the_type))
			try_add_bounty(new pick)

	/********************************Strict Type Gens********************************/

	/*
	var/list/easy_add_list_strict_types = list(/datum/bounty/reagent/simple_drink = 2,
											/datum/bounty/reagent/complex_drink = 1,
											/datum/bounty/reagent/chemical_simple = 2,
											/datum/bounty/reagent/chemical_complex = 1)

	for(var/the_strict_type in easy_add_list_strict_types)
		for(var/i in 1 to easy_add_list_strict_types[the_strict_type])
			try_add_bounty(new the_strict_type)
	*/

	/********************************Cutoff for Non-Low Priority Bounties********************************/
	var/datum/bounty/B = pick(GLOB.bounties_list)
	B.mark_high_priority()

	/********************************Progression Gens********************************/
	var/list/progression_type_list = typesof(/datum/bounty/item/progression)

	for(var/progression_bounty in progression_type_list)
		try_add_bounty(new progression_bounty)

	/********************************Low Priority Gens********************************/
	var/list/low_priority_strict_type_list = list(/datum/bounty/more_bounties)

	for(var/low_priority_bounty in low_priority_strict_type_list)
		try_add_bounty(new low_priority_bounty)

/proc/completed_bounty_count()
	var/count = 0
	for(var/i in GLOB.bounties_list)
		var/datum/bounty/B = i
		if(B.claimed)
			++count
	return count

