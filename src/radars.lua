function chart_entity_position(entity, force, radius)
	local x = entity.position.x
	local y = entity.position.y
	local area = {{x-radius, y-radius}, {x+radius, y+radius}}
	-- Chart the entity's current surface instead of hardcoding 'nauvis'
	force.chart(entity.surface, area)
end

function get_all_radars()
	local radars = {}
	-- Iterate through all surfaces instead of just nauvis
	for _, surface in pairs(game.surfaces) do
			-- Find radars on each surface
			local surface_radars = surface.find_entities_filtered{type="radar"}
			for _, radar in pairs(surface_radars) do
					table.insert(radars, radar)
			end
	end
	return radars
end

function get_all_connected_players_forces()
	local forces = {}
	for _, force in pairs(game.forces) do
			-- Only include forces that have connected players and aren't the default 'player' force
			if (force.name ~= 'player') and (#force.connected_players > 0) then
					table.insert(forces, force)
			end
	end
	return forces
end

function chart_radars_and_players()
	local online_forces = get_all_connected_players_forces()
	local radars = get_all_radars()

	for _, force in pairs(online_forces) do
			-- Chart players from other forces
			for _, player in pairs(game.connected_players) do
					if player.force.name ~= force.name then
							chart_entity_position(player, force, 70)
					end
			end

			-- Chart all radars
			for _, radar in pairs(radars) do
					chart_entity_position(radar, force, 112)
			end
	end
end

-- Optional: Add error handling
function safe_chart_radars_and_players()
	local status, err = pcall(chart_radars_and_players)
	if not status then
			log("Error in radar charting: " .. tostring(err))
	end
end