module agentSIRV

export EpidState, Disease, BasicPopulation,
       get_stats, inital_infecions!,
       get_S, get_I, get_R, get_V,
       simulate_infections!, time_passes!, vaccinate!, simulate_step!,
       apply_frame!

include("basic_structures.jl")
include("BasicPopulation.jl")
include("epidemic.jl")
include("axelrod_frames.jl")

# try visualizations
# This is how to NOT do this
try
	include("visualizations.jl")
	export st_plot, vl_plot
catch e
	println(e)
	@warn "Plotting utils not avialable."
end

end
