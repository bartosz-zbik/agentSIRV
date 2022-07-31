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
end

"""
Abstract type for all population implementations.
A population should have those methods defined:
1. get_stats(p::AbstractPopulation)::Tuple{Int, Int, Int, Int}
2. simulate_infections!(p::AbstractPopulation, d::Disease)
3. time_passes!(p::AbstractPopulation, d::Disease)::Int
4. inital_infecions!(p::AbstractPopulation, n::Integer)
"""
abstract type AbstractPopulation end

