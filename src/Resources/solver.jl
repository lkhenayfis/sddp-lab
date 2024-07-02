# CLASS Solver -----------------------------------------------------------------------

struct CLP <: Solver end
struct GLPK <: Solver end

function CLP(d::Dict{String,Any}, e::CompositeException)

    # Build internal objects
    valid_internals = __build_clp_internals_from_dicts!(d, e)

    # Keys and types validation
    valid_keys_types = valid_internals && __validate_clp_keys_types!(d, e)

    # Content validation
    valid_content = valid_keys_types && __validate_clp_content!(d, e)

    # Consistency validation
    valid_consistency = valid_content && __validate_clp_consistency!(d, e)

    return valid_consistency ? CLP() : nothing
end

function GLPK(d::Dict{String,Any}, e::CompositeException)

    # Build internal objects
    valid_internals = __build_glpk_internals_from_dicts!(d, e)

    # Keys and types validation
    valid_keys_types = valid_internals && __validate_glpk_keys_types!(d, e)

    # Content validation
    valid_content = valid_keys_types && __validate_glpk_content!(d, e)

    # Consistency validation
    valid_consistency = valid_content && __validate_glpk_consistency!(d, e)

    return valid_consistency ? GLPK() : nothing
end

# HELPERS -------------------------------------------------------------------------------------

function __build_solver!(d::Dict{String,Any}, e::CompositeException)::Bool
    valid_key_types = __validate_solver_main_key_type!(d, e)
    if !valid_key_types
        return false
    end

    return __kind_factory!(@__MODULE__, d, "solver", e)
end

function __cast_solver_internals_from_files!(
    d::Dict{String,Any}, e::CompositeException
)::Bool
    return true
end
