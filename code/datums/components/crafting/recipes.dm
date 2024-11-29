// TODO LIST:
/*
	/datum/asset/spritesheet/crafting/proc/add_tool_icons() needs to be fixed. Using it breaks all icons, but we still want it for icons for TOOL_BEHAVIOR.
*/
/datum/crafting_recipe
	/// In-game display name.
	var/name = ""
	// Unused.
	var/desc = ""
	/// Type paths of items consumed associated with how many are needed.
	var/list/reqs = list()
	/// Type paths of items explicitly not allowed as an ingredient.
	var/list/blacklist = list()
	/// Type path of item resulting from this craft.
	var/result
	/// String defines of items needed but not consumed.
	var/list/tool_behaviors
	/// Type paths of items needed but not consumed.
	var/list/tool_paths
	/// Time in seconds.
	var/time = 3 SECONDS
	/// Type paths of items that will be placed in the result.
	var/list/parts = list()
	/// Where it shows up in the crafting UI.
	var/category
	/// Set to FALSE if it needs to be learned fast.
	var/always_available = TRUE
	/// Should only one object exist on the same turf?
	var/one_per_turf = FALSE
	// Used to filter crafting recipes based on what you are crafting with
	// i.e CRAFTING_BENCH_HANDS is the default crafting menu
	// the general crafting bench only shows recipes with CRAFTING_BENCH_GENERAL, etc.
	// treat this is a flag, so recipes can be shared between (i.e bandages on GENERAL and ARMTAILOR)
	var/crafting_interface = CRAFTING_BENCH_HANDS

/datum/crafting_recipe/New()
	if(!(result in reqs))
		blacklist += result
	// These should be excluded from all crafting recipes:
	blacklist += list(
		// From surgical toolset implant:
		/obj/item/cautery/augment,
		/obj/item/circular_saw/augment,
		/obj/item/hemostat/augment,
		/obj/item/retractor/augment,
		/obj/item/scalpel/augment,
		/obj/item/surgicaldrill/augment,
		// From integrated toolset implant:
		/obj/item/crowbar/cyborg,
		/obj/item/multitool/cyborg,
		/obj/item/screwdriver/cyborg,
		/obj/item/weldingtool/largetank/cyborg,
		/obj/item/wirecutters/cyborg,
		/obj/item/wrench/cyborg,
	)

/**
  * Run custom pre-craft checks for this recipe
  *
  * user: the /mob that initiated the crafting
  * collected_requirements: A list of lists of /obj/item instances that satisfy reqs. Top level list is keyed by requirement path.
  */
/datum/crafting_recipe/proc/check_requirements(mob/user, list/collected_requirements)
	return TRUE

/datum/crafting_recipe/proc/on_craft_completion(mob/user, atom/result)
	return

/// Additional UI data to be passed to the crafting UI for this recipe
/datum/crafting_recipe/proc/crafting_ui_data()
	return list()

//Normal recipes

/*
/datum/crafting_recipe/skateboard
	name = "Skateboard"
	result = /obj/vehicle/ridden/scooter/skateboard
	time = 6 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/rods = 10)
	category = CAT_MISC

/datum/crafting_recipe/scooter
	name = "Scooter"
	result = /obj/vehicle/ridden/scooter
	time = 6.5 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/rods = 12)
	category = CAT_MISC
*/

/datum/crafting_recipe/wheelchair
	name = "Wheelchair"
	result = /obj/vehicle/ridden/wheelchair
	reqs = list(/obj/item/stack/sheet/metal = 4,
				/obj/item/stack/rods = 6)
	time = 10 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/mousetrap
	name = "Mouse Trap"
	result = /obj/item/assembly/mousetrap
	time = 1 SECONDS
	reqs = list(/obj/item/stack/sheet/cardboard = 1,
				/obj/item/stack/rods = 1)
	category = CAT_MISC

/datum/crafting_recipe/papersack
	name = "Paper Sack"
	result = /obj/item/storage/box/papersack
	time = 1 SECONDS
	reqs = list(/obj/item/paper = 5)
	category = CAT_MISC

