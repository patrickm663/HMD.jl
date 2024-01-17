using Pkg
Pkg.activate("..")
push!(LOAD_PATH,"../src/")

using Documenter, HMD

makedocs(sitename = "HMD.jl", modules = [HMD])

deploydocs(repo="github.com/patrickm663/HMD.jl.git")
