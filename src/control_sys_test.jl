using ControlSystems
using LinearAlgebra

ns = 1:10
A = -diagm(Rational.(vcat(0.5ns)))
B = Rational.(vcat(zeros(length(ns)-1), 1))
C = Rational.(hcat(1, zeros(1,length(ns)-1)))
D = Rational.(zeros(1,1))

sys = ss(A,B,C,D)

ctrb(sys)
isstable(sys)


A*B
A*A
hcat(B, A*B, (A^2)*B)