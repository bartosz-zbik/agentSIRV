
using Plots, agentSIRV
using Statistics: mean

color_scale = palette([:green, :red, :gray, :blue])

total_time = 50
n_doses = 100
vacc_timeout = 100
d = Disease(0.6, 0.4, 0.01, 0.01);

p = LinkedPopulation(100, 100, 2, 10);
inital_infecions!(p, 4)
# simulation
anim = @animate for t in 1:total_time
	simulate_step!(p, d, n_doses, vacc_timeout)
	heatmap(Int.(p.p.states), clims=(-0.1, 3.1) , c=color_scale)
end

gif(anim, "anim_fps3.gif", fps = 1)

