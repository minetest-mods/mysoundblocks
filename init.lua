local block_sounds = {}
local player_name = {}

minetest.register_node("mysoundblocks:block", {
	description = "Sound Block",
	drawtype = "normal",
	tiles = {"mysoundblocks_block.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {oddly_breakable_by_hand = 1, not_in_creative_inventory = 0},

	on_place = function(itemstack, placer, pointed_thing)
	local pos = pointed_thing.above

		if minetest.get_player_privs(placer:get_player_name()).mysoundblocks ~= true then

			minetest.chat_send_player(placer:get_player_name(),
				"You need the mysoundblocks priv")
			return
		end

		if minetest.get_player_privs(placer:get_player_name()).mysoundblocks == true then
			minetest.set_node(pos,{name = "mysoundblocks:block"})
		end

	end,


	on_dig = function(pos, node, player)

		if minetest.get_player_privs(player:get_player_name()).mysoundblocks ~= true then

			minetest.chat_send_player(player:get_player_name(),
				"You need the mysoundblocks priv")
			return
		end

		if minetest.get_player_privs(player:get_player_name()).mysoundblocks == true then

			minetest.remove_node(pos)
		end

	end,

	on_rightclick = function(pos, node, player, itemstack, pointed_thing)

		local node = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		local aa = meta:get_string("a")
		local bb = tonumber(meta:get_string("b"))
				if bb == nil then bb = 5 end
		local cc = tonumber(meta:get_string("c"))
				if cc == nil then cc = 3 end
		local dd = meta:get_string("d")
		local ee = tonumber(meta:get_string("e"))
				if ee == nil then ee = 10 end
		local ff = tonumber(meta:get_string("e"))
				if ff == nil then ff = 1 end

		minetest.show_formspec(player:get_player_name(),"fs",
				"size[6,7;]"..
				"background[-0.5,-0.5;7,8;mysoundblocks_bg.png]"..
				"field[1,1;4.5,1;snd;Enter Sound Name;"..aa.."]"..
				"field[1,2;4.5,1;txt;Enter Chat Message;"..dd.."]"..
				"field[1,3;2,1;sndl;Length;"..bb.."]"..
				"field[3.5,3;2,1;sndhd;Radius;"..cc.."]"..
				"label[0.7,3.4;Player or All]"..
				"dropdown[0.7,3.8;2,1;pora;Player,All;]"..
				"field[3.5,4;2,1;snddis;Hear Distance;"..ee.."]"..
				"field[2.75,5;1,1;sndgn;Gain;"..ff.."]"..
				"button_exit[0.75,5.75;1.5,1;ents;Sound]"..
				"button_exit[2.25,5.75;1.5,1;entc;Chat]"..
				"button_exit[3.75,5.75;1.5,1;entb;Both]")

		minetest.register_on_player_receive_fields(function(player, formname, fields)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local thing1 = fields["snd"]
		local thing2 = fields["sndl"]
		local thing3 = fields["sndhd"]
		local thing4 = fields["txt"]
		local thing5 = ""
		local thing6 = fields["pora"]
		local thing7 = fields["snddis"]
		local thing8 = fields["sndgn"]

			if fields["ents"] or
				fields["entc"] or
				fields["entb"] or
				fields["snd"] or
				fields["txt"] then

				if fields["ents"] and
					fields["snd"] ~= "" then
					thing5 = "sound"
					meta:set_string("a",thing1)
					meta:set_string("b",thing2)
					meta:set_string("c",thing3)
					meta:set_string("d",thing4)
					meta:set_string("e",thing5)
					meta:set_string("f",thing6)
					meta:set_string("g",thing7)
					meta:set_string("h",thing8)
					minetest.swap_node(pos,{name = "mysoundblocks:block_hidden"})
					return true
				elseif fields["entc"] and
					fields["txt"] ~= "" then
					thing5 = "chat"
					meta:set_string("a",thing1)
					meta:set_string("b",thing2)
					meta:set_string("c",thing3)
					meta:set_string("d",thing4)
					meta:set_string("e",thing5)
					minetest.swap_node(pos,{name = "mysoundblocks:block_hidden"})
					return true
				elseif fields["entb"] and
					fields["txt"] ~= "" and
					fields["snd"] ~= "" then
					thing5 = "both"
					meta:set_string("a",thing1)
					meta:set_string("b",thing2)
					meta:set_string("c",thing3)
					meta:set_string("d",thing4)
					meta:set_string("e",thing5)
					meta:set_string("f",thing6)
					meta:set_string("g",thing7)
					meta:set_string("h",thing8)
					minetest.swap_node(pos,{name = "mysoundblocks:block_hidden"})
					return true
				end

			else
				return
			end
		end)


end

})

minetest.register_node("mysoundblocks:block_hidden", {
	tiles = {
		"mysoundblocks_hidden.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	walkable = false,
	pointable = false,
	group = {not_in_creative_inventory = 1},
})

minetest.register_privilege("mysoundblocks", "Lets you place and dig soundblocks")

minetest.register_chatcommand("showsb", {
	params = "",
	description = "Show the sound block",
	privs={mysoundblocks = true},

	func = function(name, param)

		local player = minetest.get_player_by_name(name)

		if not player then
			return false, "Player not found"
		end

		local pos = player:getpos()

		local a = minetest.find_nodes_in_area({x = pos.x - 5, y = pos.y - 5, z = pos.z - 5},
				{x = pos.x + 5, y = pos.y + 5, z = pos.z + 5}, {"mysoundblocks:block_hidden"})

			for _, row in pairs(a) do
				npos = row
				minetest.swap_node(npos,{name = "mysoundblocks:block"})
			end

	end
})

minetest.register_chatcommand("hidesb", {
	params = "",
	description = "Hide the sound block",
	privs = {mysoundblocks = true},

	func = function(name, param)

		local player = minetest.get_player_by_name(name)

		if not player then
			return false, "Player not found"
		end

		local pos = player:getpos()
			pos.y = pos.y + 1

		local a = minetest.find_nodes_in_area({x = pos.x - 5, y = pos.y - 5, z = pos.z - 5},
				{x = pos.x + 5, y = pos.y + 5, z = pos.z + 5}, {"mysoundblocks:block"})

			for _, row in pairs(a) do
				npos = row
				minetest.swap_node(npos,{name = "mysoundblocks:block_hidden"})
			end

	end
})

minetest.register_abm({
	nodenames = {"mysoundblocks:block_hidden"},
	interval = 0.2,
	chance = 1,
	catch_up = false,

	action = function(pos, node, active_object_count, active_object_count_wider)

		local meta = minetest.get_meta(pos)

		local block_sound = meta:get_string("a")
		local block_time = tonumber(meta:get_string("b"))
		local rad_dist = tonumber(meta:get_string("c"))
		local block_text = meta:get_string("d")
		local sound_chat = meta:get_string("e")
		local sound_pa = meta:get_string("f")
		local sound_dis = meta:get_string("g")
		local sound_gain = meta:get_string("h")

			if block_time == nil then
				block_time = 5
			end

			if rad_dist == nil then
				rad_dist = 3
			end

		local all_objects = minetest.get_objects_inside_radius(pos, rad_dist)
		local p

		for _,obj in ipairs(all_objects) do

			if obj:is_player() then

				p = obj:get_player_name()

				if not player_name[p] then

					player_name[p] = true

		local handler = minetest.sound_play(block_sound, {to_player = p, gain = sound_gain})
		local sound_to = p
				if sound_pa == "All" then
					sound_to = all
				end


					if sound_chat == "sound" then
						if block_sound then
							minetest.sound_stop(handler)
							minetest.sound_play(block_sound, {
								max_hear_distance = sound_dis,
								to_player = sound_to,
								gain = sound_gain,
							})
						else
							minetest.swap_node(pos,{name = "mysoundblocks:block"})
							return
						end

					elseif sound_chat == "chat" then
						if block_text then
							minetest.chat_send_player(p,block_text)
						else
							minetest.swap_node(pos,{name = "mysoundblocks:block"})
							return
						end

					elseif sound_chat == "both" then
						if block_sound and block_text then
							minetest.sound_stop(handler)
							minetest.sound_play(block_sound, {
								max_hear_distance = sound_dis,
								to_player = sound_to,
								gain = sound_gain,
								})
							minetest.chat_send_player(p,block_text)
						else
							minetest.swap_node(pos,{name = "mysoundblocks:block"})
							return
						end

					end

					minetest.after(block_time, function(p)
						player_name[p] = nil
					end, p)

				end
			end
		end
	end
})

