# Preprocessing
# Create model

include("input_signals.jl")
include("ladder_systems.jl")
# include("process_figures.jl")

# Options
ladder_type =  :RC_con_L # :LC_con_R # :RC_con_L # :RL_con_C;

using Ellasy
N = 10; # Number of circuits
R, C, L = Rational.((2, 3, 5))

# Create ladder model
ladder = SingleLadder(N,ladder_type, R, C, L) # Shunt is Capacitor

tstep  = 100.0;
Tfinal = 1800.0;
c = 100; tshift = 7c;

if ladder_type == :RL_con_C
    u_in(t) = symmetric_sweep(t-tshift,c)
elseif ladder_type == :LC_con_R
    u_in(t) = symmetric_sweep_der1(t-tshift,c)
elseif ladder_type == :RC_con_L
    u_in(t) = symmetric_sweep_der2(t-tshift,c)
end



ode = build_ode_system(ladder, u_in)


# Preprocessing
# Run Simulation
# Save data

tspan = (0,Tfinal)
data_sim, tgrid = simulate_ladder( ode, tspan)

# Postprocessing: 
# Create Figure
# Show Figure
# Save Figure

using CairoMakie, LaTeXStrings
base_path = "results/"

if ladder_type == :RL_con_C
    file_name = "sweep_shunt_capacitor.pdf"

    in_signal = hcat(u_in.(tgrid),zeros(length(tgrid)))
    # in_signal_label = [L"Step $u$"] 
    fig_color = Makie.wong_colors()[1]



    figlimits = [(-50, Tfinal+50, -0.7, 0.7),
                 (-50, Tfinal+50, -0.35, 0.35),
                 (-50, Tfinal+50, -0.35, 0.35)]

    # [start, step, end]            
    figticks = [[ -0.6, 0.3, 0.6],
                [-0.3, 0.15, 0.3],
                [-0.3, 0.15, 0.3],]

    figscaling = 100;
    ttixx = 0 : 300 : Tfinal;


elseif ladder_type == :LC_con_R
    file_name = "sweep_shunt_resistor.pdf"
    fig_color = Makie.wong_colors()[2]

    in_signal = hcat(u_in.(tgrid),zeros(length(tgrid)))
    in_signal_label = [L"Affine $u$", L"Step $\dot{u}$"] 

    # Type: Resistor
    figlimits = [(300, Tfinal+50, -0.7, 0.7), 
                 (300, Tfinal+50, -0.25, 0.25),
                 (300, Tfinal+50, -0.25, 0.25),]

    # [start, step, end, scaling]            
    figticks = [[ -0.6, 0.3, 0.6],
                [-0.2, 0.1, 0.2],
                [-0.2, 0.1, 0.2],]

    figscaling = 100;
    ttixx = 0 : 300 : Tfinal;

elseif ladder_type == :RC_con_L
    file_name = "sweep_shunt_inductor.pdf"
    fig_color = Makie.wong_colors()[3]

    in_signal_label = [L"Quadratic $u$", L"Step $\ddot{u}$"] 

    # Type Shunt = Inductor
    figlimits = [(400, 1100, -0.7, 0.7), 
                (400, 1100, -0.25, 0.25),
                (400, 1100, -0.25, 0.25)]

    # [start, step, end, scaling]            
    figticks = [[ -0.6, 0.3, 0.6],
                [-0.2, 0.1, 0.2],
                [-0.2, 0.1, 0.2],]

    figscaling = 100;
    ttixx = 0 : 150 : Tfinal;
end




# Sweep signal
begin
    fig1 = Figure(size=(800,600),fontsize=26)
    n_plot = 10;
    data1 = data_sim[1:n_plot:end,2]
    data2 = data_sim[1:n_plot:end,6]
    data3 = data_sim[1:n_plot:end,10]
    tsim = tgrid[1:n_plot:end]

    ax1 = Axis(fig1[1, 1],
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = figlimits[1])
    
    ax2 = Axis(fig1[2, 1], 
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = figlimits[2])

    ax3 = Axis(fig1[3, 1], xlabel = "Time t in [s]",
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = figlimits[3])

    

    ax1.xticks = ttixx;
    ax2.xticks = ttixx;
    ax3.xticks = ttixx;
    

    if figscaling == 1
        ax1.yticks = figticks[1][1] : figticks[1][2] : figticks[1][3];
        ax2.yticks = figticks[2][1] : figticks[2][2] : figticks[2][3];
        ax3.yticks = figticks[3][1] : figticks[3][2] : figticks[3][3];

    else
        tixx = figticks[1][1] : figticks[1][2] : figticks[1][3]; ax1.yticks = (tixx, string.(round.(Int,figscaling*tixx)));
        tixx = figticks[2][1] : figticks[2][2] : figticks[2][3]; ax2.yticks = (tixx, string.(round.(Int,figscaling*tixx)));
        tixx = figticks[3][1] : figticks[3][2] : figticks[3][3]; ax3.yticks = (tixx, string.(round.(Int,figscaling*tixx)));
    end


    hidexdecorations!(ax1, grid = false, ticks = false)
    hidexdecorations!(ax2, grid = false, ticks = false)


    lines!(ax1, tsim, data1;linestyle = :solid, linewidth = 3, label = "n=2", color = fig_color)
    axislegend(ax1, position = :rt, backgroundcolor = (:grey90, 0.1));
    lines!(ax2, tsim, data2;linestyle = :solid, linewidth = 3, label = "n=6", color = fig_color)
    axislegend(ax2, position = :rt, backgroundcolor = (:grey90, 0.1));
    lines!(ax3, tsim, data3;linestyle = :solid, linewidth = 3, label = "n=10", color = fig_color)
    axislegend(ax3, position = :rt, backgroundcolor = (:grey90, 0.1));

    
    if figscaling == 1
        label_str = L"Voltage in $[V]$"
    else
        scale_str = string(-Int(log10(figscaling)))
        label_str = L"Voltage in $[V]$ $\times 10^{"*scale_str*L"}$"
        label_str = LaTeXString(label_str)
    end
    ylabel = Label(fig1[1:3, 0], label_str, rotation = pi/2)
    fig1
end

# Export as PDF
# save(path2pdf, fig1, pt_per_unit = 1)    
