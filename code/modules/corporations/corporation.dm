GLOBAL_LIST_EMPTY(corporations)
/**
  * # Corporations
  *
  * Companies with employees
  */
/datum/corporation
	/// Name of the corporation 
	var/name
	/// List of all the employees' minds
	var/list/datum/mind/employees = list()
	/// How much are employees paid per round of paydays as a modifier of their nanotrasen wage (nanotrasen is exempt, since that's integrated with budgets already)
	var/paymodifier = 1
	/// Whether we should instantiate it or not (only used on subtypes that are parents, like [/datum/corporation/traitor])
	var/instantiate = TRUE

/datum/corporation/New()
	if(!instantiate)
		return
	GLOB.corporations += src
	return ..()

/datum/corporation/nanotrasen
	name = "Nanotrasen"
	/// Nanotrasen's paying is handled by payday itself
	paymodifier = 0

/datum/corporation/traitor
	instantiate = FALSE

/datum/corporation/traitor/donkco
	name = "Donk Co."
	paymodifier = 2
	instantiate = TRUE

/datum/corporation/traitor/waffleco
	name = "Waffle co."
	paymodifier = 1.5
	instantiate = TRUE

/datum/corporation/traitor/cybersun
	name = "Cybersun Industries"
	paymodifier = 1.5
	instantiate = TRUE

/datum/corporation/traitor/vahlen
	name = "Vahlen Pharmaceuticals"
	paymodifier = 2
	instantiate = TRUE

/datum/corporation/traitor/lambda
	name = "Lambda Cell"
	paymodifier = 1.5
	instantiate = TRUE

// Still syndicate, but doesn't send traitors so untill my syndicate rework they'll not be a subtype
/datum/corporation/bolsynpowell
	name = "Bosyn-Powell Front"
	paymodifier = 1.5

// Shouldn't really pay anyone, 
/datum/corporation/self
	name = "Sentience-Enabled Life Forms"
	paymodifier = 1

// Syndicate, but not a standard traitor- too high-risk to make a normal agent
/datum/corporation/gorlex
	name = "Gorlex Marauders"
	paymodifier = 1.5
