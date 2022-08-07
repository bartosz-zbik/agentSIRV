
using Plots, agentSIRV
using Statistics: mean

simulate_step(p, d) = (simulate_infections!(p, d); time_passes!(p, d))

total_time = 50
d = Disease(0.6, 0.4, 0.01, 0.01);

p = BasicPopulation(100, 100, 2);
inital_infecions!(p, 4)
# simulation
anim = @animate for t in 1:total_time
	simulate_step(p, d)
	heatmap(Int.(p.states), cbar_lims=(0, 3), c=:Dark2_4)
end

gif(anim, "anim_fps3.gif", fps = 1)

