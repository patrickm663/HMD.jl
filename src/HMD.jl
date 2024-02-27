# License: MIT
# Core functions

__precompile__()

module HMD

using HTTP, CSV, DataFrames

include("utils.jl")

"""
  `read_HMD(country::String, tbl::String, grp::String, username::String, password::String; save=false, verbose=false)::Union{Nothing, DataFrame}`

Takes as input the country, table, interval and user credentials.

- `country` the country OR country code -- see `get_country()` for a full list
- `tbl` the chosen table OR table code -- see `get_table()` for a full list
- `grp` one of "1x1", "1x5", "1x10" -- depending on combination with `tbl`
- `username` email address when registering
- `password` password when registering

Optional:
- `save` a Boolean keyword to save to a CSV
- `verbose` for progress logs

Returns a `DataFrame` object if successful.
"""
function read_HMD(country::String, tbl::String, grp::String, username::String, password::String; save=false, verbose=false)::Union{Nothing, DataFrame}
  if verbose
    println("Checking inputs are valid...")
  end

  if is_valid(country, tbl, grp)
    login_url = "https://www.mortality.org/Account/Login"
    logout_url = "https://www.mortality.org/Account/Logout"

    if verbose
      println("Attempting initial connection...")
    end

    logout = HTTP.request("PUT", logout_url; cookies=true)
    session = HTTP.request("GET", login_url; cookies=true)
    session_string = String(session.body)

    full_index = findfirst("__RequestVerificationToken", session_string)
    token_index = (full_index[1]+49):(full_index[2]+202)

    token = session_string[token_index]
    @assert token != ""

    credentials = Dict(
		       "Email" => username,
		       "Password" => password,
		       "__RequestVerificationToken" => token)

    form = HTTP.Form(credentials)
    response = HTTP.request("POST", login_url, [], form; cookies=true)

    if response.status == 200
      if verbose
	println("Attempting to login...")
      end
      HMD_url = get_url(country, tbl, grp)
      try
	get_data = HTTP.request("GET", HMD_url; cookies=true)
	if verbose
	  println("Data successfully retrieved...")
	  println("Data processing in progress...")
	end
	df_ = process_raw_txt(String(get_data.body))
	if verbose
	  println("Success!")
	end
	if save == true
	  try 
	    file_path = country * "_" * tbl * "_" * grp * ".csv"
	    CSV.write(file_path, df_)
	    if verbose
	      println("File saved as: "*file_path)
	    end
	  catch
	    return @error "Unable to write to path"
	  end
	end
	return df_
      catch
	return @error "Please ensure username and password are correct. Otherwise, ensure a valid combination of country, table, and group are provided"
      end
    else
      return @error "Connection error encounted"
    end
  end
end

"""
  `read_HMD(file_name::String; save=false, verbose=false)::Union{Nothing, DataFrame}`

Takes as input the location of a .txt file downloaded from https://www.mortality.org/ and stored locally

Optional:
- `save` a Boolean keyword to save to a CSV
- `verbose` for progress logs

Returns a `DataFrame` object containing the data.
"""
function read_HMD(file_name::String; save=false, verbose=false)::Union{Nothing, DataFrame}
  # Check a .txt file is provided
  @assert contains(file_name, ".txt")

  try
    # Open the file then read it as a String
    txt_file = open(file_name, "r")
    txt_string = read(txt_file, String)
    # Apply the same pre-processing as per the online read_HMD() function
    df_ = process_raw_txt(txt_string)
    close(txt_file)

    if save == true
      # Remove .txt extension
      file_path = file_name[1:(end-3)] * "csv"
      CSV.write(file_path, df_)
      if verbose
	println("File saved as: "*file_path)
      end
    end
    return df_
  catch
    return @error "Invalid file"
  end
end


