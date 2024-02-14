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
julia> Pkg.add("https://github.com/patrickm663/HMD.jl")
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

Data can then be transformed into matrix-form where ages are rows and years are columns using the `transform()` function:

```julia
julia> transform(df, :Total)
111×101 DataFrame
 Row │ Age    1921      1922      1923      1924      1925      1926      1927      1928      1929      1930      1931      1932      1933      1934      1935      1936      1937      1938      1939      1940      1941      1942      1 ⋯
     │ Int64  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  Float64?  F ⋯
─────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │     0  0.068444  0.054918  0.062651  0.059428  0.055844  0.055631  0.056832  0.055516  0.052446  0.049286  0.042248  0.041085  0.040938  0.044885  0.041387  0.043345  0.039753  0.03947   0.039651  0.040198  0.04221   0.040777  0 ⋯
   2 │     1  0.013225  0.009842  0.011239  0.011047  0.009261  0.009759  0.010144  0.010582  0.009549  0.009369  0.006914  0.007134  0.00695   0.007495  0.006837  0.006828  0.005991  0.005777  0.005938  0.005709  0.005613  0.006035  0
   3 │     2  0.005916  0.004277  0.004675  0.004196  0.003659  0.004115  0.004131  0.004591  0.004561  0.004083  0.003713  0.003598  0.003528  0.003621  0.003737  0.003536  0.003264  0.003433  0.002983  0.002843  0.002933  0.002868  0
   4 │     3  0.003554  0.003078  0.002965  0.003141  0.002617  0.002888  0.003409  0.003103  0.003395  0.002715  0.002634  0.002629  0.002501  0.002951  0.002487  0.002531  0.002162  0.002383  0.002244  0.00196   0.002208  0.002113  0
   5 │     4  0.003254  0.00229   0.002383  0.002481  0.002333  0.002075  0.002325  0.001934  0.002351  0.002009  0.001789  0.002132  0.002086  0.002197  0.001869  0.002205  0.001838  0.001952  0.002041  0.001633  0.001815  0.001886  0 ⋯
...
```

Additionally, locally saved `.txt` file from HMD can be loaded and processed - with the option to save as a CSV:

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
- [x] Check for valid country x table x group combos
- [x] Add function to transform long-form `DataFrames` into $age \times year$ `DataFrames`
- [ ] Think about how to handle 'secret' credentials (testing and general use)
- [ ] Make it compatible with [MortalityTables.jl](https://github.com/JuliaActuary/MortalityTables.jl)

## License
MIT licensed.
