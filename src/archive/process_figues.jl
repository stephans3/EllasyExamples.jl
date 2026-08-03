
using CairoMakie
base_path = "results/"

function plot_multiple(tgrid, data_matrix, ylimits)

    n, m = size(data_matrix)

    fig1 = Figure(size=(800,600),fontsize=26)
    
    for i=1:m
        ax = Axis(fig1[m, 1],
            xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
            xtickalign = 1., xticksize = 10, 
            xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
            yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
            ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = (-50, 1850, -0.7, 0.7))
    end

end

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
        ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = (-50, 1850, -0.7, 0.7))
    
    ax2 = Axis(fig1[2, 1], 
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = (-50, 1850, -0.35, 0.35))

    ax3 = Axis(fig1[3, 1], xlabel = "Time t in [s]",
        xlabelsize = 30, ylabelsize = 30, xgridstyle = :dash, ygridstyle = :dash, 
        xtickalign = 1., xticksize = 10, 
        xminorgridvisible = true, xminorticksvisible = true, xminortickalign = 1,
        yminorgridvisible = true, yminorticksvisible = true, yminortickalign = 1,
        ytickalign = 1, yticksize = 10, xlabelpadding = 0, limits = (-50, 1850, -0.35, 0.35))

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

