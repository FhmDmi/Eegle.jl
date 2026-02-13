module Eegle

using PrecompileSignatures: @precompile_signatures

using Reexport

# Eegle Basic Eco-System
@reexport using CovarianceEstimation,
                Diagonalizations,
                Distributions,
                DSP,
                FourierAnalysis,
                LinearAlgebra,
                NPZ,
                PermutationTests,
                PosDefManifold, 
                PosDefManifoldML, 
                Statistics,
                StatsBase

# Module REPL text colors
const titleFont     = "\x1b[95m"
const separatorFont = "\x1b[35m"
const defaultFont   = "\x1b[0m"
const greyFont      = "\x1b[90m"

# Artifacts 
using Artifacts, ArtifactUtils

# Artifacts : Example data
const EXAMPLE_DATA_DIR = joinpath(Eegle.artifact"data_examples", "data_examples") # not exported

# `example_data` Artifacts. These paths are all exported
const EXAMPLE_P300_1 = joinpath(EXAMPLE_DATA_DIR, "P300", "subject_01_session_01.npz")
const EXAMPLE_MI_1 = joinpath(EXAMPLE_DATA_DIR, "MI", "AlexMI_subject_03_session_01.npz")
const EXAMPLE_MI_1_metadata = joinpath(EXAMPLE_DATA_DIR, "MI", "AlexMI_subject_03_session_01.yml")
const EXAMPLE_Normative_1 = joinpath(EXAMPLE_DATA_DIR, "Normative", "EC", "F_20_19e_128sr.txt")
const EXAMPLE_Normative_1_sensors = joinpath(EXAMPLE_DATA_DIR, "Normative", "EC", "F_20_19e_128sr_sensors.txt")

#= old way without artifacts
const EXAMPLE_P300_1 = joinpath(@__DIR__, "..", "data_examples", "P300", "subject_01_session_01.npz")
...
=#

export Eegle,
# Example data, see constants here above
EXAMPLE_P300_1,
EXAMPLE_MI_1,
EXAMPLE_MI_1_metadata,
EXAMPLE_Normative_1,
EXAMPLE_Normative_1_sensors


include("FileSystem.jl");       @reexport using .FileSystem
include("Miscellaneous.jl");    @reexport using .Miscellaneous
include("Preprocessing.jl");    @reexport using .Preprocessing
include("Processing.jl");       @reexport using .Processing
# modules with internal dependencies
include("ERPs.jl");             @reexport using .ERPs
include("InOut.jl");            @reexport using .InOut
include("BCI.jl");              @reexport using .BCI
include("Database.jl");         @reexport using .Database

# Generate and run `precompile` directives.
@precompile_signatures(Eegle)

# Welcome Message
println()
print("                      🦅")
println("\x1b[0m","
⣴⣿⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛","\x1b[95m","⠛⠛⠛⠛⠛⠛","\x1b[0m","⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⣿⣦","\x1b[35m", "
⣿⣿","\x1b[38;5;231m","  𝑾  𝒆 𝒍 𝒄 𝒐 𝒎  𝒆   𝒕𝒐   𝑬 𝒆 𝒈 𝒍 𝒆 . 𝒋 𝒍","\x1b[35m","  ⣿⣿","\x1b[0m","
⠻⣿⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤","\x1b[95m","⣤⣤⣤⣤⣤⣤","\x1b[0m","⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣤⣿⠟","\x1b[90m", "
  https://github.com/Marco-Congedo/Eegle.jl
","\x1b[0m")

end # module
