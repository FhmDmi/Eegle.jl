# v 0.1 Nov 2019
# Part of the Eegle.jl package.
# Copyright Marco Congedo, CNRS, University Grenoble Alpes.

module Miscellaneous

using PosDefManifold: AnyMatrix
using Eegle.FileSystem: changeFileExt

# ? ¤ CONTENT ¤ ? 

# remove    | remove one or several elements from arrays
# isSquare  | check if a matrix is square
# minima    | local minima of a sequence
# maxima    | local maxima of a sequence
# waste     | free the memory for all objects passed as arguments

import Eegle

# Module REPL text colors
const titleFont     = "\x1b[95m"
const separatorFont = "\x1b[35m"
const defaultFont   = "\x1b[0m"
const greyFont      = "\x1b[90m"

export
    remove,
    isSquare,
    minima,
    maxima,
    waste,
    parseTutorial

"""
```julia
function remove(X::Union{Vector, Matrix}, 
                what::Union{Int, Vector{Int}}; 
    dims=1)
```
Return vector `X` removing one or more elements, or matrix `X` removing one or more
columns or rows.

If `X` is a matrix, `dims`=1 (default) remove rows,
`dims`=2 remove columns.

If `X` is a Vector, `dims` has no effect.

The `what` argument can be either an integer or a vector of integers

**See Also** [`Eegle.Preprocessing.removeSamples`](@ref), [`Eegle.Preprocessing.removeChannels`](@ref)

**Examples**
```julia
using Eegle # or using Eegle.Miscellaneous

a=randn(5)
b=remove(a, 2) # remove second element
b=remove(a, collect(1:3)) # remove rows 1 to 3

A=randn(3, 3)
B=remove(A, 2) # remove second row
B=remove(A, 2; dims=2) # remove second column

A=randn(5, 5)
B=remove(A, collect(1:2:5)) # remove rows 1, 3 and 5
C=remove(A, [1, 4]) # remove rows 1 and 4

# remove columns 2, 3, 8, 9, 10
A=randn(10, 10)
B=remove(A, [collect(2:3); collect(8:10)]; dims=2)

# remove every other sample (decimation by a factor of 2)
A=randn(10, 10)
B=remove(A, collect(1:2:size(A, 1)); dims=1)

# NB: before decimating the data must be low-pass filtered,
# see the documentation of `resample`
```
"""
function remove(X::Union{Vector, Matrix}, what::Union{Int, Vector{Int}}; dims=1)
    1<dims<2 && throw(ArgumentError("function `remove`: the `dims` keyword argument must be 1 or 2"))
    di = X isa Vector ? 1 : dims
    d = size(X, di)
    mi, ma = minimum(what), maximum(what)
    (1≤mi≤d && 1≤ma≤d) || throw(ArgumentError("function `remove`: the second argument must hold elements comprised in between 1 and $d. Check also the `dims` keyword"))
    b = filter(what isa Int ? x->x≠what : x->x∉what, 1:d)
    return X isa Vector ? X[b] : X[di==1 ? b : 1:end, di==2 ? b : 1:end]
end

"""
```julia
function isSquare(X)
```
Return true if `X` is an [AnyMatrix](https://marco-congedo.github.io/PosDefManifold.jl/stable/MainModule/#AnyMatrix-type)
and is square, false otherwise.
"""
function isSquare(X) 
  X isa PosDefManifold.AnyMatrix && (size(X, 1)==size(X, 2))
end


"""
```julia
function minima(v::AbstractVector{T}) 
where T<:Real
```
Return the 2-tuple formed by the vector of local minima of vector `v` and the
vector of the indices of `v` corresponding to the minima.

This is useful in several situations. For example, **Eegle** uses it to segment spontaneous EEG data (see [`Eegle.Processing.epoching`](@ref)).
"""
function minima(v::AbstractVector{T}) where T<:Real
    m=Int[]
    value=Float64[]
    for i=2:length(v)-1
        if v[i-1]>v[i]<v[i+1] 
            push!(m, i)
            push!(value, v[i])
        end
    end
    return m, value
end

"""
```julia
function maxima(v::AbstractVector{T}) 
where T<:Real
```
Return the 2-tuple formed by the vector of local maxima of vector `v` and the
vector of the indices of `v` corresponding to the maxima.

"""
function maxima(v::AbstractVector{T}) where T<:Real
    m=Int[]
    value=Float64[]
    for i=2:length(v)-1
        if v[i-1]<v[i]>v[i+1] 
            push!(m, i)
            push!(value, v[i])
        end
    end
    return m, value
end


"""
```julia
function waste(args...)
```
Force garbage collector to free memory for all arguments passed as `args...`.

The arguments can be of any type. See [here](https://github.com/JuliaCI/BenchmarkTools.jl/pull/22)

**Examples**
```julia
using Eegle # or using Eegle.Miscellaneous

A = randn(1000, 1000)
b = randn(10000)

waste(A, b)

```
"""
function waste(args...)
  for a in args a=nothing end
  for i=1:4 GC.gc(false) end
end

# exported to be used by Documenter.jl to
# - extract the julia code blocks from tutorial markdown file given ad `mdfile`
# - print the code in a @example block in the tutorials file
# this allow the user to copy the whole tutorial code
function parseTutorial(mdfile::String)
    # Construct path
    path = joinpath(
        abspath(@__DIR__, ".."),
        "docs", "src", "Tutorials",
        changeFileExt(mdfile, ".md")
    )

    isfile(path) || throw(ArgumentError(
        "Function Eegle.Miscellaneous.parseTutorial: File not found: $path. Please check the spelling."))

    # Read raw markdown
    text = read(path, String)

    # Regex: ```julia ... ```
    julia_fence = r"```julia\s*(?s)(.*?)```"

    blocks = String[]
    block_separator_added = false
    
    for m in eachmatch(julia_fence, text)
        # Get raw code content and normalize line endings
        raw_code = m.captures[1]
        lines = split(replace(raw_code, "\r\n" => "\n"), "\n", keepempty=false)
        
        # Add separator if this is not the first block
        if !isempty(blocks) && !block_separator_added
            push!(blocks, "")  # blank line
            block_separator_added = true
        end
        
        # Preserve ALL original whitespace - just split by lines
        for line in lines
            push!(blocks, line * "\n")
        end
        
        block_separator_added = false  # reset for next block
    end

    for block in blocks
        isempty(block) ? println() : print(block)
    end
    return nothing
end

end # module
