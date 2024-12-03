/obj/structure/halflife/storage
	name = "generic halflife storage"
	desc = "You place stuff on/in/or around it or it pretends to at least, pretty generic right."
	icon = 'icons/obj/halflife/32x64_tall_furniture.dmi'
	armor = list(MELEE = 30, BULLET = 40, LASER = 10, ENERGY = 10, BOMB = 25, BIO = 100,  FIRE = 80, ACID = 100)
	density = TRUE
	anchored = TRUE
	max_integrity = 225
	var/materialtype = /obj/item/stack/sheet/scrap_metal //What it drops when being destroyed

/obj/structure/halflife/storage/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new materialtype(loc, 2)
	qdel(src)

/obj/structure/halflife/storage/attackby(obj/item/W, mob/living/user, params)
	if(user.combat_mode)
		return ..()
	if(user.transferItemToLoc(W, drop_location()))
		return TRUE

/obj/structure/halflife/storage/store
	name = "store shelf"
	desc = "A large shelf for stores to use."
	icon_state = "store_shelf"
	materialtype = /obj/item/stack/sheet/mineral/scrap_wood

/obj/structure/halflife/storage/store/metal
	icon_state = "store_shelf_metal"
	materialtype = /obj/item/stack/sheet/scrap_metal

/obj/structure/halflife/storage/bookshelf
	name = "bookshelf"
	desc = "Holder of knowledge, master of all."
	icon_state = "bookshelf"
	materialtype = /obj/item/stack/sheet/mineral/scrap_wood

/obj/structure/halflife/storage/shelf
	name = "metal shelf"
	desc = "Used for storing just about anything you could think of, this one is in good condition."
	icon_state = "metal_shelf"
	opacity = FALSE
	materialtype = /obj/item/stack/sheet/scrap_metal

/obj/structure/halflife/storage/shelf/wood
	name = "wood shelf"
	desc = "Used for storing just about anything you could think of."
	icon_state = "wood_shelf"
	materialtype = /obj/item/stack/sheet/mineral/scrap_wood

/obj/structure/halflife/storage/shelf/wood/alt
	icon_state = "wood_shelf-alt"

/obj/structure/halflife/storage/large
	name = "generic large halflife storage"
	bound_width = 64
	icon = 'icons/obj/halflife/64x64_large_furniture.dmi'
	max_integrity = 300

/obj/structure/halflife/storage/large/Initialize()
	switch(dir)
		if(SOUTH, NORTH)
			bound_width = 64
			bound_height = 32
			bound_x = 0
		if(EAST, WEST)
			bound_width = 32
			bound_height = 64
			bound_x = 0
	. = ..()

/obj/structure/halflife/storage/large/shelf
	name = "metal shelf"
	desc = "An extra large, heavy-duty shelf, used for storing just about anything you could think of, this one is in good condition."
	icon_state = "metal_shelf"
	opacity = FALSE
	materialtype = /obj/item/stack/sheet/scrap_metal

/obj/structure/halflife/storage/large/shelf/wood
	name = "wood shelf"
	desc = "An extra large, wood shelf, used for storing just about anything you could think of while upkeeping your rustic tones."
	icon_state = "wood_shelf"
	materialtype = /obj/item/stack/sheet/mineral/scrap_wood

/obj/structure/halflife/storage/large/shelf/wood/alt
	icon_state = "wood_shelf-alt"

/obj/structure/halflife/storage/large/shelf/wood/drawers
	name = "wood shelf"
	desc = "A large wooden shelf set. There are drawers below for additional storage."
	icon_state = "wood_shelf_big"
	materialtype = /obj/item/stack/sheet/mineral/scrap_wood

/obj/structure/halflife/storage/large/clothing
	name = "clothing rack"
	desc = "And they say fashion is dead."
	icon_state = "clothing_rack"
	materialtype = /obj/item/stack/sheet/mineral/scrap_wood
	max_integrity = 250

/obj/structure/halflife/storage/large/medical
	name = "metal shelf"
	desc = "A wheeled shelfing unit. It has wheels for easy mass transport of items- Too bad the wheels are all worn out considerably."
	icon_state = "medshelves"
	materialtype = /obj/item/stack/sheet/scrap_metal

/obj/structure/halflife/storage/large/shop
	name = "metal shelf"
	desc = "Layered metal shelfs, exceptionally tall and wide, prime for loose item storage."
	icon_state = "shelf_shop"
	materialtype = /obj/item/stack/sheet/scrap_metal

/obj/structure/halflife/storage/large/showcase
	name = "showcase shelf"
	desc = "A pyramid of shelving units, ready to display wares to the eager world."
	icon_state = "showcase"
	materialtype = /obj/item/stack/sheet/mineral/scrap_wood
