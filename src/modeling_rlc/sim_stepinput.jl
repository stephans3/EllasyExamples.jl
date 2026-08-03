# Preprocessing
# Create model

include("input_signals.jl")
include("ladder_systems.jl")
# include("process_figures.jl")

# Options
ladder_type = :RL_con_C # :LC_con_R # :RC_con_L # :RL_con_C;
signal_type = :in_step;

using Ellasy
N = 10; # Number of circuits
R, C, L = Rational.((2, 3, 5))

# Create ladder model
ladder = SingleLadder(N,ladder_type, R, C, L) # Shunt is Capacitor

tstep = 100.0;
Tfinal = 3000.0;

u_in(t) = stepsignal(t, tstep, Tfinal/2);
# u_in2(t) = affinesignal(t, tstep, Tfinal/2)
# u_in3(t) = quadraticsignal(t, tstep, Tfinal/2)

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

if ladder_type == :RL_con_C && signal_type == :in_step
    file_name = "step_shunt_capacitor.pdf"

    in_signal = hcat(u_in.(tgrid),zeros(length(tgrid)))
    in_signal_label = [L"Step $u$"] 
    fig_color = Makie.wong_colors()[1]



    figlimits = [(-50, Tfinal+150, -0.1, 1.1),
                 (-50, Tfinal+150, -0.1, 1.1)]

    # [start, step, end]            
    figticks = [[0,0.5,1],
                [0,0.5,1]]

    figscaling = 1;

elseif ladder_type == :RL_con_C && signal_type == :in_sweep
    file_name = "sweep_shunt_capacitor.pdf"
    fig_color = Makie.wong_colors()[1]


elseif ladder_type == :LC_con_R && signal_type == :in_step
    file_name = "step_shunt_resistor.pdf"
    fig_color = Makie.wong_colors()[2]

    in_signal = hcat(u_in.(tgrid),zeros(length(tgrid)))
    in_signal_label = [L"Affine $u$", L"Step $\dot{u}$"] 

    # Type: Resistor
    figlimits = [(-50, Tfinal+150, -2.2, 2.2), 
                (-50, Tfinal+150, -0.12, 0.12)]

    # [start, step, end, scaling]            
    figticks = [[-2, 1, 2],
                [-0.1,0.1,0.1]]

    figscaling = 10;


elseif ladder_type == :LC_con_R && signal_type == :in_sweep
    file_name = "sweep_shunt_resistor.pdf"
    fig_color = Makie.wong_colors()[2]

elseif ladder_type == :RC_con_L && signal_type == :in_step
    file_name = "step_shunt_inductor.pdf"
    fig_color = Makie.wong_colors()[3]

    in_signal_label = [L"Quadratic $u$", L"Step $\ddot{u}$"] 

    # Type Shunt = Inductor
    figlimits = [(-50, Tfinal+150, -2.1, 2.1), 
                (-50, Tfinal+150, -0.012, 0.012)]

    # [start, step, end, scaling]            
    figticks = [[-2,1,2],
                [-0.01,0.005,0.01]]

    figscaling = 1000;
elseif ladder_type == :RC_con_L && signal_type == :in_sweep
    file_name = "sweep_shunt_inductor.pdf"
    fig_color = Makie.wong_colors()[3]
end

path2pdf = base_path*file_name


begin
    fig1 = Figure(size=(800,450),fontsize=26) # Figure(size=(800,600),fontsize=26)
    n_plot = 10;
    data1 = data_sim[1:n_plot:end,2]
    data2 = data_sim[1:n_plot:end,10]
    # data3 = data_sim[1:n_plot:end,10]
    tsim = tgrid[1:n_plot:end]

    ax1 = Axis(fig1[1, 1],
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = figlimits[1])
    
    ax2 = Axis(fig1[2, 1], xlabel = "Time t in [s]",
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = figlimits[2])


    

    ax1.xticks = 0 : 500 : Tfinal;
    ax2.xticks = 0 : 500 : Tfinal;
    

    if figscaling == 1
        ax1.yticks = figticks[1][1] : figticks[1][2] : figticks[1][3];
        ax2.yticks = figticks[2][1] : figticks[2][2] : figticks[2][3];

    else
        tixx = figticks[1][1] : figticks[1][2] : figticks[1][3]; ax1.yticks = (tixx, string.(round.(Int,figscaling*tixx)));
        tixx = figticks[2][1] : figticks[2][2] : figticks[2][3]; ax2.yticks = (tixx, string.(round.(Int,figscaling*tixx)));
    end


    hidexdecorations!(ax1, grid = false, ticks = false)
    # hidexdecorations!(ax2, grid = false, ticks = false)


    lines!(ax1, tsim, data1;linestyle = :solid, linewidth = 3, label = "n=2", color = fig_color)
    axislegend(ax1, position = :rt, backgroundcolor = (:grey90, 0.1));
    lines!(ax2, tsim, data2;linestyle = :solid, linewidth = 3, label = "n=10", color = fig_color)
    axislegend(ax2, position = :rt, backgroundcolor = (:grey90, 0.1));

    
    if figscaling == 1
        label_str = L"Voltage in $[V]$"
    else
        scale_str = string(-Int(log10(figscaling)))
        label_str = L"Voltage in $[V]$ $\times 10^{"*scale_str*L"}$"
        label_str = LaTeXString(label_str)
    end
    ylabel = Label(fig1[1:2, 0], label_str, rotation = pi/2)
    fig1
end


# Export as PDF
save(path2pdf, fig1, pt_per_unit = 1)    


# Step input
begin
    fig1 = Figure(size=(800,250),fontsize=26) # Figure(size=(800,600),fontsize=26)
    n_plot = 10;
    data1 = u_in.(tgrid[1:n_plot:end])

    tsim = tgrid[1:n_plot:end]

    ax1 = Axis(fig1[1, 1], xlabel = "Time t in [s]",
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = (-50, Tfinal+150, -0.1, 1.1))
   
    ax1.xticks = 0 : 500 : Tfinal;
    lines!(ax1, tsim, data1;linestyle = :solid, linewidth = 4, label = "Step Input", color = Makie.wong_colors()[4])
    axislegend(ax1, position = :rt, backgroundcolor = (:grey90, 0.1));
    
    label_str = L"Voltage in $[V]$"
    ylabel = Label(fig1[1, 0], label_str, rotation = pi/2)
    fig1

    save(base_path*"step_signal.pdf", fig1, pt_per_unit = 1)    
end


