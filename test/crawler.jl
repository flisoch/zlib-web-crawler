### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 6d012005-df15-4ea5-9e80-6b62f7c6002d
using HTTP, Gumbo, Cascadia

# ╔═╡ 02d37da7-6d78-4700-93e6-7a508dc36485
using Test

# ╔═╡ 2ed7c1af-bcde-4d28-ace2-9744fd91d2ae
maxresults = 5

# ╔═╡ 9646fa6a-9400-11eb-11d1-df895e6200d6
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ 504d6ffc-ffce-4049-83a8-6ad7754c97f5
config = ingredients("../src/config.jl")

# ╔═╡ 0f0d0ae4-1f97-4e5c-9338-38043466c53b
config.dict

# ╔═╡ df8c6bc5-88a8-4675-bbfd-191aae12f8fe
host = config.dict["domain"]["host"]

# ╔═╡ 0ea5d70e-d735-4bbc-a1dd-73c5a26aab0e
bookdirectory = config.dict["htmltags"]["search"]["result_books_url"]

# ╔═╡ 7fb1f5cd-88fe-4cd4-97e7-9bc19562c87e
search_url = config.dict["htmltags"]["search"]["url"] 

# ╔═╡ 6b0d6f08-1f8d-49bd-96a9-c0c3cf900717
searchquery = "duhigg"

# ╔═╡ c36e2394-db81-4b07-903d-21d10ff18275
request_url = "https://" * host * search_url * searchquery

# ╔═╡ d2302249-a3bf-4c5d-bb34-087b07e789e1
response = HTTP.get(request_url)

# ╔═╡ 90cae0b3-4266-44cc-8447-132754c2f874
html = parsehtml(String(response.body))

# ╔═╡ 51f2f6c1-fe9c-46b0-897d-cca37be1e6df
s = Selector("a")

# ╔═╡ b649d01c-6267-4bf4-8e7e-6b57314899af
links = eachmatch(s, html.root)

# ╔═╡ e023fa21-865f-41fe-b460-8a77859a03f2
results = []

# ╔═╡ b611d60f-f589-468e-a83f-e87811a47b7b
for link in links
	attrs1 = attrs(link)
	if haskey(attrs1, "href")
		link = attrs(link)["href"]
		if contains(link, bookdirectory)
			result = "https://" * host * link
			@show result
			push!(results, result)
		end
	end
end

# ╔═╡ 4aa22bec-a3f8-48e9-9428-18908feba9e8
results

# ╔═╡ 542d941a-bcf2-4ec7-9d6d-c8a0deab53ef
# [1].attributes["href"]

# ╔═╡ b7d6ac76-e4c2-4d7a-ae14-beabbf295870
topresults = results[1:maxresults]

# ╔═╡ b96055df-00e7-4824-b4eb-65c3c6f4bee6
booklink = topresults[1]

# ╔═╡ 9a0d927f-29d8-492d-bf0f-77bd06c37a82
response1 = HTTP.get(booklink)

# ╔═╡ 44f7c485-db5f-4298-a27c-ae7b3ab6f39a
html1 = parsehtml(String(response1.body))

# ╔═╡ 78559a92-7619-46c6-a13e-cadf1921cf18
s1 = Selector("a")

# ╔═╡ 0681dcdb-077f-4954-8c4c-7186275c7801
allinks = eachmatch(s1, html1.root)

# ╔═╡ 5f2c090f-c6e7-4a7b-8f04-d193d9880953


# ╔═╡ 9762c15d-c514-45be-9154-6093cb0551a5
allinks1 = []

# ╔═╡ c78b7492-44d1-4303-804a-fe093ddad5a6
for link in allinks
	attrs1 = attrs(link)
	if haskey(attrs1, "href")
		link1 = attrs(link)["href"]
		if contains(link1, "/dl/")
			result = "https://" * host * link1
			@show result
			push!(allinks1, result)
		end
	end
end

# ╔═╡ fa7edcd4-1104-45ab-9267-c631ac63e4e9
allinks1

# ╔═╡ fe684ca0-b797-4d06-a161-127e87758598


# ╔═╡ Cell order:
# ╠═6d012005-df15-4ea5-9e80-6b62f7c6002d
# ╠═02d37da7-6d78-4700-93e6-7a508dc36485
# ╠═2ed7c1af-bcde-4d28-ace2-9744fd91d2ae
# ╠═9646fa6a-9400-11eb-11d1-df895e6200d6
# ╠═504d6ffc-ffce-4049-83a8-6ad7754c97f5
# ╠═0f0d0ae4-1f97-4e5c-9338-38043466c53b
# ╠═df8c6bc5-88a8-4675-bbfd-191aae12f8fe
# ╠═0ea5d70e-d735-4bbc-a1dd-73c5a26aab0e
# ╠═7fb1f5cd-88fe-4cd4-97e7-9bc19562c87e
# ╠═6b0d6f08-1f8d-49bd-96a9-c0c3cf900717
# ╠═c36e2394-db81-4b07-903d-21d10ff18275
# ╠═d2302249-a3bf-4c5d-bb34-087b07e789e1
# ╠═90cae0b3-4266-44cc-8447-132754c2f874
# ╠═51f2f6c1-fe9c-46b0-897d-cca37be1e6df
# ╠═b649d01c-6267-4bf4-8e7e-6b57314899af
# ╠═e023fa21-865f-41fe-b460-8a77859a03f2
# ╠═b611d60f-f589-468e-a83f-e87811a47b7b
# ╠═4aa22bec-a3f8-48e9-9428-18908feba9e8
# ╠═542d941a-bcf2-4ec7-9d6d-c8a0deab53ef
# ╠═b7d6ac76-e4c2-4d7a-ae14-beabbf295870
# ╠═b96055df-00e7-4824-b4eb-65c3c6f4bee6
# ╠═9a0d927f-29d8-492d-bf0f-77bd06c37a82
# ╠═44f7c485-db5f-4298-a27c-ae7b3ab6f39a
# ╠═78559a92-7619-46c6-a13e-cadf1921cf18
# ╠═0681dcdb-077f-4954-8c4c-7186275c7801
# ╠═5f2c090f-c6e7-4a7b-8f04-d193d9880953
# ╠═9762c15d-c514-45be-9154-6093cb0551a5
# ╠═c78b7492-44d1-4303-804a-fe093ddad5a6
# ╠═fa7edcd4-1104-45ab-9267-c631ac63e4e9
# ╠═fe684ca0-b797-4d06-a161-127e87758598
