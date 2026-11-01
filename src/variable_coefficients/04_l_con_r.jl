import Ellasy
N = 10

Rv, Cv, Lv = 2, 3, 7;

R = collect(1 : ((Rv-1)/(N-1)) : Rv) # Rv*ones(N) 
C = collect(1 : ((Cv-1)/(N-1)) : Cv) # Cv*ones(N)
L = collect(1 : ((Lv-1)/(N-1)) : Lv) # Lv*ones( N)

circuit = :L_con_R;
ladder = Ellasy.SingleLadder(N, circuit, R, C, L)

sys_so = Ellasy.secondOrder(ladder)

M₀ = sys_so.M
D₀ = sys_so.D
S₀ = sys_so.S

# firstOrderSubmatrices is not implemented for this circuit
mat_fo = Ellasy.firstOrderSubmatrices(ladder)

sys_fo = Ellasy.firstOrder(ladder)
A₀ = sys_fo.A
B₀ = sys_fo.B
C₀ = sys_fo.C

-inv(M₀)*D₀ ≈ A₀