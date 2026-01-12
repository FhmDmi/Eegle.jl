println("\x1b[95m", "\nTesting module Eegle.ERPs.jl...", "\x1b[0m")

## mean: just executed
@testset "mean                           " begin
    sr, wl, ne = 128, 128, 19 
    ns = sr*20
    X = randn(ns, ne)
    stim = zeros(Int, ns)
    # simulate stimulations for three classes
    for i = 1:20
        stim[rand(1:ns-wl)] = rand(1:3)
    end
    mark = stim2mark(stim, wl)

    M = mean(X, wl, mark; overlapping=true, weights=:a)
    M = mean(X, wl, mark; overlapping=false)
end;

## stim2mark and mark2stim
@testset "stim2mark and mark2stim        " begin
    sr, wl = 128, 256 # sampling rate, window length of trials
    ns = sr*100 # number of samples of the recording
    # simulate stimulations for three classes
    stim = vcat([rand()<0.01 ? rand(1:3) : 0 for i = 1:ns-wl], zeros(Int, wl))
    mark = stim2mark(stim, wl)
    stim2 = mark2stim(mark, ns)
    @test norm(stim.-stim2) ≈ 0

    # with offset
    sr, wl = 128, 256 # sampling rate, window length of trials
    ns = sr*100 # number of samples of the recording
    # simulate stimulations for three classes
    stim = vcat([rand()<0.01 ? rand(1:3) : 0 for i = 1:ns-wl], zeros(Int, wl))
    for off = 1:32 # check for many offsets
        mark = stim2mark(stim, wl; offset = 3)
        stim2 = mark2stim(mark, ns; offset = -3)
        @test norm(stim.-stim2) ≈ 0
    end
end;

## merge
@testset "merge                          " begin
    mark =  [   [128, 367], 
                [245, 765, 986],
                [467, 880, 1025, 1456],
                [728, 1230, 1330, 1550, 1980],  
            ]
    merged = merge(mark, [[1, 2], [3, 4]])
    @test merged[1] == [128, 245, 367, 765, 986] && merged[2] == [467, 728, 880, 1025, 1230, 1330, 1456, 1550, 1980]
end;


## trials
@testset "trials                         " begin  
    # Example P300 BCI session 
    o = readNY(EXAMPLE_P300_1)

    # Extract 1-s trials starting at samples specified in `mymark`
    mymark = [[245, 658, 987], [258, 758, 1987]]

    # since `shape=:cat` (default),
    # `𝐗` will hold the six trials concatenated 
    𝐗 = trials(o.X, mymark, o.sr)

    𝐗_ =    [o.X[245:245+o.sr-1, :], o.X[658:658+o.sr-1, :], o.X[987:987+o.sr-1, :],
            o.X[258:258+o.sr-1, :], o.X[758:758+o.sr-1, :], o.X[1987:1987+o.sr-1, :]]

    @test mean(norm(X-X_) for (X, X_) ∈ zip(𝐗, 𝐗_)) ≈ 0 
end;

## trialsWeights
@testset "trialsWeights                  " begin
    o = readNY(EXAMPLE_P300_1)

    weights = trialsWeights(o.X, o.mark, o.wl) 

    # weights[1] and weights[2] are the weights for class
    # "non-target" and "target", respectively.

    # The mean of weights within each class is 1
    @test mean(weights[1]) ≈ 1
    @test mean(weights[2]) ≈ 1
end;


## reject
@testset "reject                         " begin
    o = readNY(EXAMPLE_P300_1)

    R = reject(o.X, o.stim, o.wl; upperLimit=1.2, returnDetails = true) # R is a tuple of 9 objects

    @test norm((R[1].+R[2]).-o.stim) ≈ 0 
end;




