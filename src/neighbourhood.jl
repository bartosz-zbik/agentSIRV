
function generate_neighbourhood(n::Integer)::Matrix{Int}
	num_of_nb = (2n+1)^2 - 1
	tmp_nb = Matrix{Int}(undef, num_of_nb, 2)
	current_index = 1
	for i = -n:n, j = -n:n
		if (i != 0 || j != 0)
			tmp_nb[current_index, :] .= (i, j)
			current_index += 1
		end
	end
	current_index - 1 == num_of_nb || error("Failed to generate neighbourhood.")
	return tmp_nb
end

