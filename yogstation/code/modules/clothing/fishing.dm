/obj/item/clothing/head/fishing
	name = "fishing cap"
	desc = "A old bucket hat, often worn by fishers. Wearing it might help you reel in a better catch."
	icon_state = "fishing_cap"
	item_state = "fishing_cap"
	worn_icon = 'yogstation/icons/mob/clothing/head/head.dmi'
	icon = 'yogstation/icons/obj/clothing/hats.dmi'

/obj/item/clothing/head/fishing/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/fishingbonus,5)

/obj/item/clothing/suit/fishing
	name = "fishing vest"
	desc = "As she banging my line, she wastin my time."
	icon_state = "fishing_vest"
	item_state = "fishing_vest"
	worn_icon = 'yogstation/icons/mob/clothing/suit/suit.dmi'
	icon = 'yogstation/icons/obj/clothing/suits.dmi'

/obj/item/clothing/suit/fishing/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/fishingbonus,10)

/obj/item/clothing/gloves/fishing
	name = "fishing gloves"
	desc = "An old pair of gloves seemingly designed for fishing. May help you reel in a better catch."
	icon_state = "fishing_gloves"
	item_state = "fishing_gloves"
	worn_icon = 'yogstation/icons/mob/clothing/hands/hands.dmi'
	icon = 'yogstation/icons/obj/clothing/gloves.dmi'

/obj/item/clothing/gloves/fishing/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/fishingbonus,5)

/obj/item/clothing/shoes/fishing
	name = "fishing sandals"
	desc = "We livin' the life, if we ain't going fishing then don't waste my time."
	icon_state = "fishing_sandals"
	item_state = "fishing_sandals"
	worn_icon = 'yogstation/icons/mob/clothing/feet/feet.dmi'
	icon = 'yogstation/icons/obj/clothing/shoes.dmi'

/obj/item/clothing/shoes/fishing/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/fishingbonus,5)
