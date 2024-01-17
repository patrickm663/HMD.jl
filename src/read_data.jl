export read_HMD

"""
  readHMD(country::String, tbl::String, grp::String, username::String, password::String; save=false)

Returns `df_` or error message
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
    if save == true
      file_path = country * "_" * tbl * "_" * grp * ".csv"
      CSV.write(file_path, df_)
    end
    return df_
  else
    return response
  end
end
