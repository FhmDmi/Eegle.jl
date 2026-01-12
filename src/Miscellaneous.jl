module Miscellaneous

using PosDefManifold: AnyMatrix
using Eegle.FileSystem: changeFileExt

import Eegle

# Module REPL text colors
const titleFont     = "\x1b[95m"
const separatorFont = "\x1b[35m"
const defaultFont   = "\x1b[0m"
const greyFont      = "\x1b[90m"

export
    minima,
    maxima,
    waste,
    parseTutorial


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
