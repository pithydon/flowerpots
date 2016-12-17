flowerpots = {plants = {}}

local creative = minetest.setting_getbool("creative_mode")

minetest.register_node("flowerpots:pot", {
	description = "Flower Pot",
	tiles = {{name = "default_dirt.png", backface_culling = true}, {name = "flowerpots_pot.png", backface_culling = true}},
	paramtype = "light",
	paramtype2 = "facedir",
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
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, -0.3125, 0.1875},
			{-0.25, -0.3125, -0.25, 0.25, -0.125, 0.25}
		}
	},
	groups = {snappy = 3, cracky = 3, oddly_breakable_by_hand = 3},
	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local player_name = clicker:get_player_name()
		if not minetest.is_protected(pos, player_name) then
			for k,v in pairs(flowerpots.plants) do
				if itemstack:get_name() == k then
					minetest.log("action", player_name.." places "..k.." in flowerpots:pot at "..minetest.pos_to_string(pos))
					minetest.swap_node(pos, {name = v, param2 = node.param2})
					minetest.sound_play({name = "default_place_node", gain=1.0}, {pos = pos})
					if not creative then
						itemstack:take_item()
						return itemstack
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

if minetest.get_modpath("treasurer") then
	treasurer.register_treasure("flowerpots:pot",0.006,5,{1,2},nil,"deco")
end

function flowerpots.take_plant(plant)
	local take_plant = function(pos, node, puncher, pointed_thing)
		local player_name = puncher:get_player_name()
		if not minetest.is_protected(pos, player_name) then
			minetest.log("action", player_name.." takes "..plant.." from flowerpots:pot at "..minetest.pos_to_string(pos))
			minetest.swap_node(pos, {name = "flowerpots:pot", param2 = node.param2})
			minetest.sound_play({name = "default_grass_footstep", gain = 0.7}, {pos = pos})
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

	return take_plant
end

