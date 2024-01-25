# HMD.jl
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Documentation](https://github.com/patrickm663/HMD.jl/actions/workflows/documentation.yml/badge.svg)](https://github.com/patrickm663/HMD.jl/actions/workflows/documentation.yml)
[![Tests](https://github.com/patrickm663/HMD.jl/actions/workflows/tests.yml/badge.svg)](https://github.com/patrickm663/HMD.jl/actions/workflows/tests.yml)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://patrickm663.github.io/HMD.jl/dev/)
[![codecov](https://codecov.io/gh/patrickm663/HMD.jl/graph/badge.svg?token=CXYVX2GRUF)](https://codecov.io/gh/patrickm663/HMD.jl)

Makes it easy to get data from [Human Mortality Database (HMD)](https://www.mortality.org/) into Julia!

## Installation
The package can be installed directly using the repo's URL 

```julia
julia> using Pkg
julia> Pkg.add("https://github.com/patrickm633/HMD.jl")
```

If you want to tinker more with the internals, clone the repo, enter and activate!

```bash
git clone git@github.com:patrickm663/HMD.jl
cd HMD.jl/
```
```julia
julia
julia> using Pkg
julia> Pkg.activate(".")
```

## Quick Example
Once in, load `HMD`

```julia
julia> using HMD
julia> df = read_HMD("AUS", "Mx", "1x1", "username", "password"; verbose=true);
Checking inputs are valid...
Attempting initial connection...
Attempting to login...
Data successfully retrieved...
Data processing in progress...
Success!

julia> df
11100×5 DataFrame
   Row │ Year   Age    Female    Male      Total    
       │ Int64  Int64  Float64   Float64   Float64  
───────┼────────────────────────────────────────────
     1 │  1921      0  0.059987  0.076533  0.068444
     2 │  1921      1  0.012064  0.014339  0.013225
     3 │  1921      2  0.005779  0.006047  0.005916
     4 │  1921      3  0.002889  0.004197  0.003554
     5 │  1921      4  0.003254  0.003254  0.003254
...
```

It also supports long-form names:

```julia
julia> using HMD
julia> df = read_HMD("Australia", "Death Rates", "1x1", "username", "password"; verbose=true);
Checking inputs are valid...
Attempting initial connection...
Attempting to login...
Data successfully retrieved...
Data processing in progress...
Success!

julia> df
11100×5 DataFrame
   Row │ Year   Age    Female    Male      Total    
       │ Int64  Int64  Float64   Float64   Float64  
───────┼────────────────────────────────────────────
     1 │  1921      0  0.059987  0.076533  0.068444
     2 │  1921      1  0.012064  0.014339  0.013225
     3 │  1921      2  0.005779  0.006047  0.005916
     4 │  1921      3  0.002889  0.004197  0.003554
     5 │  1921      4  0.003254  0.003254  0.003254
...
```

Additionally, locally saved `.txt` file from HMD can be loaded and processed - with the option to save as a CSV

```julia
julia> using HMD
julia> df = read_HMD("test/data/Aus_Births.txt")
161×4 DataFrame
 Row │ Year   Female  Male    Total  
     │ Int64  Int64   Int64   Int64  
─────┼───────────────────────────────
   1 │  1860   23262   24464   47726
   2 │  1861   23806   25102   48908
   3 │  1862   24896   26483   51379
   4 │  1863   25134   26233   51367
   5 │  1864   26838   28608   55446
...
```

## Acknowledgements
The R package [HMDHFDplus](https://github.com/timriffe/TR1/tree/master/TR1) was a big help to figure out how to parse user-input correctly.

## TODO
My TODO over the next while is:
- [x] Figure out why docstrings aren't showing in the documentation
- [x] Maybe refactor `src/` to make it more modular
- [x] Complete the README
- [x] Add tests
- [x] Better error handling
- [x] Compile docs and run tests using Actions
- [ ] Think about how to handle 'secret' credentials (testing and general use)
- [ ] Check for valid country x table x group combos
- [ ] Make it compatible with [MortalityTables.jl](https://github.com/JuliaActuary/MortalityTables.jl)

## License
MIT licensed.
