module SDDPlab

using Random, Statistics, Distributions
using JSON, CSV, DataFrames
using SDDP, GLPK
using Plots
using Logging

include("Utils/Utils.jl")
include("Algorithm/Algorithm.jl")
include("Resources/Resources.jl")
include("System/System.jl")
include("StochasticProcess/StochasticProcess.jl")
include("inputs-validators.jl")
include("inputs.jl")
include("tasks.jl")
include("outputs-validators.jl")
include("outputs.jl")
# include("Config.jl")
# include("Reader.jl")
# include("Writer.jl")
include("Writer-refactor.jl")
include("build-model-refactor.jl")
# include("build-model.jl")
# include("Study.jl")
include("Study-refactor.jl")
include("Main.jl")

end
