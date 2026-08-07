
include("input_signals.jl")

ts = 0.01; # Sampling time
Tfinal = 1800.0;
tgrid = 0:ts:Tfinal
c = 100; tshift = 7c;

u_in0(t) = symmetric_sweep(t-tshift,c)
u_in1(t) = symmetric_sweep_der1(t-tshift,c) # f_in(t-7c,c)
u_in2(t) = symmetric_sweep_der2(t-tshift,c) # f_in(t-7c,c)

u_data = hcat(u_in0.(tgrid), u_in1.(tgrid), u_in2.(tgrid))

using CairoMakie
base_path = "results/"

begin
    n_plot = 10;
    data1 = u_data[1:n_plot:end,1]
    data2 = u_data[1:n_plot:end,2]
    data3 = u_data[1:n_plot:end,3]
    tsim = tgrid[1:n_plot:end]

    fig1 = Figure(size=(800,600),fontsize=26)
    ax1 = Axis(fig1[1, 1],
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = (-50, 1850, -1.2, 1.2))
    
    ax2 = Axis(fig1[2, 1], 
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = (-50, 1850, -3.8, 3.8))

    ax3 = Axis(fig1[3, 1], xlabel = "Time t in [s]",
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = (-50, 1850, -11, 11))
    
    ttixx = 0 : 300 : Tfinal
    ax1.xticks = ttixx;
    ax2.xticks = ttixx;
    ax3.xticks = ttixx;
    
    tixx = -1.0 : 0.5 : 1.0; ax1.yticks = tixx # (tixx, string.(round.(Int,tixx)));
    tixx = -3 : 1.5 : 3.5; ax2.yticks = tixx # (tixx, string.(round.(Int,tixx)));
    tixx = -10 : 5 : 10; ax3.yticks = tixx # (tixx, string.(round.(Int,tixx)));

    hidexdecorations!(ax1, grid = false, ticks = false)
    hidexdecorations!(ax2, grid = false, ticks = false)


    lines!(ax1, tsim, data1;linestyle = :solid, linewidth = 3, label = L"Original $\mu = u$")
    axislegend(ax1, position = :rt, backgroundcolor = (:grey90, 0.1));
    lines!(ax2, tsim, data2;linestyle = :solid, linewidth = 3, label = L"1. Derivative $\mu = \dot{u}$", color = Makie.wong_colors()[2])
    axislegend(ax2, position = :rt, backgroundcolor = (:grey90, 0.1));
    lines!(ax3, tsim, data3;linestyle = :solid, linewidth = 3, label = L"2. Derivative $\mu = \ddot{u}$", color = Makie.wong_colors()[3])
    axislegend(ax3, position = :rt, backgroundcolor = (:grey90, 0.1));

    #ylabel = Label(fig1[1:3, 0], L"Voltage in [V]", rotation = pi/2)
    fig1
    #save(base_path*"input_signal.pdf", fig1, pt_per_unit = 1)    
end