/datum/crafting_recipe/garbage_bin
	name = "Garbage Bin"
	reqs = 	list(/obj/item/stack/sheet/metal = 3)
	result = /obj/structure/closet/crate/bin
	category = CAT_STRUCTURES

/datum/crafting_recipe/showercurtain
	name = "Shower Curtains"
	reqs = 	list(/obj/item/stack/sheet/cloth = 2, /obj/item/stack/sheet/plastic = 2, /obj/item/stack/rods = 1)
	result = /obj/structure/curtain
	category = CAT_STRUCTURES

/datum/crafting_recipe/mirror
	name = "Mirror"
	reqs = 	list(/obj/item/stack/rods = 1, /obj/item/stack/sheet/glass = 1, /obj/item/stack/sheet/mineral/silver = 1)
	result = /obj/item/wallframe/mirror
	category = CAT_STRUCTURES

/datum/crafting_recipe/cloth_curtain
	name = "Curtains"
	reqs = 	list(/obj/item/stack/sheet/cloth = 2, /obj/item/stack/rods = 1)
	result = /obj/structure/cloth_curtain
	category = CAT_STRUCTURES

/datum/crafting_recipe/firebrand
	name = "Firebrand"
	result = /obj/item/match/firebrand
	time = 10 SECONDS //Long construction time. Making fire is hard work.
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2)
	category = CAT_TOOLS

/datum/crafting_recipe/bonfire
	name = "Bonfire"
	time = 6 SECONDS
	reqs = list(/obj/item/grown/log = 5)
	result = /obj/structure/bonfire
	category = CAT_PRIMAL

/datum/crafting_recipe/woodbucket
	name = "Wooden Bucket"
	time = 3 SECONDS
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3)
	result = /obj/item/reagent_containers/glass/bucket/wooden
	category = CAT_TOOLS

/datum/crafting_recipe/cleanleather
	name = "Clean Leather"
	result = /obj/item/stack/sheet/wetleather
	reqs = list(/obj/item/stack/sheet/hairlesshide = 1, /datum/reagent/water = 20)
	time = 10 SECONDS //its pretty hard without the help of a washing machine.
	category = CAT_MISC

/datum/crafting_recipe/sillycup
	name = "Paper Cup"
	result = /obj/item/reagent_containers/food/drinks/sillycup
	time = 1 SECONDS
	reqs = list(/obj/item/paper = 2)
	category = CAT_MISC

/datum/crafting_recipe/smallcarton
	name = "Small Carton"
	result = /obj/item/reagent_containers/food/drinks/sillycup/smallcarton
	time = 1 SECONDS
	reqs = list(/obj/item/stack/sheet/cardboard = 1)
	category = CAT_MISC

/datum/crafting_recipe/fishingrod
	name = "Fishing Rod"
	result = /obj/item/fishingrod
	time = 5 SECONDS 
	reqs = list(/obj/item/stack/sheet/metal = 1,
		        /obj/item/stack/sheet/mineral/wood = 4,
		        /obj/item/stack/tape = 1)
	category = CAT_MISC

