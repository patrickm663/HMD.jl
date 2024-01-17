# HMD.jl
Makes it easy to get data from Human Mortality Database (HMD) into Julia!

## Installation
Clone the repo, enter and activate!

```bash
git clone git@github.com:patrickm663/HMD.jl
cd HMD.jl/
julia
```
```julia
julia> using Pkg
julia> Pkg.activate(".")
```

## Quick Example
Once in, load `HMD`

```julia
julia> using HMD
julia> df = read_HMD("AUS", "Mx", "1x1", "username", "password");
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
     6 │  1921      5  0.002517  0.002509  0.002513
     7 │  1921      6  0.002485  0.002218  0.00235
     8 │  1921      7  0.001812  0.001924  0.001869
     9 │  1921      8  0.001384  0.001914  0.001651
    10 │  1921      9  0.001371  0.001419  0.001395
    11 │  1921     10  0.001249  0.001508  0.00138
    12 │  1921     11  0.001159  0.002104  0.001639
    13 │  1921     12  0.001128  0.001639  0.001387
    14 │  1921     13  0.001417  0.001547  0.001482
    15 │  1921     14  0.001435  0.001809  0.001625
    16 │  1921     15  0.001602  0.001463  0.001531
    17 │  1921     16  0.00181   0.002022  0.001918
    18 │  1921     17  0.002166  0.002518  0.002343
    19 │  1921     18  0.002477  0.002569  0.002523
    20 │  1921     19  0.002201  0.002415  0.002308
    21 │  1921     20  0.002976  0.002496  0.002737
    22 │  1921     21  0.002542  0.003257  0.002896
    23 │  1921     22  0.002535  0.003347  0.002934
    24 │  1921     23  0.003258  0.003237  0.003248
    25 │  1921     24  0.003139  0.003657  0.003388
   ⋮   │   ⋮      ⋮       ⋮         ⋮         ⋮
 11077 │  2020     87  0.07675   0.099391  0.08613
 11078 │  2020     88  0.085788  0.113244  0.0969
 11079 │  2020     89  0.100232  0.130582  0.11221
 11080 │  2020     90  0.112916  0.150207  0.127205
 11081 │  2020     91  0.138173  0.166285  0.148653
 11082 │  2020     92  0.151967  0.191856  0.166303
 11083 │  2020     93  0.170144  0.216478  0.185781
 11084 │  2020     94  0.192143  0.23242   0.204956
 11085 │  2020     95  0.234952  0.25596   0.241327
 11086 │  2020     96  0.236959  0.298463  0.25461
 11087 │  2020     97  0.279762  0.342779  0.296528
 11088 │  2020     98  0.303953  0.360883  0.317969
 11089 │  2020     99  0.321907  0.406846  0.341437
 11090 │  2020    100  0.35555   0.436786  0.373218
 11091 │  2020    101  0.431901  0.481868  0.441727
 11092 │  2020    102  0.477836  0.534439  0.487884
 11093 │  2020    103  0.509162  0.571852  0.51938
 11094 │  2020    104  0.541729  0.571353  0.546343
 11095 │  2020    105  0.583185  0.612091  0.587314
 11096 │  2020    106  0.623046  0.675425  0.629872
 11097 │  2020    107  0.669924  0.85531   0.688934
 11098 │  2020    108  0.737114  1.85915   0.793049
 11099 │  2020    109  0.898135  0.0       0.898135
 11100 │  2020    110  1.69687   0.0       1.69687
                                  11051 rows omitted
```

It also supports long-form names:

```julia
julia> using HMD
julia> df = read_HMD("Australia", "Death Rates", "1x1", "username", "password");
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
     6 │  1921      5  0.002517  0.002509  0.002513
     7 │  1921      6  0.002485  0.002218  0.00235
     8 │  1921      7  0.001812  0.001924  0.001869
     9 │  1921      8  0.001384  0.001914  0.001651
    10 │  1921      9  0.001371  0.001419  0.001395
    11 │  1921     10  0.001249  0.001508  0.00138
    12 │  1921     11  0.001159  0.002104  0.001639
    13 │  1921     12  0.001128  0.001639  0.001387
    14 │  1921     13  0.001417  0.001547  0.001482
    15 │  1921     14  0.001435  0.001809  0.001625
    16 │  1921     15  0.001602  0.001463  0.001531
    17 │  1921     16  0.00181   0.002022  0.001918
    18 │  1921     17  0.002166  0.002518  0.002343
    19 │  1921     18  0.002477  0.002569  0.002523
    20 │  1921     19  0.002201  0.002415  0.002308
    21 │  1921     20  0.002976  0.002496  0.002737
    22 │  1921     21  0.002542  0.003257  0.002896
    23 │  1921     22  0.002535  0.003347  0.002934
    24 │  1921     23  0.003258  0.003237  0.003248
    25 │  1921     24  0.003139  0.003657  0.003388
   ⋮   │   ⋮      ⋮       ⋮         ⋮         ⋮
 11077 │  2020     87  0.07675   0.099391  0.08613
 11078 │  2020     88  0.085788  0.113244  0.0969
 11079 │  2020     89  0.100232  0.130582  0.11221
 11080 │  2020     90  0.112916  0.150207  0.127205
 11081 │  2020     91  0.138173  0.166285  0.148653
 11082 │  2020     92  0.151967  0.191856  0.166303
 11083 │  2020     93  0.170144  0.216478  0.185781
 11084 │  2020     94  0.192143  0.23242   0.204956
 11085 │  2020     95  0.234952  0.25596   0.241327
 11086 │  2020     96  0.236959  0.298463  0.25461
 11087 │  2020     97  0.279762  0.342779  0.296528
 11088 │  2020     98  0.303953  0.360883  0.317969
 11089 │  2020     99  0.321907  0.406846  0.341437
 11090 │  2020    100  0.35555   0.436786  0.373218
 11091 │  2020    101  0.431901  0.481868  0.441727
 11092 │  2020    102  0.477836  0.534439  0.487884
 11093 │  2020    103  0.509162  0.571852  0.51938
 11094 │  2020    104  0.541729  0.571353  0.546343
 11095 │  2020    105  0.583185  0.612091  0.587314
 11096 │  2020    106  0.623046  0.675425  0.629872
 11097 │  2020    107  0.669924  0.85531   0.688934
 11098 │  2020    108  0.737114  1.85915   0.793049
 11099 │  2020    109  0.898135  0.0       0.898135
 11100 │  2020    110  1.69687   0.0       1.69687
                                  11051 rows omitted
```

## Acknowledgements
The R package [HMDHFDplus](https://github.com/timriffe/TR1/tree/master/TR1) was a big help to figure out how to parse user-input correctly.

## TODO
My TODO over the next while is:
- Complete the README
- Figure out why docstrings aren't showing in the documentation
- Maybe refactor `src/` to make it more modular
- Add tests
- Think about how to handle 'secret' credentials (testing and general use)
- Better error handling
- Check for valid country x table x group combos
- Compile docs and run tests using Actions

## License
MIT licensed.
