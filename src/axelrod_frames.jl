
using DelimitedFiles: readdlm

const frame_dir = (@__DIR__) * "/../axelrod_frames"

function apply_frame!(p::BasicPopulation, frame_number::Integer)::Nothing
    frame_path = frame_dir * "/$(p.pop_size[1])x$(p.pop_size[2])/$(frame_number).txt"
    F = readdlm(frame_path, '\t', Int, '\n')
    apply_frame!(p, F)
    return nothing
end

function apply_frame!(p::BasicPopulation, frame::Matrix{Int})::Nothing
    size(frame) == p.pop_size || error("frame size not compatybile with population size")
    new_val = rand(maximum(frame))
    map!(x -> new_val[x], p.vaccination_likelihoods, frame)
    return nothing
end

"""
    apply_binary_distribution!(p::BasicPopulation, vacp::Real)::Nothing

Vaccination likelihood is distributed according to the two point Bernoulli distribution with P(X = 1) = vacp
"""
function apply_binary_distribution!(p::BasicPopulation, vacp::Real)::Nothing
    (0 <= vacp <= 1) || error("vacp shold be between 0 and 1")
    p.vaccination_likelihoods .= Float64.(vacp .> rand(p.pop_size...))
    return nothing
end


"""
    apply_binary_frame!(p::BasicPopulation, frame_number::Integer, pdist::Function)::Nothing

pdist(n::Integer) should return vacp values for all n clusters as a n-element vector.
"""
function apply_binary_frame!(p::BasicPopulation, frame_number::Integer, pdist::Function)::Nothing
    frame_path = frame_dir * "/$(p.pop_size[1])x$(p.pop_size[2])/$(frame_number).txt"
    F = readdlm(frame_path, '\t', Int, '\n')
    apply_binary_frame!(p, F, pdist)
    return nothing
end

"""
    apply_binary_frame!(p::BasicPopulation, frame::Matrix{Int}, pdist::Function)::Nothing

pdist(n::Integer) should return vacp values for all n clusters as a n-element vector.
"""
function apply_binary_frame!(p::BasicPopulation, frame::Matrix{Int}, pdist::Function)::Nothing
    size(frame) == p.pop_size || error("frame size not compatible with population size")
    p_vals = pdist(maximum(frame))
    map!(x -> (p_vals[x] > rand() ? 1.0 : 0.0), p.vaccination_likelihoods, frame)
    return nothing
end

