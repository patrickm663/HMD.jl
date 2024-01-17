export is_valid

"""
  is_valid(country::String, tbl::String, grp::String)::Bool

Returns `Bool`.
"""

function is_valid(country::String, tbl::String, grp::String)::Bool
  country_check = country ∈ ["AUS", "SWE", "USA"]
  if country_check
    table_check = tbl ∈ ["Deaths", "Births", "Population", "Exposure", "Mx", "fltpr", "mltpr", "bltpr", "e0per"]
    return table_check
  else
    return country_check
  end
end
