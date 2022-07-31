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
	return num_new_infected
end


@inline function _infect_agent(p::BasicPopulation, d::Disease, i::Integer, j::Integer)::Nothing
	p.states[i, j] == Susceptible || return nothing
	p.new_infections[i, j] == false || return nothing
	rand() < d.s2i && (p.new_infections[i, j] = true)
	return nothing
end



function _infect_neighbours(p::BasicPopulation, d::Disease, index1::Integer, index2::Integer)::Nothing
	for nb in 1:size(p.neighbours)[1]
		_infect_agent(p, d,
			      mod1(p.neighbours[nb, 1] + index1, p.pop_size[1]),
			      mod1(p.neighbours[nb, 1] + index2, p.pop_size[2]))
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

