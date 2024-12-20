using SDDPlab: SDDPlab
using Suppressor

@testset "main" begin
    @testset "main_success" begin
        e = CompositeException()
        using GLPK
        @suppress begin
        SDDPlab.main(example_dir, GLPK.Optimizer; e = e)
        end
        @test length(e) == 0
    end
end