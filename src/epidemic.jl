"""
Updates the states of newlly infected and simulates the proces of recovering and lose of immunity.
"""
function time_passes!(p::BasicPopulation, d::Disease)::Int
	num_new_infected = sum(p.new_infections)
	for i in eachindex(p.states)
		if p.new_infections[i]
			p.states[i] = Infectious
			p.new_infections[i] = false
		elseif p.states[i] == Recovered
			if rand() < d.r2s
                                p.states[i] = Susceptible
                        end  
		elseif p.states[i] == Vaccinated
			if rand() < d.v2s
                                p.states[i] = Susceptible
                        end  
		elseif p.states[i] == Infectious
			if rand() < d.i2r
				p.states[i] = Recovered
			end
		end #if-el
	end #for
	p.time += 1
	return num_new_infected
end


@inline function _infect_agent(p::BasicPopulation, d::Disease, i::Integer, j::Integer)::Nothing
	if p.states[i, j] == Susceptible && p.new_infections[i, j] == false
		rand() < d.s2i && (p.new_infections[i, j] = true)
	end
	return nothing
end

@inline function _vaccinate_agent(p::BasicPopulation, dose_timeout::Integer, i::Integer, j::Integer)::Bool
	if p.states[i, j] != Infectious && p.time - p.last_dose[i, j] > dose_timeout
		if rand() < p.vaccination_likelihoods[i, j]
			p.states[i, j] = Vaccinated
			p.last_dose[i,j] = p.time
			return true
		end
        end     
        return false
end

function _infect_neighbours(p::BasicPopulation, d::Disease, index1::Integer, index2::Integer)::Nothing
	for nb in 1:size(p.neighbours)[1]
		_infect_agent(p, d,
			      mod1(p.neighbours[nb, 1] + index1, p.pop_size[1]),
			      mod1(p.neighbours[nb, 2] + index2, p.pop_size[2]))
	end
	return nothing
end


"""
All Infectious in the population infect their neighbours.
The state of the population dosent change yet, invoke `time_passes!` to update them..
"""
function simulate_infections!(p::BasicPopulation, d::Disease)::Nothing
	for i=1:p.pop_size[1], j=1:p.pop_size[2]
		p.states[i,j] != Infectious && continue
		_infect_neighbours(p, d, i, j)
	end
	return nothing
end

"""
Vaccinate population.
The vaccination procedure will stop when ndoses is reached or when the whole population got a chance.
This uses time filed which is stored in BasicPopulation and is updated each time `time_passes!` is invoked.
"""
function vaccinate!(p::BasicPopulation, ndoses::Integer, vaccine_timeout::Integer)::Int
	ndoses >= 0 ||  error("Negative dose count to allowed")
	ndoses == 0 && return 0

	given_doses = 0
	for i in 1:p.pop_size[1], j in 1:p.pop_size[2]
		given_doses += _vaccinate_agent(p, vaccine_timeout, i, j)
		given_doses >= ndoses && break
	end
	return given_doses
end

