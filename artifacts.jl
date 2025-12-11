# Run this script to generate the Artifacts.toml file,
# which will download and unzip .tar files upon package installation.  
# The .tar zipped files can be hosted, for example, in a github release.

# NB: Artifacts are downloaded in homedir()/.julia/artifacts
# The directory is accessible within the package as `artifact"data_examples"`,
# where 'data_examples' is the name of the artifact (see code here below).

using ArtifactUtils, Artifacts
add_artifact!("Artifacts.toml", "data_examples", "https://github.com/FhmDmi/Eegle-Tools/releases/download/v0.0.1/data_examples.tar.gz", force=true)
# return: SHA1("f8b81c2ccae7bb1cd1caa23bf7dfc487fa4fb47f")

# to add more artifacts, add lines `add-artifact!...`


