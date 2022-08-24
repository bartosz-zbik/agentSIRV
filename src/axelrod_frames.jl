
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

