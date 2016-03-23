local player_name = {}

local mysounds = { -- block name, sound
	{"months","mymonths_thunder"}
	}
for i in ipairs (mysounds) do
	local sname = mysounds[i][1]
	local sound = mysounds[i][2]

minetest.register_node("mysoundblocks:block_visable_"..sname, {
	description = "Sound Block",
	drawtype = "normal",
	tiles = {
		"mysoundblocks_block.png",
		},
	paramtype = "light",
	is_ground_content = false,
	groups = {oddly_breakable_by_hand = 1,not_in_creative_inventory=0},
	on_dig = function(pos, node, player)
		if minetest.get_player_privs(player:get_player_name()).mysoundblocks ~= true then
			minetest.chat_send_player(player:get_player_name(), "You need the mysoundblocks priv")
			return
		end
		if minetest.get_player_privs(player:get_player_name()).mysoundblocks == true then
			minetest.remove_node(pos)
		end

	end
})


minetest.register_node("mysoundblocks:block_hidden_"..sname, {
	description = "Hidden Sound Block",
	tiles = {
		"mysoundblocks_block.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	walkable = false,
	pointable = false,
	group = {not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
		}
	},
})

minetest.register_privilege("mysoundblocks", "Lets you place and dig soundblocks")

minetest.register_chatcommand("showsoundblock", {
	params = "",
	description = "Show the sound block",
	privs={mysoundblocks=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		local pos = player:getpos()
		local npos = minetest.find_node_near(pos, 5,"mysoundblocks:block_hidden_"..sname)

		local node = minetest.get_node(npos).name
		minetest.swap_node(npos,{name = "mysoundblocks:block_visable_"..sname})

	end
})

minetest.register_chatcommand("hidesoundblock", {
	params = "",
	description = "Hide the sound block",
	privs={mysoundblocks=true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return false, "Player not found"
		end
		local pos = player:getpos()
		local npos = minetest.find_node_near(pos, 5,"mysoundblocks:block_visable_"..sname)

		local node = minetest.get_node(npos).name
		minetest.swap_node(npos,{name = "mysoundblocks:block_hidden_"..sname})
	end
})
local play_sound = function()
					minetest.sound_play(sound, {
						max_hear_distance = 10,
						to_player = player,
						gain = 1.0,
					})
		end

minetest.register_abm({
	nodenames = {"mysoundblocks:block_hidden_"..sname},
	interval = 0.2,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local all_objects = minetest.get_objects_inside_radius(pos, 2)
		local _,obj
		for _,obj in ipairs(all_objects) do
			if obj:is_player() then
			local p = obj:get_player_name()
			local pf = function()
			local n = minetest.find_node_near(pos, 5,"mysoundblocks:block_hidden_"..sname)
					player_name[p] = false
					end
				if player_name[p] == nil then
					player_name[p] = true
					play_sound()
					minetest.chat_send_all("-nil")
				end
				if player_name[p] ~= true then
					return
				end
				if player_name[p] ~= 0 then
					player_name[p] = true
					play_sound()
					minetest.chat_send_all("-true")
				end
			end
		end
	end
})
end
