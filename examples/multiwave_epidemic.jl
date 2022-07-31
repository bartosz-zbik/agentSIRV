
using Plots, agentSIRV
using Statistics: mean

function simulate_step(p, d, ndoses, timeout)
	simulate_infections!(p, d)
	new_infections = time_passes!(p, d)
	vaccines_given = vaccinate!(p, ndoses, timeout)
	return new_infections, vaccines_given
end


ndoses = 400
timeout = 50

n_rep = 100
total_time = 200
d = Disease(0.6, 0.4, 0.01, 0.01);

data = Array{Int}(undef, total_time, n_rep, 6)
for rep_num = 1:n_rep
	p = LinkedPopulation(100, 100, 2, 10);
	inital_infecions!(p, 10)
	# simulation
	for t in 1:total_time
		data[t, rep_num, 5:6] .= simulate_step(p, d, ndoses, timeout)
		data[t, rep_num, 1:4] .= get_stats(p)
	end
end

# Agg data
agg_data = [mean(data[t, :, s]) for t=1:total_time, s=1:6]

plot(agg_data[:, 1], label="S")
plot!(agg_data[:, 2], label="I")
plot!(agg_data[:, 3], label="R")
plot!(agg_data[:, 4], label="V")


