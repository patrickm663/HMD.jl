module HMD

using HTTP, CSV, DataFrames

"""
  read_HMD(country::String, tbl::String, grp::String, username::String, password::String; save=false)

Takes as input the country, table, interval and user credentials.

- `country` the three letter country code
- `tbl` one of "Mx", "Dx", etc.
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
  data_url_stub = "https://www.mortality.org/File/GetDocument/hmd.v6/"
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
    data_url = data_url_stub * country * "/STATS/" * tbl * "_" * grp * ".txt"
    get_data = HTTP.request("GET", data_url; cookies=true)
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
  country_check = country ∈ ["AUS", "SWE", "USA"]
  if country_check
    table_check = tbl ∈ ["Deaths", "Births", "Population", "Exposure", "Mx", "fltpr", "mltpr", "bltpr", "e0per"]
    return table_check
  else
    return country_check
  end
end

export read_HMD

end # module HMD
