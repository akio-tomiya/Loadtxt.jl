module Loadtxt
export loadtxt

function loadtxt(
    fname::AbstractString;
    dtype::DataType = Float64,
    comments::Union{AbstractString, Char} = "#",
    delimiter::Union{Nothing, AbstractString, Char} = nothing,
    converters::Dict{Int, Function} = Dict{Int, Function}(),
    skiprows::Int = 0,
    usecols::Union{Nothing, Vector{Int}} = nothing,
    unpack::Bool = false,
    ndmin::Int = 0,
    max_rows::Union{Nothing, Int} = nothing
)
    # Convert comments and delimiter to String type
    comments = String(comments)
    delimiter = delimiter === nothing ? nothing : String(delimiter)
    
    data = Vector{Vector{dtype}}()
    
    # Read the file
    lines = open(fname, "r") do file
        readlines(file)
    end
    
    # Remove skipped rows (enclosed in parentheses)
    if skiprows > 0
        # Check that skiprows does not exceed the number of lines in the file
        if skiprows >= length(lines)
            return Array{dtype}(undef, 0, 0)
        end
        lines = lines[(skiprows + 1):end]
    end
    
    row_count = 0
    
    for line in lines
        # Check max_rows
        if max_rows !== nothing && row_count >= max_rows
            break
        end
    
        # Trim whitespace from both ends of the line
        line = strip(line)
    
        # Skip empty lines or comment lines
        if isempty(line) || startswith(line, comments)
            continue
        end
    
        # Remove comments within the line
        comment_pos = findfirst(comments, line)
        if comment_pos !== nothing
            if isa(comment_pos, UnitRange)
                comment_pos = first(comment_pos)
            end
            comment_pos -= 1
            line = strip(line[1:comment_pos])
        end
    
        if isempty(line)
            continue
        end
    
        # Split by delimiter
        if delimiter === nothing
            fields = split(line)
        else
            fields = split(line, delimiter)
        end
    
        # Select necessary columns
        if usecols !== nothing
            # usecols is 1-based, so check the range
            fields = [fields[i] for i in usecols if 1 ≤ i <= length(fields)]
        end
    
        # Apply converters and type conversion
        parsed_fields = Vector{dtype}()
        for (i, field) in enumerate(fields)
            value = ""
            if haskey(converters, i)
                try
                    value = converters[i](field)
                catch e
                    error("Failed to convert with the converter: Value '$field' in column $i")
                end
            else
                try
                    value = parse(dtype, field)
                catch e
                    error("Failed to parse data: Value '$field' in column $i")
                end
            end
            push!(parsed_fields, value)
        end
    
        push!(data, parsed_fields)
        row_count += 1
    end
    
    # Convert data to an array
    if isempty(data)
        return Array{dtype}(undef, 0, 0)
    end
    
    # Convert to a 2D array
    data_array = hcat(data...)'
    
    # Apply ndmin
    while ndims(data_array) < ndmin
        data_array = reshape(data_array, (size(data_array)..., 1))
    end
    
    if unpack
        return tuple([data_array[:, i] for i in 1:size(data_array, 2)]...)
    else
        return data_array
    end
end

end # module Loadtxt
