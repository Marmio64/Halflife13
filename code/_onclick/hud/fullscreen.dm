
/mob/proc/overlay_fullscreen(category, type, severity)
	var/atom/movable/screen/fullscreen/screen = screens[category]
	if (!screen || screen.type != type)
		// needs to be recreated
		clear_fullscreen(category, FALSE)
		screens[category] = screen = new type()
	else if ((!severity || severity == screen.severity) && (!client || screen.screen_loc != "CENTER-7,CENTER-7" || screen.view == client.view))
		// doesn't need to be updated
		return screen

	screen.icon_state = "[initial(screen.icon_state)][severity]"
	screen.severity = severity
	if (client && screen.should_show_to(src))
		screen.update_for_view(client.view)
		client.screen += screen
	
	if(screen.needs_offsetting)
		SET_PLANE_EXPLICIT(screen, PLANE_TO_TRUE(screen.plane), src)

	return screen

/mob/proc/clear_fullscreen(category, animated = 1 SECONDS)
	var/atom/movable/screen/fullscreen/screen = screens[category]
	if(!screen)
		return

	screens -= category

	if(animated)
		animate(screen, alpha = 0, time = animated)
		addtimer(CALLBACK(src, PROC_REF(clear_fullscreen_after_animate), screen), animated, TIMER_CLIENT_TIME)
	else
		if(client)
			client.screen -= screen
		qdel(screen)

/mob/proc/clear_fullscreen_after_animate(atom/movable/screen/fullscreen/screen)
	if(client)
		client.screen -= screen
	qdel(screen)

/mob/proc/clear_fullscreens()
	for(var/category in screens)
		clear_fullscreen(category)

/mob/proc/hide_fullscreens()
	if(client)
		for(var/category in screens)
			client.screen -= screens[category]

/mob/proc/reload_fullscreen()
	if(client)
		var/atom/movable/screen/fullscreen/screen
		for(var/category in screens)
			screen = screens[category]
			if(screen.should_show_to(src))
				screen.update_for_view(client.view)
				client.screen |= screen
			else
				client.screen -= screen

/mob/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents)
	. = ..()
	if(!same_z_layer)
		relayer_fullscreens()

/mob/proc/relayer_fullscreens()
	var/turf/our_lad = get_turf(src)
	var/offset = GET_TURF_PLANE_OFFSET(our_lad)
	for(var/category in screens)
		var/atom/movable/screen/fullscreen/screen = screens[category]
		if(screen.needs_offsetting)
			screen.plane = GET_NEW_PLANE(initial(screen.plane), offset)

/atom/movable/screen/fullscreen
	icon = 'icons/mob/screen_full.dmi'
	icon_state = "default"
	screen_loc = "CENTER-7,CENTER-7"
	layer = FULLSCREEN_LAYER
	plane = FULLSCREEN_PLANE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/view = 7
	var/severity = 0
	var/show_when_dead = FALSE
	var/needs_offsetting = TRUE

/atom/movable/screen/fullscreen/proc/update_for_view(client_view)
	if (screen_loc == "CENTER-7,CENTER-7" && view != client_view)
		var/list/actualview = getviewsize(client_view)
		view = client_view
		transform = matrix(actualview[1]/FULLSCREEN_OVERLAY_RESOLUTION_X, 0, 0, 0, actualview[2]/FULLSCREEN_OVERLAY_RESOLUTION_Y, 0)

/atom/movable/screen/fullscreen/proc/should_show_to(mob/mymob)
	if(!show_when_dead && mymob.stat == DEAD)
		return FALSE
	return TRUE

/atom/movable/screen/fullscreen/Destroy()
	severity = 0
	. = ..()

/atom/movable/screen/fullscreen/brute
	icon_state = "brutedamageoverlay"
	layer = UI_DAMAGE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/oxy
	icon_state = "oxydamageoverlay"
	layer = UI_DAMAGE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/crit
	icon_state = "passage"
	layer = CRIT_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/crit/vision
	icon_state = "oxydamageoverlay"
	layer = BLIND_LAYER

/atom/movable/screen/fullscreen/blind
	icon_state = "blindimageoverlay"
	layer = BLIND_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/black
	icon_state = "blackimageoverlay"
	layer = BLIND_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/curse
	icon_state = "curse"
	layer = CURSE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/hive_mc
	icon_state = "hive_mc"
	layer = CURSE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/hive_eyes
	icon_state = "hive_eyes"
	layer = CURSE_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/grain
	icon_state = "grain"
	alpha = 5
	layer = GRAIN_LAYER
	plane = FULLSCREEN_PLANE

/atom/movable/screen/fullscreen/impaired
	icon_state = "impairedoverlay"

/atom/movable/screen/fullscreen/flash
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"

/atom/movable/screen/fullscreen/flash/static
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "noise"

/atom/movable/screen/fullscreen/laser
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "laser"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	blend_mode = BLEND_ADD
	color = "#00ff00"
	alpha = 127

/atom/movable/screen/fullscreen/high
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "druggy"

/atom/movable/screen/fullscreen/color_vision
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"
	alpha = 80

/atom/movable/screen/fullscreen/color_vision/green
	color = "#00ff00"

/atom/movable/screen/fullscreen/color_vision/red
	color = "#ff0000"

/atom/movable/screen/fullscreen/color_vision/blue
	color = "#0000ff"

/atom/movable/screen/fullscreen/cinematic_backdrop
	icon = 'icons/mob/screen_gen.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"
	plane = SPLASHSCREEN_PLANE
	layer = CINEMATIC_LAYER
	color = "#000000"
	show_when_dead = TRUE

/atom/movable/screen/fullscreen/cinematic_backdrop/Initialize(mapload)
	. = ..()
	layer = CINEMATIC_LAYER

/atom/movable/screen/fullscreen/lighting_backdrop
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "flash"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	plane = LIGHTING_PLANE
	layer = LIGHTING_ABOVE_ALL
	blend_mode = BLEND_OVERLAY
	show_when_dead = TRUE
	needs_offsetting = FALSE

//Provides darkness to the back of the lighting plane
/atom/movable/screen/fullscreen/lighting_backdrop/lit
	invisibility = INVISIBILITY_LIGHTING
	layer = BACKGROUND_LAYER+21
	color = "#000"

//Provides whiteness in case you don't see lights so everything is still visible
/atom/movable/screen/fullscreen/lighting_backdrop/unlit
	layer = BACKGROUND_LAYER+20
	show_when_dead = TRUE

/atom/movable/screen/fullscreen/see_through_darkness
	icon_state = "nightvision"
	plane = LIGHTING_PLANE
	layer = LIGHTING_ABOVE_ALL
	blend_mode = BLEND_ADD
	show_when_dead = TRUE

/atom/movable/screen/fullscreen/red_eye
	icon_state = "red_eye"
	plane = FULLSCREEN_PLANE
	layer = CURSE_LAYER

//Triggered by übercharge activation
/atom/movable/screen/fullscreen/uber
	icon_state = "uberoverlay"
	plane = FULLSCREEN_PLANE
	layer = CURSE_LAYER

/atom/movable/screen/fullscreen/blue_eye
	icon_state = "blue_eye"
	plane = FULLSCREEN_PLANE
	layer = CURSE_LAYER
