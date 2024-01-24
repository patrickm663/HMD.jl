@testset "Check getters" begin
  @test !isempty(get_countries())
  @test !isempty(get_tables())
  @test !isempty(get_groups())
end
