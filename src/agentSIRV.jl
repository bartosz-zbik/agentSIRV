module agentSIRV

export EpidState, Disease, BasicPopulation,
       get_stats, inital_infecions!,
       get_S, get_I, get_R, get_V,
       simulate_infections!, time_passes!, vaccinate!, simulate_step!,
       apply_frame!, apply_binary_distribution!

include("basic_structures.jl")
include("BasicPopulation.jl")
include("epidemic.jl")
include("axelrod_frames.jl")

end

