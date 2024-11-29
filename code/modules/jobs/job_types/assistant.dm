/*
Assistant
*/
/datum/job/citizen
	title = "Citizen"
	description = "Find your own path to survival in this cruel world, whether it be escaping the district, scavening, finding a job, or sucking up to civil protection."
	orbit_icon = "toolbox"
	faction = "Station"
	total_positions = 99
	spawn_positions = 99
	supervisors = "absolutely everyone"
	added_access = list()			//See /datum/job/assistant/get_access()
	base_access = list()	//See /datum/job/assistant/get_access()
	outfit = /datum/outfit/job/citizen
	antag_rep = 7
	paycheck = PAYCHECK_ASSISTANT // Get a job. Job reassignment changes your paycheck now. Get over it.
	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT
	minimal_character_age = 18 //Would make it even younger if I could because this role turns men into little brat boys and likewise for the other genders

	department_for_prefs = /datum/job_department/assistant

/datum/job/citizen/get_access()
	. = ..()
	if(CONFIG_GET(flag/assistants_have_maint_access) || !CONFIG_GET(flag/jobs_have_minimal_access)) //Config has assistant maint access set
		. |= list(ACCESS_MAINT_TUNNELS)

/datum/outfit/job/citizen
	name = "Citizen"
	jobtype = /datum/job/citizen

/datum/outfit/job/citizen/pre_equip(mob/living/carbon/human/H)
	uniform = /obj/item/clothing/under/citizen


/datum/outfit/job/citizen/consistent
	name = "Assistant - Consistent"

/datum/outfit/job/citizen/consistent/pre_equip(mob/living/carbon/human/target)
	..()
	uniform = /obj/item/clothing/under/color/grey

/datum/outfit/job/citizen/consistent/post_equip(mob/living/carbon/human/H, visualsOnly)
	..()

	// This outfit is used by the assets SS, which is ran before the atoms SS
	if (SSatoms.initialized == INITIALIZATION_INSSATOMS)
		H.w_uniform?.update_greyscale()
		H.update_inv_w_uniform()