"""
  `get_countries()::Dict{String, String}`

Returns a `Dictionary` of valid countries and territories (i.e "Australia", "Austria", etc.)
"""
function get_countries()::Dict{String, String}
  countries = Dict{String, String}(
				   "Australia" => "AUS",
				   "Austria" => "AUT",
				   "Belarus" => "BLR",
				   "Belgium" => "BEL", 
				   "Bulgaria" => "BGR", 
				   "Canada" => "CAN", 
				   "Chile" =>"CHL", 
				   "Croatia" => "HRV", 
				   "Czechia" => "CZE", 
				   "Czech Republic" => "CZE", 
				   "Denmark" => "DNK", 
				   "Estonia" => "EST", 
				   "Finland" => "FIN", 
				   "France" => "FRATNP", 
				   "France (Civilian)" => "FRAcNP", 
				   "Germany" => "DEUTNP",
				   "Germany (East)" => "DEUTE",
				   "Germany (West)" => "DEUTW",
				   "Greece" => "GRK", 
				   "Hong Kong" => "HKG", 
				   "Hungary" => "HUN", 
				   "Iceland" => "ISL", 
				   "Ireland" => "IRL",
				   "Republic of Ireland" => "IRL",
				   "Italy" => "ITA",
				   "Japan" => "JPN",
				   "Latvia" => "LVA",
				   "Lithuania" => "LTU",
				   "Luxembourg" => "LUX",
				   "Netherlands" => "NLD",
				   "The Netherlands" => "NLD",
				   "New Zealand" => "NZL_NP",
				   "New Zealand (Maori)" => "NZL_MA",
				   "New Zealand (Non-Maori)" => "NZL_NM",
				   "Norway" => "NOR",
				   "Poland" => "POL",
				   "Republic of Korea" => "KOR",
				   "South Korea" => "KOR",
				   "Russia" => "RUS",
				   "Slovakia" => "SVK",
				   "Slovenia" => "SVN",
				   "Spain" => "ESP",
				   "Sweden" => "SWE", 
				   "Switzerland" => "CHE",
				   "Taiwan" => "TWN",
				   "United Kingdom" => "GBR_NP",
				   "U.K." => "GBR_NP",
				   "Great Britain" => "GBR_NP",
				   "United Kingdom (England and Wales)" => "GBRTENW",
				   "United Kingdom (England and Wales Civilian)" => "GBRCENW",
				   "United Kingdom (Scotland)" => "GBR_SCO",
				   "Scotland" => "GBR_SCO",
				   "United Kingdom (Northern Ireland)" => "GBR_NIR",
				   "Northern Ireland" => "GBR_NIR",
				   "United States of America" => "USA",
				   "U.S.A." => "USA",
				   "U.S." => "USA",
				   "Ukraine" => "UKR")
  return countries
end

"""
  `get_tables()::Dict{String, String}`

Returns a `Dictionary` of valid tables (i.e. "Births", "Deaths", etc.).
"""
function get_tables()::Dict{String, String}
  tables = Dict{String, String}(
				"Births" => "Births",
				"Deaths" => "Deaths", 
				"Deaths by Lexis Triangle" => "Deaths_lexis", 
				"Population size" => "Population", 
				"Exposure-to-risk" => "Exposures", 
				"Exposure-to-risk by Lexis triangles" => "Exposures_lexis", 
				"Death Rates" => "Mx", 
				"Life tables: Females" => "fltper", 
				"Life tables: Males" => "mltper", 
				"Life tables: Total (both sexes)" => "bltper", 
				"Life expectancy at birth" => "E0per", 
				"Cohort: Exposure-to-risk" => "cExposures", 
				"Cohort: Death Rates" => "cMx", 
				"Cohort: Life tables: Females" => "fltcoh", 
				"Cohort: Life tables: Males" => "mltcoh", 
				"Cohort: Life tables: Total (both sexes)" => "bltcoh", 
				"Cohort: Life expectancy at birth" => "E0coh")
  return tables
end

"""
  `get_groups()::Vector{String}`

Returns a `Vector` of valid groupings (i.e. "1x1", "1x5", etc.)
"""
function get_groups()::Vector{String}
  grps = ["1x1", "1x5", "1x10", "5x1", "5x5", "5x10"]
  return grps
end

"""
  `transform(df::DataFrame, col::Symbol)::Union{Nothing, DataFrame}`

Returns a `DataFrame` structured age x year for a given feature (e.g. :Total)
"""
function transform(df::DataFrame, col::Symbol)::Union{Nothing, DataFrame}
  if "Year" ∈ names(df) && "Age" ∈ names(df)
    if String(col) ∈ names(df) && String(col) ∉ ["Year", "Age"]
      return unstack(select(df, [:Year, :Age, col]), :Year, col)
    else
      return @error "Invalid column selected. Valid columns are: $(filter(x -> x ∉ ["Year", "Age"], names(df)))"
    end
  else
    return @error "Invalid table for this operation"
  end
end


export read_HMD, get_countries, get_tables, get_groups, transform

end # module HMD
