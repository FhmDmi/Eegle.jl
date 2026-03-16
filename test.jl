begin
    push!(LOAD_PATH, abspath(@__DIR__, "..") )
    using Revise, Eegle
end

# Select databases according to criterias
corpusDir = "D:\\Travail\\OfficeWork\\FII BCI Corpus\\NY" # path to BCI FII Corpus
classes = ["feet", "right_hand"]; # Select the databases according to the specific MI class for evaluation and classification.
inclusion = (("classes", x -> x == ("left_hand")),
           ("sensors", x -> length(x) >= 16),
           ("perfLHRH.ENLR", x -> 0.6 <= x <= 0.85));
DBs = selectDB(corpusDir, :MI;classes, inclusion, verbose=false);
file = DBs[2].files[1]
o = readNY(file)

o.nTrials
o.perf



_rmArgs