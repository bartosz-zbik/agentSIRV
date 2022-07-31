module agentSIRV

export EpidState, Disease, BasicPopulation, LinkedPopulation,
       get_stats, inital_infecions!,
       simulate_infections!, time_passes!, vaccinate!,
       apply_frame!

include("basic_structures.jl")
include("BasicPopulation.jl")
include("epidemic.jl")
include("LinkedPopulation.jl")
include("axelrod_frames.jl")

end
