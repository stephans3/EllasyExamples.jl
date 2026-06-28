struct SingleLadderSimple{T}
    n_circuits :: Int
    circuitType :: Symbol
    R :: T
    C :: T
    L :: T
end

sls = SingleLadderSimple(3,:blubb,3, 2.2, 1)

"""
    Equation
    M x'' + D x' + S x = G μ
"""
struct SecondOrderSystem{T}
    M :: Matrix{T}
    D :: Matrix{T}
    S :: Matrix{T}
    G :: Matrix{T}
    in_deriv_order :: Int # Order of derivative of input signal
end

A1 = round.(Int, 100rand(3,3))
A2 = round.(Int, 100rand(3,3))
A3 = zeros(Int, 1,1) # rand(3,3)
A4 = round.(Int, 100rand(3,1))
sos1 = SecondOrderSystem(A1, A2, A3, A4, 0)

"""
    Equation
    [x' ]   [0  I]  [x ]   [0 ] 
    [   ] = [    ]  [  ] + [  ] μ
    [x'']   [P  Q]  [x']   [Bg]
"""
struct FirstOrderSystem{T}
    P :: Matrix{T}
    Q :: Matrix{T}
    Bg :: Matrix{T}
    in_deriv_order :: Int # Order of derivative of input signal
end

sos1 = FirstOrderSystem(-inv(A1)*A3, -inv(A1)*A2, inv(A1)*A4, 0)

sos1.P
sos1.Q
sos1.Bg