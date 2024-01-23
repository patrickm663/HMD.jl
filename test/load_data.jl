@testset "Load data" begin
  for k ∈ readdir("data/")
    fn = String("data/" * k)
    @test !isempty(read_HMD(fn))
  end
end
