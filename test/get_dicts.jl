@testset "Check dictionaries" begin
  @test !isempty(get_countries())
  @test !isempty(get_tables())
end
