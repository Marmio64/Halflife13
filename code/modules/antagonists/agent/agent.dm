/datum/antagonist/infiltrator
	name = "Combine Infiltration Agent"
	roundend_category = "infiltration agents"
	antagpanel_category = "Infiltration Agent"
	job_rank = ROLE_INFILTRATOR
	antag_hud_name = "traitor"
	antag_moodlet = /datum/mood_event/agent
	preview_outfit = /datum/outfit/agent_preview
	show_in_antagpanel = TRUE
	var/datum/martial_art/cqc/my_kungfu = new

/datum/antagonist/infiltrator/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/combineadvisory.ogg',45,0)
	to_chat(owner, "<B>Suddenly, your mind flashes as you realize your true mission...</B>")
	to_chat(owner, span_userdanger("You are a Combine Infiltration Agent!"))
	to_chat(owner, span_boldnotice("You are an undercover agent from another district in the city."))
	to_chat(owner, span_notice("You were sent to keep this district's influence in check, and take a few things that your administrator may find useful..."))
	to_chat(owner, span_notice("Note, if this district falls to the resistance, all districts will feel the consequences, including your own. Keep this one weak, but don't let it fall."))
	to_chat(owner, span_boldnotice("Most importantly, you cannot let your involvement with your home district be known! None must know you are an undercover agent."))
	to_chat(owner, span_notice("Lastly, you were trained in advanced hand to hand combat techniques, you can use them to fight effectively even without weapons, though these attacks don't permanently harm people."))
	owner.announce_objectives()

/datum/antagonist/infiltrator/on_gain()
	//Give agent Objective
	var/datum/objective/agent/agent_objective = new
	agent_objective.owner = owner
	objectives += agent_objective
	//Give Theft Objective
	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = owner
	steal_objective.find_target()
	objectives += steal_objective
	//Give a second theft Objective
	var/datum/objective/steal/steal_objective2 = new
	steal_objective2.owner = owner
	steal_objective2.find_target()
	objectives += steal_objective2

	owner.current.cmode_music = 'sound/music/combat/penultimatum.ogg'

	return ..()

/datum/objective/agent
	name = "influencecurb"
	explanation_text = "Keep this district's power in check, causing chaos without letting it fall entirely. Avoid killing people as well, to avoid suspicion."

/datum/outfit/agent_preview
	name = "agent (Preview only)"

	uniform = /obj/item/clothing/under/rank/civilian/lawyer/black
	suit = /obj/item/clothing/suit/armor/civilprotection
	mask = /obj/item/clothing/mask/gas/civilprotection
	gloves = /obj/item/clothing/gloves/fingerless

/datum/antagonist/infiltrator/apply_innate_effects(mob/living/mob_override)
	.  = ..()
	var/mob/living/current_mob = mob_override || owner.current
	my_kungfu.teach(current_mob, make_temporary = FALSE)

/datum/antagonist/infiltrator/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/current_mob = mob_override || owner.current
	if(my_kungfu)
		my_kungfu.remove(current_mob)
