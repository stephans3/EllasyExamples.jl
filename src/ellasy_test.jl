
using Ellasy
N = 10

Rv, Cv, Lv = 2, 3, 7;

R = Rv*ones(N) 
C = Cv*ones(N)
L = Lv*ones( N)

circuit = :RC_con_L;
lad_val = SingleLadder(N, circuit, Rv, Cv, Lv)
lad_vec = SingleLadder(N, circuit, R, C, L)


fom1 = buildFirstOrderSystem(lad_val)
fom2 = buildFirstOrderSystem(lad_vec)

fom1[1]
fom1[2]
fom1[3]

fom1 .≈ fom2

fom1 = buildFOSubmatrices(lad_val)
fom2 = buildFOSubmatrices(lad_vec)

fom1[1]
fom1[2]
fom1[3]

fom1[1] ≈ fom2[1]
fom1[2] ≈ fom2[2]
fom1[3] ≈ fom2[3]


sys2nd_val = buildSecondOrderSystem(lad_val)
sys2nd_vec = buildSecondOrderSystem(lad_vec)

for j=1:length(sys2nd_val)
    if(length(sys2nd_val[j]) != 0)
        val_check = (sys2nd_val[j] ≈ sys2nd_vec[j])
        println("Value Check j=",j," Equal? ", val_check)
    end
end


sos = buildSecondOrderSystem(lad11)
sos[1]
sos[2]
sos[3]

sos_ab = buildSecondOrderSystem(lad21)
sos_ab[1]
sos_ab[2]
sos_ab[3]

j=2; sos[j] ≈ sos_ab[j]

# lad22 = SingleLadder(N,:LC_con_R, round.(Int,10rand(N)), round.(Int,10rand(N)), round.(Int,10rand(N)))

T1 = getLadderType(lad21)
T2 = getLadderType(lad22)

T1 == T2



lad11 = SingleLadder(N,:LC_con_R, 2, 3, 7)



# exit()