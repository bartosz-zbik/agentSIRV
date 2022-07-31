module agentSIRV

export EpidState, Disease, BasicPopulation, LinkedPopulation,
       get_stats, inital_infecions!,
       simulate_infections!, time_passes!

include("basic_structures.jl")
include("epidemic.jl")
include("LinkedPopulation.jl")

end
