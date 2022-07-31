# Enum for epidemic state
"""
Enum to represent the epidemic state of an agent.
Currently supported states ate:
Susceptible
Infectious
Recovered
Vaccinated
"""
@enum EpidState::Int8 begin
	Susceptible
	Infectious
	Recovered
	Vaccinated
end
_isSusceptible(x::EpidState) = x == Susceptible
_isInfectious(x::EpidState) = x == Infectious
_isRecovered(x::EpidState) = x == Recovered
_isVaccinated(x::EpidState) = x == Vaccinated

# structure for disease parameters.
"""
Conatains the information about the disease:
transition probabilities and infection range
"""
struct Disease
    s2i::Float64
    i2r::Float64
    r2s::Float64
    v2s::Float64
    rng::Int8
end
Disease(s2i, i2r, r2s, v2s) = Disease(s2i, i2r, r2s, v2s, 2)

"""
Abstract type for all population implementations.
A population should have those methods defined:
1. get_stats(p::AbstractPopulation)::Tuple{Int, Int, Int, Int}
2. simulate_infections!(p::AbstractPopulation, d::Disease)
3. time_passes!(p::AbstractPopulation, d::Disease)::Int
4. inital_infecions!(p::AbstractPopulation, n::Integer)
"""
abstract type AbstractPopulation end

# Strucure for tracking just the state of the population
"""
Structure for the population.
Conteins also some fields that speed up the simulation.
"""
struct BasicPopulation <: AbstractPopulation
	pop_size::Tuple{Int, Int}
	inf_rng::Int
	num_of_nb::Int

	# actual state of population
	states::Matrix{EpidState}
	vaccination_likelihoods::Matrix{Float64}

	# helps with performing infectiosn
	new_infections::BitMatrix
	neighbours::Matrix{Int}

end

# function to generate populatio
include("neighbourhood.jl")

"""
Example
======

"""
function BasicPopulation(dim1::Integer, dim2::Integer, r::Integer)
	num_of_nb = (2r+1)^2 -1
	p = BasicPopulation((dim1, dim2), r, num_of_nb,
		       fill(Susceptible, dim1, dim2), rand(dim1,dim2),
		       falses(dim1, dim2), generate_neighbourhood(r))
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

"""
Infect some initial agents.
Randomly chouses n agents to infect.
Algorithm dosn't for duplicates, so it's actually infect up to n.

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



