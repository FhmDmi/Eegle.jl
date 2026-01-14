# Tutorials

Running the tutorials is the fastest way to learn how to use **Eegle**.

!!! details "How to copy the code of the tutorials to the Clipboard"
    !!! tip
        To run an entire tutorial, click on the '💻 Full Code' link placed at the top of the page of each tutorial. This will scroll up to the bottom of the page, where the block containing the full code can be copied. Once copied, paste the code (e.g., CTRL+V in Windows) in the REPL or in a .jl script to be run.

Tutorials are organized by theme; start with those that most closely resemble your current research needs:


### Things to know
- We fully-qualify the name of functions (e.g., `FourierAnalysis.spectra`) or report in the text the package where they can be found. This is just to help you find the documentation of these functions if needed. In your code, you don't need to fully-qualify functions at all.

- For producing figures in these tutorials we use `Makie.jl` and some other useful packages. Install them first by executing in the REPL:

```julia
]add CairoMakie, GLMakie, ColorSchemes, Colors
```

!!! note
    For plotting EEG traces we use a dedicated application. A dedicated plotting package for **Eegle** is to come.

---------------------------------------------------------------------------------------------------------------

# Themes

- [Spectral Analysis](@ref)
- [Spatial Filters](@ref)
- [Machine Learning](@ref) 

---------------------------------------------------------------------------------------------------------------

### Spectral Analysis
|Tutorial  | Description|
|:----|:----|
|[Tutorial SA 1](@ref) | compute and plot power spectra on continuous EEG recording |
|[Tutorial SA 2](@ref) | compute and plot power spectra on particular EEG epochs (e.g., experimental trials) |

### Spatial Filters
|Tutorial  | Description|
|:----|:----|
|[Tutorial SF 1](@ref) | construct new filters based on joint diagonalization (GEVD) |

### Machine Learning
|Tutorial  | Description|
|:----|:----|
|[Tutorial ML 1](@ref) | run a cross-validation comparing two Riemannian classifiers |
|[Tutorial ML 2](@ref) | select [databases](@ref "database") and [sessions](@ref "session"); run a cross-validation for all of them |

[Themes](@ref)



