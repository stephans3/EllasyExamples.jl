#=
    Example of Electrical Ladder with Capacitor as shunt element
=#

# Input Signal
ts = 0.01;
Tf = 3000.0 # 1800.0;
tgrid = 0:ts:Tf
c = 100;
tshift = 7c;
f_in(t,k) = sin(π*k*tanh(t / k))
# d1_f_in(t,k) = π*cos(k*π*tanh(t/k))*(1-tanh(t/k)^2)
# d2_f_in(t,k) = -π^2 * sin(k*π*tanh(t/k)) * (1-tanh(t/k)^2)^2 - (2π/k)*cos(k*π*tanh(t/k))*tanh(t/k)*(1-tanh(t/k)^2)
# u_in(t) = f_in(t-tshift,c)

function stepsignal(t, tstart, tfinish)
    if (t > tstart)  && (t < tfinish)
        return 1
    else
        return 0
    end
end

u_in(t) = stepsignal(t,50,Tf/2)

using Ellasy
N = 10
R, C, L = Rational.((2, 3, 5))
lad = SingleLadder(N,:RL_con_C, R, C, L)

# Second-order system
s_os = secondOrder(lad)
Mc = s_os.M # L*C * T 
Dc = s_os.D # R*C * T
Sc = s_os.S # Finite Diff Stencil
Gc = s_os.G # Right-hand side input weighing vector

# First-order system
f_os = firstOrder(lad)
A = f_os.A
# A[N+1:end,1:N]
# A[N+1:end,N+1:end]

B = f_os.B
Cout = f_os.C

# Simulation
ode(x,p,t) = A*x + B[:,1]*u_in(t)

using OrdinaryDiffEq
alg = Tsit5();
tspan = (0, Tf)
x0 = zeros(2N)
prob = ODEProblem(ode,x0,tspan) 
sol = solve(prob, alg, saveat=ts)
data_sim = transpose(hcat(sol.u[:,:]...))

using CairoMakie
base_path = "results/"

begin
    n_plot = 10;
    data1 = data_sim[1:n_plot:end,2]
    data2 = data_sim[1:n_plot:end,6]
    data3 = data_sim[1:n_plot:end,10]
    tsim = sol.t[1:n_plot:end]

    fig1 = Figure(size=(800,600),fontsize=26)
    ax1 = Axis(fig1[1, 1],
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0 )#, limits = (-50, 1850, -0.7, 0.7))
    
    ax2 = Axis(fig1[2, 1], 
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0)#, limits = (-50, 1850, -0.35, 0.35))

    ax3 = Axis(fig1[3, 1], xlabel = "Time t in [s]",
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0)#, limits = (-50, 1850, -0.35, 0.35))

    println(ax3.limits)
    

    ax1.xticks = 0 : 300 : Tf;
    ax2.xticks = 0 : 300 : Tf;
    ax3.xticks = 0 : 300 : Tf;
    tixx = -0.6 : 0.3 : 0.6; ax1.yticks = (tixx, string.(round.(Int,100tixx)));
    tixx = -0.3 : 0.15 : 0.3; ax2.yticks = (tixx, string.(round.(Int,100tixx)));
    tixx = -0.3 : 0.15 : 0.3; ax3.yticks = (tixx, string.(round.(Int,100tixx)));
    
    hidexdecorations!(ax1, grid = false, ticks = false)
    hidexdecorations!(ax2, grid = false, ticks = false)


    lines!(ax1, tsim, data1;linestyle = :solid, linewidth = 3, label = "n=2")
    axislegend(ax1, position = :rt, backgroundcolor = (:grey90, 0.1));
    lines!(ax2, tsim, data2;linestyle = :solid, linewidth = 3, label = "n=6", color = Makie.wong_colors()[1])
    axislegend(ax2, position = :rt, backgroundcolor = (:grey90, 0.1));
    lines!(ax3, tsim, data3;linestyle = :solid, linewidth = 3, label = "n=10", color = Makie.wong_colors()[1])
    axislegend(ax3, position = :rt, backgroundcolor = (:grey90, 0.1));

    ylabel = Label(fig1[1:3, 0], L"Voltage in [V] $\times 10^{-2}$", rotation = pi/2)
    # current_figure()
    fig1
    # save(base_path*"lines_shunt_capacitor.pdf", fig1, pt_per_unit = 1)    
end