/datum/crafting_recipe/guillotine
	name = "Guillotine"
	result = /obj/structure/guillotine
	time = 15 SECONDS // Building a functioning guillotine takes time
	reqs = list(/obj/item/stack/sheet/metal = 15,
		        /obj/item/stack/sheet/mineral/wood = 20,
		        /obj/item/stack/cable_coil = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_STRUCTURES

/datum/crafting_recipe/forcefield
	name = "Basic Forcefield"
	result = /obj/machinery/turnstile/brig/halflife/forcefield/nodirectional
	time = 15 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 10,
		        /obj/item/stock_parts/micro_laser = 3,
				/obj/item/circuitmaterial = 2,
		        /obj/item/stack/cable_coil = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_STRUCTURES

/datum/crafting_recipe/cpforcefield
	name = "Civil Protection Forcefield"
	result = /obj/machinery/turnstile/brig/halflife/forcefield/civilprotection/nodirectional
	time = 15 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 10,
		        /obj/item/stock_parts/micro_laser = 3,
				/obj/item/circuitmaterial = 2,
		        /obj/item/stack/cable_coil = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_STRUCTURES

/datum/crafting_recipe/maintforcefield
	name = "Engineering/Infestation Control Forcefield"
	result = /obj/machinery/turnstile/brig/halflife/forcefield/maint/nodirectional
	time = 15 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 10,
		        /obj/item/stock_parts/micro_laser = 3,
				/obj/item/circuitmaterial = 2,
		        /obj/item/stack/cable_coil = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_STRUCTURES

/datum/crafting_recipe/heavycombinedoor
	name = "Heavy Combine Door Assembly"
	result = /obj/structure/door_assembly/door_assembly_highsecurity/combine 
	time = 15 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 15,
				/obj/item/circuitmaterial = 1,
		        /obj/item/stack/cable_coil = 5)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_STRUCTURES

/datum/crafting_recipe/combineturret
	name = "Combine Turret"
	result = /obj/machinery/porta_turret/combine/off
	time = 15 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 10,
		        /obj/item/stock_parts/scanning_module = 2,
				/obj/item/gun/ballistic/automatic/ar2,
				/obj/item/circuitmaterial = 2,
		        /obj/item/stack/cable_coil = 10)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH, TOOL_WELDER)
	category = CAT_STRUCTURES

/datum/crafting_recipe/woodenmug
	name = "Wooden Mug"
	result = /obj/item/reagent_containers/glass/woodmug
	reqs = list(/obj/item/stack/sheet/mineral/wood = 2)
	time = 2 SECONDS
	category = CAT_PRIMAL

/datum/crafting_recipe/tape
	name = "tape"
	reqs = list(/obj/item/stack/sheet/cloth = 1,
				/datum/reagent/consumable/caramel = 5)
	result = /obj/item/stack/tape
	time = 1
	category = CAT_MISC

/datum/crafting_recipe/receiver
	name = "Modular Receiver"
	result = /obj/item/weaponcrafting/receiver
	time = 15 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 2,
		        /obj/item/stack/sheet/plasteel = 1,
		        /obj/item/stack/cable_coil = 3)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	category = CAT_MISC
	crafting_interface = CRAFTING_BENCH_GENERAL

/datum/crafting_recipe/multifunctiontool
	name = "Multifunction Electrical Tool"
	result = /obj/item/card/emag/halflife/empty
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 2,
				/obj/item/circuitmaterial = 1,
		        /obj/item/machinepiece/multifunctiontool = 1,
		        /obj/item/stack/tape = 1)
	tool_behaviors = list(TOOL_SCREWDRIVER)
	category = CAT_MISC
	crafting_interface = CRAFTING_BENCH_ELECTRIC

/datum/crafting_recipe/medkit
	name = "medkit"
	reqs = list(/obj/item/stack/sheet/metal = 1,
				/datum/reagent/medicine/biogel = 20)
	result = /obj/item/reagent_containers/pill/patch/medkit
	time = 3 SECONDS
	category = CAT_MEDICAL
	crafting_interface = CRAFTING_BENCH_GENERAL

/datum/crafting_recipe/suture
	name = "Suture"
	result = /obj/item/stack/medical/suture
	reqs = list(/obj/item/stack/sheet/cloth = 1,
				/obj/item/stack/sheet/metal = 1,
				/datum/reagent/space_cleaner/sterilizine = 4)
	category = CAT_MEDICAL

/datum/crafting_recipe/makeshiftsuture
	name = "Makeshift Suture"
	result = /obj/item/stack/medical/suture/emergency/makeshift
	reqs = list(/obj/item/clothing/torncloth = 1,
				/obj/item/shard = 1,
				/datum/reagent/water = 4)
	category = CAT_MEDICAL

