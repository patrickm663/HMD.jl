export process_raw_txt

"""
  process_raw_txt(table_txt::String)::DataFrame

Returns `table_df`.
"""

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

