module HMD

using HTTP, CSV, DataFrames

"""
  read_HMD(country::String, tbl::String, grp::String, username::String, password::String; save=false)

Takes as input the country, table, interval and user credentials.

- `country` the country OR country code -- see `get_country()` for a full list
- `tbl` the chosen table OR table code -- see `get_table()` for a full list
- `grp` one of "1x1", "1x5", "1x10" -- depending on combination with `tbl`
- `username` email address when registering
- `password` password when registering

Optional:
- `save` a Boolean keyword to save to a CSV

Returns a `DataFrame` object if successful.
"""

function read_HMD(country::String, tbl::String, grp::String, username::String, password::String; save=false)

  println("Checking inputs are valid...")
  @assert is_valid(country, tbl, grp) == true

  login_url = "https://www.mortality.org/Account/Login"
  logout_url = "https://www.mortality.org/Account/Logout"

  println("Attempting initial connection...")
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
    println("Attempting to login...")
    HMD_url = get_url(country, tbl, grp)
    get_data = HTTP.request("GET", HMD_url; cookies=true)
    println("Data successfully retrieved...")
    println("Data processing in progress...")
    df_ = process_raw_txt(String(get_data.body))
    println("Success!")
    if save == true
      file_path = country * "_" * tbl * "_" * grp * ".csv"
      CSV.write(file_path, df_)
    end
    return df_
  else
    return response
  end
end

function process_raw_txt(table_txt::String)::DataFrame
  table_csv::String = table_txt[findfirst("Year", table_txt)[1]:end]

  # remove spaces
  table_csv = replace(table_csv, r"[ ]+" => ",")
  # remove comma after new line
  table_csv = replace(table_csv, r"\n," => "\n")
  # remove '+' from '110+'
  table_csv = replace(table_csv, "+" => "")
  # Set '.' to 0 -- covers edge cases
  table_csv = replace(table_csv, ",.," => ",0.0,")
  table_csv = replace(table_csv, ",.\n" => ",0.0\n")
  table_csv = replace(table_csv, "0.0,.,0.0\n" => "0.0,0.0,0.0\n")
  # Read as DataFrame 
  table_df::DataFrame = DataFrame(CSV.File(IOBuffer(table_csv)))

  return table_df
end

function is_valid(country::String, tbl::String, grp::String)::Bool
  country_check = country ∈ keys(get_countries()) || country ∈ values(get_countries())
  if country_check
    table_check = tbl ∈ keys(get_tables()) || tbl ∈ values(get_tables())
    if table_check
      return table_check
    else
      @error "Invalid table: see HMD.get_tables() for a full list of valid tables"
      return table_check
    end
  else
    @error "Invalid country: see HMD.get_countries() for a full list of valid countries"
    return country_check
  end
end

function get_url(country::String, tbl::String, grp::String)::String
  list_of_countries = get_countries()
  list_of_tables = get_tables()

  data_url_stub = "https://www.mortality.org/File/GetDocument/hmd.v6/"
  if country ∈ keys(list_of_countries)
    country = list_of_countries[country]
  end
  if tbl ∈ keys(list_of_tables)
    tbl = list_of_tables[tbl]
  end

  if tbl ∈ ["Births", "Deaths_lexis", "Population", "Exposures_lexis", "E0per"]
    if grp == "1x5" && tbl == "Population"
      data_url = data_url_stub * country * "/STATS/" * "Population5.txt"
    else
      data_url = data_url_stub * country * "/STATS/" * tbl * ".txt"
    end
  else
    data_url = data_url_stub * country * "/STATS/" * tbl * "_" * grp * ".txt"
  end
  return data_url
end

"""
  get_countries()

Returns a `Dictionary` of valid country codes.
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
  get_tables()

Returns a `Dictionary` of valid tables.
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

export read_HMD, get_countries, get_tables

end # module HMD
