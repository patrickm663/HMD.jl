# License: MIT
# A set of utility functions

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
  # check whether user has provided short-form or long-form name
  country_check = country ∈ keys(get_countries()) || country ∈ values(get_countries())
  if country_check
    # check whether user has provided short-form or long-form name
    table_check = tbl ∈ keys(get_tables()) || tbl ∈ values(get_tables())
    if table_check
      group_check = grp ∈ get_groups()
      if group_check
	return group_check
      else
	@error "Invalid group: see HMD.get_groups() for a full list of valid groups"
	return group_check
      end
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
  # Get dicts containing long and short-form names
  list_of_countries = get_countries()
  list_of_tables = get_tables()

  data_url_stub = "https://www.mortality.org/File/GetDocument/hmd.v6/"
  # If long-form provided, convert to short-form (else assume short-form)
  if country ∈ keys(list_of_countries)
    country = list_of_countries[country]
  end
  # If long-form provided, convert to short-form (else assume short-form)
  if tbl ∈ keys(list_of_tables)
    tbl = list_of_tables[tbl]
  end

  # Covers *some* permissible combinations
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
