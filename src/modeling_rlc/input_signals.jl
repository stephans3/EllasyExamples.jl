# Step signal: is 1 if t ∈ [tstart, tfinish] ; else is 0
stepsignal(t,tstart,tfinish) = ((t > tstart)  && (t < tfinish)) ? 1 : 0;

affinesignal(t,tstart,tfinish) = ((t > tstart)  && (t < tfinish)) ? (t-tstart)/(tfinish-tstart) : 0;
quadraticsignal(t,tstart,tfinish) = ((t > tstart)  && (t < tfinish)) ? (t^2 - 2*t*tstart)/(2*(tfinish - tstart)) : 0;


# Triangular input signal: starting at tstart with 0; peak at tpeak with 1, finish at tfinish with 0
function triangularsignal(t,tstart, tpeak,tfinish) 
    if t<tstart || t>tfinish
        return 0;
    elseif t>=tstart && t<tpeak
        return (t-tstart) / (tpeak-tstart)
    else
        return 1 - ((t-tpeak) / (tfinish - tpeak))
    end
end

# Symmetric sweep function 
symmetric_sweep(t,k) = sin(π*k*tanh(t / k))
symmetric_sweep_der1(t,k) = π*cos(k*π*tanh(t/k))*(1-tanh(t/k)^2)
symmetric_sweep_der2(t,k) = -π^2 * sin(k*π*tanh(t/k)) * (1-tanh(t/k)^2)^2 - (2π/k)*cos(k*π*tanh(t/k))*tanh(t/k)*(1-tanh(t/k)^2)