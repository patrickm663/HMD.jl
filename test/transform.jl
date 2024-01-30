@testset "Test transformation" begin
  fn = String("data/Mx_1x1.txt")
  df = read_HMD(fn)
  @test !isempty(transform(df, :Male))
end
