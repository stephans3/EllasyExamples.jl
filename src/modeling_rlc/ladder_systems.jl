import Ellasy
import OrdinaryDiffEq

function build_ode_system( ladder, input_signal )

    f_os = Ellasy.firstOrder(ladder)
    A = f_os.A
    B = f_os.B
    u_in = input_signal
    ode = (x,p,t) -> A*x + B[:,1]*u_in(t)

    return ode
end


function simulate_ladder(ode, tspan; tsampling=0.01, alg_sol = OrdinaryDiffEq.Tsit5())
    x0 = zeros(2N)
    prob = OrdinaryDiffEq.ODEProblem(ode,x0,tspan) 
    sol = OrdinaryDiffEq.solve(prob, alg_sol, saveat=tsampling)
    data = transpose(hcat(sol.u[:,:]...))
    tgrid = sol.t[:]
    return data, tgrid
end
