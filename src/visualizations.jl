using Plots

color_scale = palette([:green, :red, :gray, :blue])

"""
Plots the population states as a heatmap
"""
function st_plot(p::BasicPopulation)
	return heatmap(Int.(p.states), clims=(-0.1, 3.1), c=color_scale,
		       title="S=0, I=1, R=2, V=3")

end

"""
Plots vaccination likelihoods
"""
function vl_plot(p::BasicPopulation)
        return heatmap(p.vaccination_likelihoods)

end

