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
    # comments と delimiter を String 型に変換
    comments = String(comments)
    delimiter = delimiter === nothing ? nothing : String(delimiter)
    
    data = Vector{Vector{dtype}}()
    
    # ファイルを読み込む
    lines = open(fname, "r") do file
        readlines(file)
    end
    
    # スキップする行を削除（括弧で囲む）
    if skiprows > 0
        # skiprows がファイルの行数を超えないようにチェック
        if skiprows >= length(lines)
            return Array{dtype}(undef, 0, 0)
        end
        lines = lines[(skiprows + 1):end]
    end
    
    row_count = 0
    
    for line in lines
        # max_rowsを確認
        if max_rows !== nothing && row_count >= max_rows
            break
        end
    
        # 行の前後の空白を削除
        line = strip(line)
    
        # 空行またはコメント行をスキップ
        if isempty(line) || startswith(line, comments)
            continue
        end
    
        # 行内のコメントを削除
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
    
        # デリミタで分割
        if delimiter === nothing
            fields = split(line)
        else
            fields = split(line, delimiter)
        end
    
        # 必要な列を選択
        if usecols !== nothing
            # usecols は 1始まりなので、範囲内かチェック
            fields = [fields[i] for i in usecols if 1 ≤ i <= length(fields)]
        end
    
        # コンバータと型変換を適用
        parsed_fields = Vector{dtype}()
        for (i, field) in enumerate(fields)
            value = ""
            if haskey(converters, i)
                try
                    value = converters[i](field)
                catch e
                    error("コンバータでの変換に失敗しました: 列 $i の値 '$field'")
                end
            else
                try
                    value = parse(dtype, field)
                catch e
                    error("データのパースに失敗しました: 列 $i の値 '$field'")
                end
            end
            push!(parsed_fields, value)
        end
    
        push!(data, parsed_fields)
        row_count += 1
    end
    
    # データを配列に変換
    if isempty(data)
        return Array{dtype}(undef, 0, 0)
    end
    
    # 2次元配列に変換
    data_array = hcat(data...)'
    
    # ndminを適用
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
