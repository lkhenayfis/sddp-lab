# FORM VALIDATORS --------------------------------------------------------------------------

function __validate_keys!(d::Dict, keys::Vector{String}, e::CompositeException)::Bool
    valid = true
    for k in keys
        valid_k = haskey(d, k)
        valid_k || push!(e, ErrorException("Key '$k' not found in dictionary"))
        valid = valid && valid_k
    end

    return valid
end

function __validate_key_lengths!(
    d::Dict, keys::Vector{String}, sizes::Vector{Int}, e::CompositeException
)::Bool
    valid = true
    for (k, s) in zip(keys, sizes)
        valid_l = length(d[k]) == s
        valid_l || push!(e, ErrorException("Key '$k' has length =/= $s"))
        valid = valid && valid_l
    end

    return valid
end

function __validate_key_types!(
    d::Dict, keys::Vector{String}, types::Vector{DataType}, e::CompositeException
)::Bool
    valid = true
    for (k, t) in zip(keys, types)
        aux = __parse_as_type!(d, k, t)
        valid_t = !(typeof(aux) <: Exception)
        valid_t || push!(e, aux)
        valid = valid && valid_t
    end

    return valid
end

# FILE VALIDATORS --------------------------------------------------------------------------

function __validate_file!(path::String, e::CompositeException)::Bool
    valid = isfile(path)
    valid || push!(e, ErrorException("$path not found!"))
    return valid
end

function __validate_directory!(path::String, e::CompositeException)::Bool
    valid = isdir(path)
    valid || push!(e, ErrorException("$path not found!"))
    return valid
end

# DATAFRAME VALIDATORS ---------------------------------------------------------------------

function __dataframe_to_dict(df::DataFrame)::Vector{Dict{String,Any}}
    columns = names(df)
    d::Vector{Dict{String,Any}} = []
    for i in 1:nrow(df)
        push!(d, Dict{String,Any}(name => df[i, name] for name in columns))
    end

    return d
end

function __validate_columns_in_dataframe!(
    df::DataFrame, columns::Vector{String}, e::CompositeException
)::Bool
    valid = true
    df_columns = names(df)
    for col in columns
        column_in_df = findfirst(==(col), df_columns) !== nothing
        column_in_df ||
            push!(e, AssertionError("Column $col not found in DataFrame ($df_columns)"))
        valid = valid && column_in_df
    end
    return valid
end

function __validate_column_types_in_dataframe!(
    df::DataFrame, columns::Vector{String}, types::Vector{DataType}, e::CompositeException
)::Bool
    valid = true
    df_columns = names(df)
    for (col, col_type) in zip(columns, types)
        column_in_df = findfirst(==(col), df_columns) !== nothing
        if column_in_df
            df_col_type = eltype(df[!, col])
            col_type_in_df = df_col_type <: col_type
            col_type_in_df || push!(
                e, AssertionError("Column $col ($df_col_type) not of type ($col_type)")
            )
            valid = valid && col_type_in_df
        end
    end
    return valid
end

function __validate_dataframe!(
    df::DataFrame, cols::Vector{String}, types::Vector{DataType}, e::CompositeException
)::Union{DataFrame,Nothing}
    valid_cols = __validate_columns_in_dataframe!(df, cols, e)
    valid_df = valid_cols && __validate_column_types_in_dataframe!(df, cols, types, e)
    return valid_df ? df : nothing
end

function __validate_dataframe_content_and_cast!(
    df::DataFrame, cols::Vector{String}, types::Vector{DataType}, e::CompositeException
)::Union{Vector{Dict{String,Any}},Nothing}
    df = __validate_dataframe!(df, cols, types, e)
    valid = df !== nothing
    return valid ? __dataframe_to_dict(df) : nothing
end

function __validate_required_default_values!(
    default_values::Dict{String,Any},
    columns_requiring_default_values::Vector{String},
    columns_data_types::Vector{DataType},
    df::DataFrame,
    e::CompositeException,
)::Bool
    valid_column_keys = __validate_keys!(
        default_values, columns_requiring_default_values, e
    )
    valid_column_types = if valid_column_keys
        __validate_key_types!(
            default_values, columns_requiring_default_values, columns_data_types, e
        )
    else
        false
    end
    columns_in_dataframe = __validate_columns_in_dataframe!(
        df, collect(keys(default_values)), e
    )
    return valid_column_keys && valid_column_types && columns_in_dataframe
end

# HELPERS ----------------------------------------------------------------------------------

function __parse_as_type!(d::Dict, k::String, t::DataType)
    if typeof(d[k]) == t
        return nothing
    else
        try
            __try_conversion!(d, k, t)
            return nothing
        catch
            v = d[k]
            err = ErrorException("Key '$k' can't be converted to $t")
            return err
        end
    end
end

function __try_conversion!(d::Dict, k::String, t::DataType)
    return d[k] = convert(t, d[k])
end

function __try_conversion!(d::Dict, k::String, t::Type{String})
    return d[k] = string(d[k])
end

function __try_conversion!(d::Dict, k::String, t::Type{Matrix{T}} where {T})
    aux = stack(d[k]; dims = 1)
    return d[k] = convert(t, aux)
end

function __valid_name_regex_match(name::String)
    regex_match = match(r"^[\sa-zA-Z0-9_-]*$", name)
    if regex_match !== nothing
        return regex_match.match == name
    end
    return false
end