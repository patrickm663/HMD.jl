#push!(LOAD_PATH,"../src/")
# source: https://github.com/JuliaActuary/LifeContingencies.jl/blob/master/docs/make.jl
#
using Documenter, HMD

makedocs(;
	 modules=[HMD],
	 format=Documenter.HTML(;
				prettyurls=get(ENV, "CI", "false") == "true",
				assets=String[]
			       ),
	 pages=[
		"Home" => "index.md",
		],
	 repo=Remotes.GitHub("patrickm663", "HMD.jl"),
	 sitename="HMD.jl",
	 authors="Patrick Moehrke <patrick@patrickmoehrke.com> and contributors")

deploydocs(; repo="github.com/patrickm663/HMD.jl")
