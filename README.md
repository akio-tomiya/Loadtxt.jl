# Loadtxt.jl
This is a package for loading a file.

Let us consider a file ``Plaquette.txt`` is like,
```
0  1.0 # plaq
1  0.6854375345806106 # plaq
2  0.6112020484663069 # plaq
3  0.5892058139713018 # plaq
4  0.5755750821561645 # plaq
5  0.5644999193762664 # plaq
```
and you can load this file *a la* numpy loadtxt.

You will get
```
julia> fname = "Plaquette.txt"
julia> loadtxt(fname)
5×2 adjoint(::Matrix{Float64}) with eltype Float64:
   0.0  1.0
   1.0  0.685438
   2.0  0.611202
   3.0  0.589206
   4.0  0.575575
   5.0  0.5645
```

```
julia> data = loadtxt(fname)
julia> data[:,2]
5-element Vector{Float64}:
 1.0
 0.6854375345806106
 0.6112020484663069
 0.5892058139713018
 0.5755750821561645
 0.5644999193762664
```

If you want to make a plot of this file,
```
julia> using Plots
julia> plot(data[:,1],data[:,2])
```

# Details
Here is the continuation of your `README.md` with a detailed explanation of the function's arguments and default behavior:

```markdown
## Function Arguments and Default Behavior

### `loadtxt(fname::AbstractString; dtype::DataType=Float64, comments::Union{AbstractString, Char}="#", delimiter::Union{Nothing, AbstractString, Char}=nothing, converters::Dict{Int, Function}=Dict{Int, Function}(), skiprows::Int=0, usecols::Union{Nothing, Vector{Int}}=nothing, unpack::Bool=false, ndmin::Int=0, max_rows::Union{Nothing, Int}=nothing)`

The `loadtxt` function provides a flexible and powerful way to load data from a text file, similar to NumPy's `loadtxt` function in Python. Below is a description of each argument and its default behavior:

- **`fname`**: The filename or path to the file that you want to load. This is the only required argument.
  
- **`dtype`**: The data type for the returned array. The default is `Float64`. You can change this to `Int`, `String`, or any other appropriate Julia data type.
  
- **`comments`**: A character or string that marks the start of a comment in the file. The default is `"#"`. Any text following this character in a line will be ignored during parsing.

- **`delimiter`**: The string or character that separates the columns in the file. The default is `nothing`, which means that any whitespace (spaces or tabs) will be treated as a delimiter. For comma-separated values, set `delimiter=","`.

- **`converters`**: A dictionary of column indices (1-based) to functions that will be applied to the data in those columns. This allows for custom transformations of the data as it is read. The default is an empty dictionary, meaning no conversion is applied.

- **`skiprows`**: The number of lines to skip at the beginning of the file. This is useful if your file contains headers or other non-data information at the top. The default is `0`, meaning no lines are skipped.

- **`usecols`**: A vector of column indices (1-based) specifying which columns to read from the file. The default is `nothing`, which means all columns will be read.

- **`unpack`**: A boolean that, if `true`, returns the columns as separate arrays (similar to unpacking in Python). The default is `false`, which returns a single matrix.

- **`ndmin`**: The minimum number of dimensions that the returned array should have. The default is `0`, meaning the array will have the minimum number of dimensions required to contain the data.

- **`max_rows`**: The maximum number of rows to read from the file. The default is `nothing`, which means all rows will be read.

### Examples

#### Loading Data with Specific Delimiter
If you have a CSV file and want to load it using a comma as the delimiter, you can do:

```julia
julia> fname = "data.csv"
julia> data = loadtxt(fname, delimiter=",")
```

#### Skipping Rows
To skip the first three rows of a file:

```julia
julia> data = loadtxt(fname, skiprows=3)
```

#### Using Converters
To apply a conversion function to the first column (e.g., multiply by 10):

```julia
julia> converters = Dict(1 => (x -> parse(Float64, x) * 10))
julia> data = loadtxt(fname, converters=converters)
```

#### Selecting Specific Columns
To load only the first and third columns:

```julia
julia> data = loadtxt(fname, usecols=[1, 3])
```

#### Enforcing a Minimum Dimension
To ensure the returned data has at least 2 dimensions:

```julia
julia> data = loadtxt(fname, ndmin=2)
```

By customizing these arguments, `loadtxt` allows you to handle a wide range of file formats and data structures, making it a versatile tool for loading data in Julia.
```

This extended explanation provides detailed guidance on how to use the `loadtxt` function, covering each argument's purpose and how to customize the function to suit various needs.
