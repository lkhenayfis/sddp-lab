# FORM VALIDATORS --------------------------------------------------------------------------

function __validate_naive_keys_types(d::Dict{String, Any}, e::CompositeException)::Bool
    return true
end

# CONTENT VALIDATORS -----------------------------------------------------------------------

function __validate_naive_content(d::Dict{String, Any}, e::CompositeException)::Bool

    # valid marginal model dist
        # valid dist name
        # valid dist params

    # valid copula per season
        # valid copula names
        # valid copula params
            # check dimension of matrix parameters

end

function __validate_distribution_name(name::String)
    as_symbol = Symbol(name)
    try
        getfield(Distributions, as_symbol) <: UnivariateDistribution
    catch
        return AssertionError("$name is not a valid UnivariateDistribution")
    end

    return true
end

function __validate_distribution_params(name::String, params::Vector{T} where T <: Real)
    try
        __instantiate_dist(name, params)
    catch 
        return AssertionError("`$params` not a valid set of parameters for distribution `$name`")
    end

    return true
end

function __validate_copula_name(name::String)
    as_symbol = Symbol(name)
    try
        getfield(Copulas, as_symbol) <: getfield(Copulas, :Copula)
    catch
        return AssertionError("$name is not a valid Copula")
    end

    return true
end

function __validate_copula_params(name::String, params::Union{Vector{T}, Matrix{Float64}} where T <: Real)
    try
        __instantiate_copula(name, params)
    catch 
        return AssertionError("`$params` not a valid set of parameters for distribution `$name`")
    end

    return true
end

# CONSISTENCY VALIDATORS -------------------------------------------------------------------