/datum/crafting_recipe/medicatedsuture
	name = "Medicated Suture"
	result = /obj/item/stack/medical/suture/medicated
	reqs = list(/obj/item/stack/sheet/plastic = 2,
				/obj/item/stack/sheet/metal = 1,
				/datum/reagent/space_cleaner/sterilizine = 6,
				/datum/reagent/medicine/morphine = 5)
	category = CAT_MEDICAL

/datum/crafting_recipe/mesh
	name = "Regenerative Mesh"
	result = /obj/item/stack/medical/mesh
	reqs = list(/obj/item/stack/sheet/glass = 1,
				/obj/item/stack/medical/gauze/improvised = 2,
				/datum/reagent/space_cleaner/sterilizine = 7,
				/datum/reagent/medicine/morphine = 3)
	category = CAT_MEDICAL

/datum/crafting_recipe/ointment
	name = "Ointment"
	result = /obj/item/stack/medical/ointment
	reqs = list(/datum/reagent/water = 10,
				/datum/reagent/ash = 10)
	tool_paths = list(/obj/item/weldingtool)
	category = CAT_MEDICAL

/datum/crafting_recipe/antisepticointment
	name = "Antiseptic Ointment"
	result = /obj/item/stack/medical/ointment/antiseptic
	reqs = list(/datum/reagent/water = 10,
				/datum/reagent/ash = 10,
				/datum/reagent/silver = 10)
	tool_paths = list(/obj/item/weldingtool)
	category = CAT_MEDICAL

/datum/crafting_recipe/advancedmesh
	name = "Advanced Regenerative Mesh"
	result = /obj/item/stack/medical/mesh/advanced
	reqs = list(/obj/item/stack/sheet/glass = 1,
				/obj/item/stack/medical/gauze/improvised = 2,
				/datum/reagent/space_cleaner/sterilizine = 10,
				/datum/reagent/medicine/silver_sulfadiazine = 10,
				/datum/reagent/medicine/morphine = 3)
	category = CAT_MEDICAL

/datum/crafting_recipe/gauze
	name = "Gauze"
	result = /obj/item/stack/medical/gauze
	reqs = list(/obj/item/stack/sheet/cloth = 4,
				/obj/item/stack/medical/suture = 1) //for reinforcement, so its not just...cloth.
	category = CAT_MEDICAL

/datum/crafting_recipe/leftprostheticarm
	name = "Left Prosthetic Arm"
	result = /obj/item/bodypart/l_arm/robot/surplus
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 10)
	tool_paths = list(/obj/item/weldingtool, /obj/item/wirecutters, /obj/item/screwdriver)
	category = CAT_MEDICAL
	crafting_interface = CRAFTING_BENCH_ELECTRIC

/datum/crafting_recipe/rightprostheticarm
	name = "Right Prosthetic Arm"
	result = /obj/item/bodypart/r_arm/robot/surplus
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 10)
	tool_paths = list(/obj/item/weldingtool, /obj/item/wirecutters, /obj/item/screwdriver)
	category = CAT_MEDICAL
	crafting_interface = CRAFTING_BENCH_ELECTRIC

/datum/crafting_recipe/leftprostheticleg
	name = "Left Prosthetic Leg"
	result = /obj/item/bodypart/l_leg/robot/surplus
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 10)
	tool_paths = list(/obj/item/weldingtool, /obj/item/wirecutters, /obj/item/screwdriver)
	category = CAT_MEDICAL
	crafting_interface = CRAFTING_BENCH_ELECTRIC

/datum/crafting_recipe/rightprostheticleg
	name = "Right Prosthetic Leg"
	result = /obj/item/bodypart/r_leg/robot/surplus
	time = 10 SECONDS
	reqs = list(/obj/item/stack/sheet/metal = 5,
				/obj/item/stack/cable_coil = 10,
				/obj/item/stack/rods = 10)
	tool_paths = list(/obj/item/weldingtool, /obj/item/wirecutters, /obj/item/screwdriver)
	category = CAT_MEDICAL
	crafting_interface = CRAFTING_BENCH_ELECTRIC

