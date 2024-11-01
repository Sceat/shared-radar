require("src.game.radars")

script.on_nth_tick(60*10, function(e)
	chart_radars_and_players()
end)