
# CLASS Configuration -----------------------------------------------------------------------

struct Configuration
    buses::Buses
    lines::Lines
    hydros::Hydros
    # thermals::Thermals
end

function Configuration(d::Dict{String,Any}; e::CompositeException = CompositeException())
    # Keys and types validation
    __validate_configuration_keys_types!(d, e)

    # Content validation
    buses_d = __validate_system_entities_content!(d["buses"], e)
    lines_d = __validate_system_entities_content!(d["lines"], e)
    hydros_d = __validate_system_entities_content!(d["hydros"], e)
    # thermals_d = __validate_system_entities_content!(d["thermals"], e)

    buses = Buses(buses_d; e = e)
    lines = Lines(lines_d, buses; e = e)
    hydros = Hydros(hydros_d, buses; e = e)
    # thermals = Thermals(__read_replacing_default_values(d["thermals"]), buses; e = e)
    return Configuration(buses, lines, hydros)
end

function Configuration(filename::String; e::CompositeException = CompositeException())
    d = read_jsonc(filename)
    return Configuration(d; e = e)
end
