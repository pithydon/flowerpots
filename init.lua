flowerpots = {plants = {}}

local creative = minetest.setting_getbool("creative_mode")

minetest.register_node("flowerpots:pot", {
	description = "Flower Pot",
	tiles = {{name = "default_dirt.png", backface_culling = true}, {name = "flowerpots_pot.png", backface_culling = true}},
	paramtype = "light",
	drawtype = "mesh",
	mesh = "flowerpots_pot.obj",
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, -0.1875, 0.1875},
			{-0.1875, -0.3125, 0.1875, 0.25, -0.125, 0.25},
			{-0.25, -0.3125, -0.1875, -0.1875, -0.125, 0.25},
			{-0.25, -0.3125, -0.25, 0.1875, -0.125, -0.1875},
			{0.1875, -0.3125, -0.25, 0.25, -0.125, 0.1875}
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, -0.125, 0.25}
	},
	groups = {dig_immediate = 2},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		if not minetest.is_protected(pos, clicker:get_player_name()) then
			for k,v in pairs(flowerpots.plants) do
				if itemstack:get_name() == k then
					minetest.swap_node(pos, {name = v})
					if not creative then
						itemstack:take_item()
						return itemstack
					else
						return
					end
				end
			end
		end
	end
})

minetest.register_craft({
	output = "flowerpots:pot",
	recipe = {
		{"default:clay_lump", "default:dirt", "default:clay_lump"},
		{"", "default:clay_lump", ""}
	}
})

function flowerpots.addplantlike(name, desc, plant, tile, box)
	if type(tile) == "string" then
		tile = {name = tile, backface_culling = false}
	end

	minetest.register_node(":flowerpots:pot_"..name, {
		description = desc.." in a pot.",
		tiles = {tile, {name = "default_dirt.png", backface_culling = true}, {name = "flowerpots_pot.png", backface_culling = true}},
		paramtype = "light",
		drawtype = "mesh",
		mesh = "flowerpots_pot_plantlike.obj",
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.1875, -0.5, -0.1875, 0.1875, -0.1875, 0.1875},
				{-0.1875, -0.3125, 0.1875, 0.25, -0.125, 0.25},
				{-0.25, -0.3125, -0.1875, -0.1875, -0.125, 0.25},
				{-0.25, -0.3125, -0.25, 0.1875, -0.125, -0.1875},
				{0.1875, -0.3125, -0.25, 0.25, -0.125, 0.1875}
			}
		},
		selection_box = {
			type = "fixed",
			fixed = box
		},
		groups = {dig_immediate = 2, not_in_creative_inventory = 1},
		on_punch = function(pos, node, puncher, pointed_thing)
			if not minetest.is_protected(pos, puncher:get_player_name()) then
				minetest.swap_node(pos, {name = "flowerpots:pot"})
				local inv = puncher:get_inventory()
				if creative then
					if not inv:contains_item("main", plant) then
						inv:add_item("main", plant)
					end
				else
					inv:add_item("main", plant)
				end
			end
		end
	})

	flowerpots.plants[plant] = "flowerpots:pot_"..name
end

function flowerpots.addplantblock(name, desc, plant, tile_top, tile_side)
	if type(tile_top) == "string" then
		tile_top = {name = tile_top, backface_culling = true}
	end

	if type(tile_side) == "string" then
		tile_side = {name = tile_side, backface_culling = true}
	end

	minetest.register_node(":flowerpots:pot_"..name, {
		description = desc.." in a pot.",
		tiles = {tile_top, tile_side, {name = "flowerpots_pot.png", backface_culling = true}},
		paramtype = "light",
		drawtype = "mesh",
		mesh = "flowerpots_pot_plantblock.obj",
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
				{-0.25, -0.3125, -0.25, 0.25, -0.125, 0.25}
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}
		},
		groups = {dig_immediate = 2, not_in_creative_inventory = 1},
		on_punch = function(pos, node, puncher, pointed_thing)
			if not minetest.is_protected(pos, puncher:get_player_name()) then
				minetest.swap_node(pos, {name = "flowerpots:pot"})
				local inv = puncher:get_inventory()
				if creative then
					if not inv:contains_item("main", plant) then
						inv:add_item("main", plant)
					end
				else
					inv:add_item("main", plant)
				end
			end
		end
	})

	flowerpots.plants[plant] = "flowerpots:pot_"..name
end

if minetest.get_modpath("treasurer") then
	treasurer.register_treasure("flowerpots:pot",0.006,5,{1,2},nil,"deco")
end

flowerpots.addplantlike("sapling", "Sapling", "default:sapling", "default_sapling.png", {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25})
flowerpots.addplantlike("junglesapling", "Jungle Sapling", "default:junglesapling", "default_junglesapling.png", {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25})
flowerpots.addplantlike("pine_sapling", "Pine Sapling", "default:pine_sapling", "default_pine_sapling.png", {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25})
flowerpots.addplantlike("acacia_sapling", "Acacia Tree Sapling", "default:acacia_sapling", "default_acacia_sapling.png", {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25})
flowerpots.addplantlike("aspen_sapling", "Aspen Tree Sapling", "default:aspen_sapling", "default_aspen_sapling.png", {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25})
flowerpots.addplantlike("dry_shrub", "Dry Shrub", "default:dry_shrub", "default_dry_shrub.png", {-0.25, -0.5, -0.25, 0.25, 0, 0.25})
flowerpots.addplantlike("wheat", "Wheat", "farming:wheat", "farming_wheat_8.png^flowerpots_trim3.png^[makealpha:255,0,255", {-0.25, -0.5, -0.25, 0.25, 0.1125, 0.25})
flowerpots.addplantlike("cotton", "Cotton", "farming:cotton", "farming_cotton_8.png", {-0.25, -0.5, -0.25, 0.25, 0.1125, 0.25})
flowerpots.addplantlike("rose", "Rose", "flowers:rose", "flowers_rose.png", {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25})
flowerpots.addplantlike("tulip", "Tulip", "flowers:tulip", "flowers_tulip.png", {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25})
flowerpots.addplantlike("dandelion_yellow", "Yellow Dandelion", "flowers:dandelion_yellow", "flowers_dandelion_yellow.png", {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25})
flowerpots.addplantlike("geranium", "Blue Geranium", "flowers:geranium", "flowers_geranium.png", {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25})
flowerpots.addplantlike("viola", "Viola", "flowers:viola", "flowers_viola.png", {-0.25, -0.5, -0.25, 0.25, 0.1125, 0.25})
flowerpots.addplantlike("dandelion_white", "White Dandelion", "flowers:dandelion_white", "flowers_dandelion_white.png", {-0.25, -0.5, -0.25, 0.25, 0.1125, 0.25})
flowerpots.addplantlike("mushroom_red", "Red Mushroom", "flowers:mushroom_red", "flowers_mushroom_red.png", {-0.25, -0.5, -0.25, 0.25, 0.3125, 0.25})
flowerpots.addplantlike("mushroom_brown", "Brown Mushroom", "flowers:mushroom_brown", "flowers_mushroom_brown.png", {-0.25, -0.5, -0.25, 0.25, 0.3125, 0.25})

flowerpots.addplantblock("cactus", "Cactus", "default:cactus", "default_cactus_top.png", "default_cactus_side.png")
