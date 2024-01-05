using Distributions, CausalInference, Graphs
using Test, Random, Statistics, Combinatorics
using LinearAlgebra, StatsBase
using Memoization

include("../src/exact.jl")

function oracle_score(g, parents, v)
    real_parents = inneighbors(g, v)
    return -length(symdiff(parents, real_parents))
end

function exactscorebased(g::SimpleDiGraph; parallel=false, verbose=false)
    n = nv(g)
    exactscorebased(n, (parents, v) -> oracle_score(g, parents, v); parallel, verbose)
end

@testset "exact oracle" begin 
    Random.seed!(58)
    for n in [6, 8, 10, 12, 14, 16, 18]
        println(n)
        for alpha in [0.2, 3/n]
            g = randdag(n, alpha)
            res = exactscorebased(g)
            @assert alt_cpdag(g) == res 
        end 
    end
end

@testset "exact data" begin
    seed = 123
    Random.seed!(seed)
    K = 50
    for k in 1:K
        qu(x) = x * x'
        d = 8
        alpha = 2.5/d
        n = 20000
        penalty = 0.00005
        g = randdag(d, alpha)
        E = Matrix(adjacency_matrix(g)) # Markov operator multiplies from right 
        L = E .* (0.3rand(d, d) .+ 0.3)
        # Do not actually sample but compute true correlation
        Σtrue = Float64.(inv(big.(qu((I - L)))))
        di = sqrt.(diag(Σtrue))
        Ctrue = (Σtrue) ./ (di * di')
        S = GaussianScore(Ctrue, n, penalty)

        @assert g == DiGraph(E)

        cg = alt_cpdag(g)
        @assert cg == exactscorebased(d, (p, v) -> local_score(S, p, v))
    end
end