/datum/crafting_recipe/apprentice_bait
	name = "Apprentice Bait"
	reqs = list(
		/datum/reagent/water = 2,
		/datum/reagent/blood = 5,
		/datum/reagent/water/dirty/sewer = 2,
	)
	result = /obj/item/reagent_containers/food/snacks/bait/apprentice
	category = CAT_BAIT

/datum/crafting_recipe/journeyman_bait
	name = "Journeyman Bait"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/bait/apprentice = 1,
		/obj/item/reagent_containers/food/snacks/xenspore = 2
	)
	result = /obj/item/reagent_containers/food/snacks/bait/journeyman
	category = CAT_BAIT

/datum/crafting_recipe/master_bait
	name = "Master Bait"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/xenbranch = 2,
		/obj/item/reagent_containers/food/snacks/bait/journeyman = 1,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 1
	)
	result = /obj/item/reagent_containers/food/snacks/bait/master
	category = CAT_BAIT

/datum/crafting_recipe/wild_bait
	name = "Wild Bait"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/bait/worm = 1,
		/obj/item/stack/medical/gauze/improvised = 1
	)
	result = /obj/item/reagent_containers/food/snacks/bait/wild
	category = CAT_BAIT

/datum/crafting_recipe/viscerator
	name = "Viscerator"
	result = /obj/item/grenade/spawnergrenade/manhacks
	time = 5 SECONDS
	reqs = list(
		/obj/item/machinepiece/viscerator = 1,
		/obj/item/circuitmaterial = 1,
		/obj/item/stack/cable_coil = 5
	)
	category = CAT_MISC
	crafting_interface = CRAFTING_BENCH_ELECTRIC

/datum/crafting_recipe/cityscanner
	name = "City Scanner"
	result = /obj/effect/mob_spawn/cityscanner
	time = 5 SECONDS
	reqs = list(
		/obj/item/machinepiece/scanner = 1,
		/obj/item/circuitmaterial = 2,
		/obj/item/stack/cable_coil = 5
	)
	category = CAT_MISC
	crafting_interface = CRAFTING_BENCH_ELECTRIC

/datum/crafting_recipe/gunstock
	name = "Wooden Gun Stock"
	result = /obj/item/weaponcrafting/stock
	reqs = list(/obj/item/stack/sheet/mineral/wood = 3)
	time = 10 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/customkey
	name = "Custom Key"
	result = /obj/item/customblank
	reqs = list(/obj/item/stack/sheet/metal = 5)
	time = 10 SECONDS
	category = CAT_MISC
	crafting_interface = CRAFTING_BENCH_GENERAL

/datum/crafting_recipe/customlock
	name = "Custom Lock"
	result = /obj/item/customlock
	reqs = list(/obj/item/stack/sheet/metal = 5)
	time = 10 SECONDS
	category = CAT_MISC
	crafting_interface = CRAFTING_BENCH_GENERAL


/datum/crafting_recipe/metalpot
	name = "Metal Cooking Pot"
	result = /obj/item/reagent_containers/glass/pot
	reqs = list(/obj/item/stack/sheet/metal = 8)
	time = 12 SECONDS
	category = CAT_MISC
	crafting_interface = CRAFTING_BENCH_GENERAL

/datum/crafting_recipe/scrap_metal
	name = "Recombine Scrap Metal"
	result = /obj/item/stack/sheet/metal
	reqs = list(/obj/item/stack/sheet/scrap_metal = 2)
	time = 1 SECONDS
	tool_paths = list(/obj/item/weldingtool)
	category = CAT_MISC

/datum/crafting_recipe/scrap_wood
	name = "Recombine Scrap Wood"
	result = /obj/item/stack/sheet/mineral/wood
	reqs = list(/obj/item/stack/sheet/mineral/scrap_wood = 3)
	time = 2 SECONDS
	category = CAT_MISC

