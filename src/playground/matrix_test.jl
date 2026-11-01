using Ellasy
N = 10

Rv, Cv, Lv = 2, 3, 7;

R = Rv*ones(N) 
C = Cv*ones(N)
L = Lv*ones( N)

circ1 = :RL_con_C;
circ2 = :LC_con_R;
circ3 = :RC_con_L;

lad1 = SingleLadder(N, circ1, Rv, Cv, Lv)
lad2 = SingleLadder(N, circ2, Rv, Cv, Lv)
lad3 = SingleLadder(N, circ3, Rv, Cv, Lv)

# Second-order system
s_os = secondOrder(lad1)
Mc = s_os.M # L*C * T 
Dc = s_os.D # R*C * T
Sc = s_os.S # Finite Diff Stencil

A1 = -inv(Mc)*Sc
A2 = -inv(Mc)*Dc

-inv(Sc)*Mc