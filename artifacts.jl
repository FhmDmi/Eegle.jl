# Run this script to generate the Artifacts.toml file,
# which will download and unzip .tar.gz files upon package installation.
# Then, update the dependencies of the package.  
# Notice that in windows these files appears in the explorer as .tar files.
# The .tar.gz files can be hosted, for example, in a github release
# (upload he tar.gz binaries at the bottom of the page for drafting the release
# Once the release published, click with the right button on the tar.gz file 
# and select 'copy the link' to get the link).

# NB: When the package is installed, Artifacts are downloaded in homedir()/.julia/artifacts,
# for example, in C:\\Users\\Marco\\.julia\\artifacts\\8dbb2143f6a996fd8c715c64d8d37ff642ad5f0e\\data_examples
# The directory is accessible within the package as `artifact"data_examples"`,
# where 'data_examples' is the name of the artifact (see code here below).

# To generate a .tar file in Windows, use PowerShell 
# Go in the directory containing the directory to compress (containing data_examples in the example below)
# and run command
# tar -czf data_examples.tar.gz data_examples

using ArtifactUtils, Artifacts
add_artifact!("Artifacts.toml", "data_examples", "https://github.com/Marco-Congedo/Eegle.jl/releases/download/v0.1.1/data_examples.tar.gz", force=true)
# return: SHA1("8dbb2143f6a996fd8c715c64d8d37ff642ad5f0e")

# to add more artifacts, add lines `add-artifact!...`


