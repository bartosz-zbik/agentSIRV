# Structure for tracking just the state of the population
"""
Structure for the population.
Contains also some fields that speed up the simulation.

This is mutable because time is stored inside BasicPopulation
"""
mutable struct BasicPopulation <: AbstractPopulation
	pop_size::Tuple{Int, Int}
	inf_rng::Int
	num_of_nb::Int
	time::Int

	# actual state of population
	states::Matrix{EpidState}
	vaccination_likelihoods::Matrix{Float64}
	last_dose::Matrix{Int}

        # tracks individual agents
	taken_doses::Matrix{Int}
	passed_infections::Matrix{Int}

	# helps with performing infections
	new_infections::BitMatrix
	neighbours::Matrix{Int}

	# helps with vaccination
	vaccination_queue::Vector{Int}

	# Links
	links::Matrix{Int}

end

# function to generate population
include("neighbourhood.jl")

"""
    BasicPopulation(dim1::Integer, dim2::Integer, r::Integer, nlinks::Integer=0)

Example
======

"""
function BasicPopulation(dim1::Integer, dim2::Integer, r::Integer, nlinks::Integer=0)
    num_of_nb = (2r + 1)^2 - 1
    p = BasicPopulation((dim1, dim2), r, num_of_nb, 0,
        fill(Susceptible, dim1, dim2), rand(dim1, dim2),
        fill(-1_000_000, dim1, dim2),
        zeros(dim1, dim2), zeros(dim1, dim2),
        falses(dim1, dim2), generate_neighbourhood(r), Vector{Int}(1:dim1*dim2),
        generate_links(dim1, dim2, nlinks))
    return p
end

# A bit of population interface
"""
Returns the number of indyviduals in each EpidState.
Return value is a tuple (S, I, R, V)
"""
function get_stats(p::BasicPopulation)::Tuple{Int, Int, Int, Int}
	S = count(_isSusceptible, p.states)
	I = count(_isInfectious, p.states)
	R = count(_isRecovered, p.states)
	V = count(_isVaccinated, p.states)
	return S, I, R, V
end

get_S(p::BasicPopulation)::Int = count(_isSusceptible, p.states)
get_I(p::BasicPopulation)::Int = count(_isInfectious, p.states)
get_R(p::BasicPopulation)::Int = count(_isRecovered, p.states)
get_V(p::BasicPopulation)::Int = count(_isVaccinated, p.states)

"""
Infect some initial agents.
Randomly chouses n agents to infect.
Algorithm dosn't check for duplicates, so it's actually infect up to n.

# Example
```
julia> p = BasicPopulation(100, 100, 2);

julia> inital_infecions!(p, 10)
```
"""
function inital_infecions!(p::BasicPopulation, n::Integer)
	for i in 1:n
		p.states[rand(1:p.pop_size[1]), rand(1:p.pop_size[2])] = Infectious
	end
	return nothing
end