function flowerpots.add_plant(t, name, desc, plant, tiles, slbox)
	local full_tiles = {{name = "flowerpots_pot.png", backface_culling = true}, {name = "default_dirt.png", backface_culling = true}}

	if not slbox then
		if t == 5 then
			slbox = {
				{-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
				{-0.25, -0.3125, -0.25, 0.25, -0.125, 0.25}
			}
		elseif t == 6 then
			slbox = {
				{-0.1875, -0.5, -0.1875, 0.1875, -0.3125, 0.1875},
				{-0.25, -0.3125, -0.25, 0.25, -0.125, 0.25},
				{-0.5, -0.125, -0.5, 0.5, -0.0625, 0.5}
			}
		else
			slbox = {
				{-0.1875, -0.5, -0.1875, 0.1875, -0.3125, 0.1875},
				{-0.25, -0.3125, -0.25, 0.25, 0.5, 0.25}
			}
		end
	end

	local clbox = {
		{-0.1875, -0.5, -0.1875, 0.1875, -0.1875, 0.1875},
		{-0.1875, -0.3125, 0.1875, 0.25, -0.125, 0.25},
		{-0.25, -0.3125, -0.1875, -0.1875, -0.125, 0.25},
		{-0.25, -0.3125, -0.25, 0.1875, -0.125, -0.1875},
		{0.1875, -0.3125, -0.25, 0.25, -0.125, 0.1875}
	}

	local num = 2

	if t == 7 then
		clbox = {
			{-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
			{-0.25, -0.3125, -0.25, 0.25, -0.125, 0.25}
		}

		slbox = {
			{-0.1875, -0.5, -0.1875, 0.1875, 0.5, 0.1875},
			{-0.25, -0.3125, -0.25, 0.25, -0.125, 0.25}
		}

		full_tiles = {{name = "flowerpots_pot.png", backface_culling = true}}

		num = 1
	end

	local bfc = false

	if t == 6 or t == 7 then
		bfc = true
	end

	if type(tiles) == "string" then
		full_tiles[1 + num] = {name = tiles, backface_culling = bfc}
	elseif tiles.name then
		full_tiles[1 + num] = tiles
	else
		for i,v in ipairs(tiles) do
			if type(v) == "string" then
				tiles[i] = {name = v, backface_culling = bfc}
			end
		end
		for i,v in ipairs(tiles) do
			full_tiles[i + num] = v
		end
	end

	minetest.register_node(":flowerpots:pot_"..name, {
		description = desc.." in a pot.",
		tiles = full_tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		drawtype = "mesh",
		mesh = "flowerpots_pot_"..t..".obj",
		collision_box = {
			type = "fixed",
			fixed = clbox
		},
		selection_box = {
			type = "fixed",
			fixed = slbox
		},
		groups = {snappy = 3, cracky = 3, oddly_breakable_by_hand = 3, not_in_creative_inventory = 1},
		on_punch = flowerpots.take_plant(plant)
	})

	flowerpots.plants[plant] = "flowerpots:pot_"..name
end

function flowerpots.override_on_place(plant)
	local override_def = table.copy(minetest.registered_items[plant])
	minetest.override_item(plant, {
		on_place = function(itemstack, placer, pointed_thing)
			local pos = pointed_thing.under
			local node = minetest.get_node(pos)
			if node.name == "flowerpots:pot" then
				local player_name = placer:get_player_name()
				if not minetest.is_protected(pos, player_name) then
					for k,v in pairs(flowerpots.plants) do
						if itemstack:get_name() == k then
							minetest.log("action", player_name.." places "..k.." in flowerpots:pot at "..minetest.pos_to_string(pos))
							minetest.swap_node(pos, {name = v, param2 = node.param2})
							minetest.sound_play({name = "default_place_node", gain=1.0}, {pos = pos})
							if not creative then
								itemstack:take_item()
								return itemstack
							else
								return
							end
						end
					end
				end
			else
				override_def.on_place(itemstack, placer, pointed_thing)
			end
		end
	})
end

function flowerpots.add_plant_with_on_place(t, name, desc, plant, tiles, slbox)
	flowerpots.add_plant(t, name, desc, plant, tiles, slbox)
	flowerpots.override_on_place(plant)
end

flowerpots.add_plant(1, "sapling", "Sapling", "default:sapling", "default_sapling.png")
flowerpots.add_plant(1, "junglesapling", "Jungle Sapling", "default:junglesapling", "default_junglesapling.png")
flowerpots.add_plant(1, "pine_sapling", "Pine Sapling", "default:pine_sapling", "default_pine_sapling.png")
flowerpots.add_plant(1, "acacia_sapling", "Acacia Tree Sapling", "default:acacia_sapling", "default_acacia_sapling.png")
flowerpots.add_plant(1, "dry_shrub", "Dry Shrub", "default:dry_shrub", "default_dry_shrub.png",
		{{-0.1875, -0.5, -0.1875, 0.1875, -0.3125, 0.1875}, {-0.25, -0.3125, -0.25, 0.25, 0.125, 0.25}})
flowerpots.add_plant(7, "cactus", "Cactus", "default:cactus", {"default_cactus_top.png", "default_cactus_side.png"})
flowerpots.add_plant(1, "junglegrass", "Jungle Grass", "default:junglegrass", "default_junglegrass.png")
flowerpots.add_plant(5, "papyrus", "Papyrus", "default:papyrus", "default_papyrus.png")

if default.NAME == "tng" then
	flowerpots.add_plant(1, "birch_sapling", "Birch Tree Sapling", "default:birch_sapling", "default_birch_sapling.png")
	flowerpots.add_plant(1, "maple_sapling", "Maple Tree Sapling", "default:maple_sapling", "default_maple_sapling.png")
	flowerpots.add_plant(1, "red_maple_sapling", "Red Maple Tree Sapling", "default:red_maple_sapling", "default_red_maple_sapling.png")
	flowerpots.add_plant(1, "cherry_sapling", "Cherry Tree Sapling", "default:cherry_sapling", "default_cherry_sapling.png")
	flowerpots.add_plant_with_on_place(5, "grass", "Grass", "default:grass_5", "default_grass_3.png",
			{{-0.1875, -0.5, -0.1875, 0.1875, 0.125, 0.1875}, {-0.25, -0.3125, -0.25, 0.25, -0.125, 0.25}})
	flowerpots.add_plant_with_on_place(5, "dry_grass", "Dry Grass", "default:dry_grass_5", "default_dry_grass_3.png",
			{{-0.1875, -0.5, -0.1875, 0.1875, 0.25, 0.1875}, {-0.25, -0.3125, -0.25, 0.25, -0.125, 0.25}})
else
	flowerpots.add_plant(1, "aspen_sapling", "Aspen Tree Sapling", "default:aspen_sapling", "default_aspen_sapling.png")
	flowerpots.add_plant_with_on_place(5, "grass", "Grass", "default:grass_1", "default_grass_3.png",
			{{-0.1875, -0.5, -0.1875, 0.1875, 0.125, 0.1875}, {-0.25, -0.3125, -0.25, 0.25, -0.125, 0.25}})
	flowerpots.add_plant_with_on_place(5, "dry_grass", "Dry Grass", "default:dry_grass_1", "default_dry_grass_3.png",
			{{-0.1875, -0.5, -0.1875, 0.1875, 0.25, 0.1875}, {-0.25, -0.3125, -0.25, 0.25, -0.125, 0.25}})
end

if minetest.get_modpath("farming") then
	if default.NAME == "tng" then
		flowerpots.add_plant(1, "garden", "Garden", "farming:garden", "farming_garden.png")
		flowerpots.add_plant_with_on_place(5, "wheat", "Wheat", "farming:wheat_seed", "farming_wheat_8.png")
		flowerpots.add_plant_with_on_place(1, "cotton", "Cotton", "farming:cotton_seed", "farming_cotton_8.png")
		flowerpots.add_plant_with_on_place(1, "potato", "Potato", "farming:potato", "farming_potato_3.png")
		flowerpots.add_plant_with_on_place(1, "strawberry", "Strawberries", "farming:strawberry", "farming_strawberry_7.png")
		flowerpots.add_plant_with_on_place(1, "lettuce", "Lettuce", "farming:lettuce", "farming_lettuce_7.png")
	else
		flowerpots.add_plant_with_on_place(5, "wheat", "Wheat", "farming:seed_wheat", "farming_wheat_8.png")
		flowerpots.add_plant_with_on_place(1, "cotton", "Cotton", "farming:seed_cotton", "farming_cotton_8.png")
	end
end

if minetest.get_modpath("flowers") then
	flowerpots.add_plant(1, "rose", "Rose", "flowers:rose", "flowers_rose.png")
	flowerpots.add_plant(1, "tulip", "Tulip", "flowers:tulip", "flowers_tulip.png")
	flowerpots.add_plant(1, "dandelion_yellow", "Yellow Dandelion", "flowers:dandelion_yellow", "flowers_dandelion_yellow.png")
	flowerpots.add_plant(1, "geranium", "Blue Geranium", "flowers:geranium", "flowers_geranium.png")
	flowerpots.add_plant(1, "viola", "Viola", "flowers:viola", "flowers_viola.png",
			{{-0.1875, -0.5, -0.1875, 0.1875, -0.3125, 0.1875}, {-0.25, -0.3125, -0.25, 0.25, 0.1125, 0.25}})
	flowerpots.add_plant(1, "dandelion_white", "White Dandelion", "flowers:dandelion_white", "flowers_dandelion_white.png",
			{{-0.1875, -0.5, -0.1875, 0.1875, -0.3125, 0.1875}, {-0.25, -0.3125, -0.25, 0.25, 0.1125, 0.25}})
	flowerpots.add_plant(1, "mushroom_red", "Red Mushroom", "flowers:mushroom_red", "flowers_mushroom_red.png",
			{{-0.1875, -0.5, -0.1875, 0.1875, -0.3125, 0.1875}, {-0.25, -0.3125, -0.25, 0.25, 0.3125, 0.25}})
	flowerpots.add_plant(1, "mushroom_brown", "Brown Mushroom", "flowers:mushroom_brown", "flowers_mushroom_brown.png",
			{{-0.1875, -0.5, -0.1875, 0.1875, -0.3125, 0.1875}, {-0.25, -0.3125, -0.25, 0.25, 0.3125, 0.25}})
	flowerpots.add_plant_with_on_place(6, "waterlily", "Waterlily", "flowers:waterlily", {"flowers_waterlily.png", "flowers_waterlily.png^[transformFY"})
end
