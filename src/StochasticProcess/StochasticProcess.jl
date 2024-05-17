module StochasticProcess

using Random, Distributions, Copulas
using LinearAlgebra

import Copulas: Copula
import Base: length, size

abstract type AbstractStochasticProcess end

"""
    __get_ids(s)

Return the `id`s of elements represented in a stochastic process object
"""
__get_ids(s::AbstractStochasticProcess)

"""
    length(s::AbstractStochasticProcess)

Return the number of dimensions (elements) in a stochastic process
"""
length(s::AbstractStochasticProcess)

"""
    size(s::AbstractStochasticProcess)

Return the size of the process, a tuple with (number_of_elements, number_of_seasons[,...])

Depending on the type of model, it is possible that there are extra elements in the returned
tuple, so refer to the corresponding documentation for more details
"""
size(s::AbstractStochasticProcess)

"""
    __generate_saa([rng::AbstractRNG, ]s::AbstractStochasticProcess, initial_season::Integer, N::Integer, B::Integer)

Generate a Sample Average Approximation of the noise (uncertainty) terms in model `s`
"""
__generate_saa(rng::AbstractRNG, s::AbstractStochasticProcess, initial_season::Integer, N::Integer, B::Integer)

function __generate_saa(s::AbstractStochasticProcess, initial_season::Integer, N::Integer, B::Integer)
    __generate_saa(Random.default_rng(), s::AbstractStochasticProcess, initial_season::Integer, N::Integer, B::Integer)
end

"""
    __validate(s::AbstractStochasticProcess)

Return `true` if `s` is a valid instance of stochastic process; raise errors otherwise
"""
__validate(s::AbstractStochasticProcess)

include("naive.jl")

end