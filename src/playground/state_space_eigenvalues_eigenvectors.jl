# Preprocessing
# Create model

include("input_signals.jl")
include("ladder_systems.jl")
# include("process_figures.jl")

# Options
ladder_type = :RL_con_C # :LC_con_R # :RC_con_L # :RL_con_C;

using Ellasy
N = 100; # Number of circuits
R, C, L = Rational.((2, 3, 5))

ladder = SingleLadder(N,ladder_type, R, C, L)
f_os = Ellasy.firstOrder(ladder)
A = f_os.A

using LinearAlgebra
ei_vals = eigvals(A)
ei_vecs = eigvecs(A)

using Plots
scatter(ei_vals)

heatmap(real.(ei_vecs),
    title="Eigenvector Real Part",
    xlabel="x",
    ylabel="y"
)

heatmap(imag.(ei_vecs),
    title="Eigenvector Imaginary Part",
    xlabel="x",
    ylabel="y"
)

scatter(ei_vecs[:,1])
scatter(ei_vecs[:,65])