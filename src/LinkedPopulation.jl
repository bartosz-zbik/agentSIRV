
struct LinkedPopulation <: AbstractPopulation
	p::BasicPopulation
	links::Matrix{Int}
end

function LinkedPopulation(dim1::Integer, dim2::Integer, r::Integer, nlinks::Integer)
	return LinkedPopulation(BasicPopulation(dim1, dim2, r), generate_links(dim1, dim2, nlinks))
end

function generate_links(dim1::Integer, dim2::Integer, n::Integer)::Matrix{Int}
	links = Array{Int}(undef, n, 4)
	for i in 1:n
		links[i, 1] = rand(1:dim1)
		links[i, 2] = rand(1:dim2)
		links[i, 3] = rand(1:dim1)
		links[i, 4] = rand(1:dim2)
	end
	return links
end

time_passes!(p::LinkedPopulation, d::Disease) = time_passes!(p.p, d)

function _infect_through_links(p::LinkedPopulation, d::Disease, index1::Integer, index2::Integer)::Nothing
	for i in 1:size(p.links)[1]
		if p.links[i, 1] == index1 && p.links[i, 2] == index2
			_infect_agent(p.p, d, p.links[i, 3:4]...)
		elseif p.links[i, 3] == index1 && p.links[i, 4] == index2
			 _infect_agent(p.p, d, p.links[i, 1:2]...)
		end
	end
	return nothing
end


function simulate_infections!(p::LinkedPopulation, d::Disease)::Nothing
        for i=1:p.p.pop_size[1], j=1:p.p.pop_size[2]
                p.p.states[i,j] != Infectious && continue
                _infect_neighbours(p.p, d, i, j)
		_infect_through_links(p, d, i, j)
        end
        return nothing
end

function vaccinate!(p::LinkedPopulation, ndoses::Integer, vaccine_timeout::Integer)::Int
	return vaccinate!(p.p, ndoses, vaccine_timeout)
end

get_stats(p::LinkedPopulation) = get_stats(p.p)
inital_infecions!(p::LinkedPopulation, n::Integer) = inital_infecions!(p.p, n)


